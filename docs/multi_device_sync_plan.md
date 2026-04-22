# Multi-Device Sync Plan — MediTime

**Status:** Design (not started)
**Backend:** Supabase (Postgres + Auth + Realtime + RLS)
**Auth:** Email + password (Supabase Auth)
**Local DB:** Drift/SQLite stays as source of truth on-device; remote is the fan-out point
**Primary scenario:** One family account signed in on multiple devices. Son installs on Mom's phone, Dad's phone, and his own — three profiles (Mom, Dad, Son) sync across all three devices so son can monitor his parents' medicine routines.

---

## 1. Current State (snapshot)

- Local-only persistence via Drift/SQLite ([`lib/core/storage/app_database.dart`](../lib/core/storage/app_database.dart)). Medicines, profiles, dose logs, prescriptions all live on-device.
- Profile system exists ([`lib/features/profile/presentation/cubit/profile_cubit.dart`](../lib/features/profile/presentation/cubit/profile_cubit.dart)) with a `profileId` foreign key on medicines. All profiles currently live in a single device's DB.
- Remote datasources are stubs (`UnimplementedError`):
  - [`lib/features/medicines/data/datasources/medicine_remote_datasource.dart`](../lib/features/medicines/data/datasources/medicine_remote_datasource.dart)
  - [`lib/features/profile/data/datasources/profile_remote_datasource.dart`](../lib/features/profile/data/datasources/profile_remote_datasource.dart)
- `syncFromRemote` / `syncToRemote` in repos swallow the `UnimplementedError`.
- **No** authentication, **no** account concept, **no** device identifier, **no** `updatedAt` / `deletedAt` timestamps anywhere.
- Notifications and alarms are local (`flutter_local_notifications`, `alarm` package), scheduled per-device off the local DB.

---

## 2. Concept Model

- **Account** = one Supabase user (email + password). Household-scoped — son signs in with the same account on all three phones.
- **Profile** = a person whose medicines are tracked (Mom, Dad, Son). Owned by an account.
- Each device picks a **default profile** locally (Mom's phone defaults to Mom's profile, Dad's to Dad's, son's to Self). This is a **per-device preference**, never synced.
- All domain rows (`medicines`, `dose_logs`, `prescriptions`) hang off `profile_id`.
- Row-Level Security on Supabase ensures an account can only read/write rows belonging to its own profiles.

> **Simplification for v1:** single-account households only. Multi-account sharing (invite another caregiver) is a later phase; for now "son's account signed into three phones" solves the stated need.

---

## 3. Data Model Changes

### 3.1 New / updated Drift tables (local)

Add to every syncable table:

| Column | Type | Notes |
|---|---|---|
| `id` | `TEXT` (UUID v4) | Already exists, standardize to UUID |
| `account_id` | `TEXT` | Supabase user id (`auth.users.id`) — stamped on write |
| `updated_at` | `INTEGER` (ms since epoch) | Bumped on every local write |
| `deleted_at` | `INTEGER?` | Soft delete — null = active |
| `dirty` | `BOOLEAN` | `true` = has local changes not yet pushed |
| `last_writer_device_id` | `TEXT` | Conflict tie-break |

Tables to migrate: `profiles`, `medicines`, `dose_logs`, `prescriptions`.

A Drift schema migration (v2) adds the new columns with defaults: `updated_at = now()`, `dirty = true` (so existing local data flushes on first sync), `deleted_at = null`, `account_id` backfilled from the logged-in user at migration time.

### 3.2 Supabase schema

```sql
-- Extensions
create extension if not exists "uuid-ossp";

-- Profiles
create table profiles (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  initials text not null,
  dependents text[] default '{}',
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  last_writer_device_id text
);
create index on profiles (account_id, updated_at);

-- Medicines
create table medicines (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references auth.users(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  name text not null,
  type text not null,
  schedule text not null,
  amount numeric not null default 1,
  strength text,
  unit text,
  times jsonb not null default '[]',         -- list of {hour, minute}
  stock_remaining int not null,
  stock_total int not null,
  days_left int not null,
  is_low_stock boolean not null default false,
  image_path text,                            -- local-only path; don't sync the file in v1
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  last_writer_device_id text
);
create index on medicines (account_id, updated_at);
create index on medicines (profile_id);

-- Dose logs
create table dose_logs (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references auth.users(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  medicine_id uuid not null references medicines(id) on delete cascade,
  medicine_name text not null,
  date_time timestamptz not null,
  scheduled_date_time timestamptz,
  status text not null,                       -- 'taken' | 'skipped' | 'snoozed'
  note text,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  last_writer_device_id text
);
create index on dose_logs (account_id, updated_at);
create index on dose_logs (medicine_id, scheduled_date_time);

-- Prescriptions (mirror existing fields)
create table prescriptions (
  id uuid primary key default uuid_generate_v4(),
  account_id uuid not null references auth.users(id) on delete cascade,
  profile_id uuid not null references profiles(id) on delete cascade,
  -- ... existing fields ...
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  last_writer_device_id text
);
```

### 3.3 Row-Level Security (RLS)

```sql
alter table profiles       enable row level security;
alter table medicines      enable row level security;
alter table dose_logs      enable row level security;
alter table prescriptions  enable row level security;

-- Single policy shape for all tables (repeat per table)
create policy "own rows only" on medicines
  for all
  using  (account_id = auth.uid())
  with check (account_id = auth.uid());
```

Every row-access check reduces to "the row's `account_id` equals the caller's `auth.uid()`". Simple, safe.

---

## 4. Authentication

- **Flow:** email + password via `supabase_flutter`. First launch shows a gated auth screen (Sign in / Sign up / Forgot password). On success, the app fetches profiles for this account and drops into `AppShell`.
- **Storage:** Supabase SDK persists the session in secure storage automatically.
- **Offline:** app must be usable offline after first login. The SDK keeps the session token; local DB continues to serve reads; writes queue in the `dirty` flag until reconnect.
- **Sign out:** clears the Supabase session + wipes the local DB (so the device doesn't keep another household's data).

**New screens:**
- `SignInScreen` (email, password, "Sign up" link)
- `SignUpScreen` (email, password, confirm, display name → also creates a default "Self" profile)
- `ForgotPasswordScreen` (magic-link email via Supabase `resetPasswordForEmail`)

**New cubit:** `AuthCubit` — states `{unauthenticated, authenticating, authenticated(userId, email), error}`. Wraps `Supabase.instance.client.auth`.

---

## 5. Sync Architecture

Sync is **delta-based, last-write-wins by `updated_at`**, with `last_writer_device_id` as tie-break. No CRDTs — overkill for this domain.

### 5.1 Device identity

- On first run, generate a `device_id` (UUID v4) and persist in `shared_preferences`. Stamped onto every write.

### 5.2 Write path (local → remote)

1. App code writes to the local repo (existing flow).
2. The repo stamps `updated_at = now()`, `last_writer_device_id = deviceId`, `dirty = true`.
3. A `SyncService` drains `dirty` rows in small batches:
   - For each table, select `where dirty = true order by updated_at asc limit 50`.
   - Upsert into Supabase (`client.from(table).upsert(...)`).
   - On success, mark rows `dirty = false`.
   - On failure (offline, 5xx), leave `dirty = true` and retry with backoff.

### 5.3 Read path (remote → local)

1. App tracks a per-table `last_pulled_at` timestamp in `shared_preferences`.
2. On login, foreground, and every N minutes while open:
   - `client.from(table).select('*').gt('updated_at', lastPulledAt)` — paginated.
   - For each remote row:
     - If local row absent → insert.
     - If local row present and `remote.updated_at > local.updated_at` → overwrite.
     - If local row `dirty = true` and `local.updated_at >= remote.updated_at` → keep local, it'll flush.
     - Tie on `updated_at`? Compare `last_writer_device_id` lexicographically (deterministic).
3. If `deleted_at` is set remotely → apply as soft delete locally (hide in UI, purge in a later GC pass).
4. Update `last_pulled_at` to `max(remote.updated_at)` from the batch.

### 5.4 Realtime

- Subscribe to Supabase Realtime channels for each table filtered by `account_id = auth.uid()`.
- On INSERT/UPDATE/DELETE events, merge the row into the local DB using the same conflict rules as pull.
- This is what makes "Mom took her 8 AM pill" show up on son's phone within seconds.

### 5.5 Triggers for `SyncService`

- App start (after auth)
- App resume (from background)
- After every local write (debounced ~2s)
- Pull-to-refresh on home screen
- Periodic (every 15 min while foregrounded) as safety net

### 5.6 Cancel-on-take across devices

Existing: `MedicineScheduler.cancelDose(...)` cancels local notifications when a dose is marked taken/skipped/snoozed.

Add: when a `dose_logs` INSERT arrives via Realtime on a *different* device, that device also calls `MedicineScheduler.cancelDose(...)` for the matching slot. Without this, Mom's phone rings after son already logged her dose.

---

## 6. Per-Device Default Profile (caregiver UX)

- Store `default_profile_id` in `shared_preferences` — **never synced**.
- Home screen initial profile = this local default (falls back to first profile).
- Settings → "This device watches" → pick one or more profiles. The device schedules notifications only for the selected profiles.
- Son's phone: all three profiles selected (monitoring).
- Mom's phone: only Mom's profile (so she isn't woken by Dad's reminders).

---

## 7. Notifications (cross-device)

- Local notifications stay per-device, driven by `default_profile_id` + "watched profiles" selection.
- Push notifications (FCM) for caregiver alerts (future): "Mom hasn't taken 8 PM dose — 20 min overdue". Needs a Supabase edge function watching overdue dose windows — **Phase 4**, not v1.

---

## 8. Privacy, Safety, Legal

- **Consent:** signup flow shows a plain-language consent summary ("Your medication data is stored on Supabase servers in encrypted form. Only devices signed into this account can read it.").
- **Data export:** Settings → "Export all data" → JSON/PDF via the existing report path.
- **Account deletion:** Settings → "Delete account" → calls an edge function that cascades-deletes all rows tied to `auth.uid()`. Required for Play Store + GDPR.
- **At-rest encryption:** Phase 5 — migrate Drift to SQLCipher once we're storing synced medical data.
- **Disclaimer:** app is a reminder/wellness tool, not a medical device. Keep copy aligned with this so we don't trip FDA/CE class-II rules.

---

## 9. Phased Roll-out

### Phase 1 — Foundation (auth + schema)
- [ ] Add `supabase_flutter` to pubspec
- [ ] Add Supabase env vars (URL + anon key) to `.env` / `--dart-define`
- [ ] Create Supabase project, run schema + RLS SQL
- [ ] `AuthCubit` + `SignInScreen` / `SignUpScreen` / `ForgotPasswordScreen`
- [ ] Gate `AppShell` on auth state; redirect to sign-in when unauthenticated
- [ ] Drift migration v2 → add `updated_at`, `deleted_at`, `dirty`, `account_id`, `last_writer_device_id` to all synced tables
- [ ] Generate + persist `device_id`
- [ ] Stamp `updated_at` / `dirty` / `last_writer_device_id` on every local write

### Phase 2 — Sync engine
- [ ] Replace `MedicineRemoteDataSourceImpl` + `ProfileRemoteDataSourceImpl` with Supabase-backed versions
- [ ] Add `DoseLogRemoteDataSource`, `PrescriptionRemoteDataSource`
- [ ] `SyncService` (singleton) with push (dirty-flush) + pull (since-last-pulled) + conflict resolution
- [ ] Wire triggers: app start, resume, post-write debounced, periodic
- [ ] Pull-to-refresh on home screen

### Phase 3 — Realtime + cross-device UX
- [ ] Subscribe to Supabase Realtime channels per table
- [ ] Merge realtime events into local DB
- [ ] Cross-device `cancelDose` on taken/skipped/snoozed events
- [ ] Settings: "This device watches" profile picker
- [ ] Settings: show current device name/id, sign out button

### Phase 4 — Caregiver push alerts
- [ ] Supabase edge function: scan for overdue doses, push FCM to caregiver devices
- [ ] FCM integration in app
- [ ] User setting: "Notify me when [profile] misses a dose"

### Phase 5 — Hardening
- [ ] SQLCipher / encrypted Drift
- [ ] Data export (JSON + PDF)
- [ ] Account deletion (edge function + UI)
- [ ] Privacy policy + consent copy
- [ ] Sync diagnostics screen (last sync, dirty count, last error) for support

---

## 10. Conflict Resolution (reference)

| Scenario | Resolution |
|---|---|
| Local row modified, remote unchanged | Push local on next sync |
| Remote row modified, local unchanged | Overwrite local on pull |
| Both modified, different `updated_at` | Higher `updated_at` wins |
| Both modified, same `updated_at` | Higher `last_writer_device_id` (lexicographic) wins |
| Remote soft-deleted, local dirty | Remote wins; local edits lost (acceptable for v1) |
| Local soft-deleted, remote newer update | Remote wins — resurrect |

---

## 11. Open Questions

1. **Multi-account sharing** (two separate users on the same profile) — deferred. If needed, add a `profile_members` junction table and update RLS to `account_id in (select account_id from profile_members where profile_id = ...)`.
2. **Image sync** — prescription photos + medicine images. v1: keep local-only, include a "this image only exists on the device that uploaded it" note. Phase 5+: Supabase Storage with signed URLs.
3. **Historical backfill** — should dose logs older than X days sync? Yes; no cap for now. Revisit if it becomes a payload problem.
4. **Session expiry** — Supabase refresh tokens are long-lived; still, handle expired-token errors by re-prompting sign-in without wiping local data.

---

## 12. File-Level Impact Summary

| Area | Files expected to change |
|---|---|
| Auth | new: `features/auth/**`, wire in `main.dart`, `app_shell.dart` |
| Schema | `core/storage/app_database.dart`, `core/storage/data_mappers.dart`, generated `.g.dart` |
| Remote datasources | `features/medicines/data/datasources/*_remote_datasource.dart`, `features/profile/...`, new `features/history/data/datasources/dose_log_remote_datasource.dart`, `features/prescriptions/...` |
| Repositories | all four `*_repository_impl.dart` — replace stubbed sync methods, stamp metadata on writes |
| Sync | new `core/sync/sync_service.dart`, new `core/sync/conflict_resolver.dart` |
| Device id | new `core/device/device_identity.dart` |
| Profile UX | `features/profile/presentation/screens/profile_setup_screen.dart` + new "Device watches" setting |
| Settings | `features/settings/presentation/screens/settings_screen.dart` — sign out, export, delete account |

---

## 13. Definition of Done (v1)

- Son signs up on his phone with email + password. Adds profiles for Mom, Dad, Self.
- Installs the app on Mom's phone, signs in with the same credentials, sets Mom as the default profile for that device. Same for Dad's phone.
- When son adds a new medicine for Mom from his phone, it appears on Mom's phone within a few seconds (Realtime) and at worst on next foreground (pull).
- When Mom taps "Take" on her phone, the dose log appears on son's phone within seconds, and the reminder on Mom's phone stops ringing (already handled locally) — no duplicate reminders on son's phone either (cross-device cancel).
- If any phone is offline, changes made there flush on next connect; inbound changes from other phones are merged without data loss.
- Signing out wipes the local DB so the device doesn't leak data to another account.
