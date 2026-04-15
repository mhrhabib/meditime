# Meditime — Improvement Plan for Google Antigravity

> Feed this file to Antigravity as a project brief. Each section is a self-contained task with acceptance criteria. Work top-to-bottom — earlier tasks unblock later ones.

## Context

Meditime is a Flutter medication reminder app (Material 3, Bloc/Cubit, go_router). The UI is ~80% complete but the engine is ~20% complete: notifications don't actually fire, data doesn't persist across sessions, and the paywall gates features before the free tier works. This plan fixes that in priority order.

**Tech stack already wired in `pubspec.yaml`:** `flutter_bloc`, `go_router`, `hive`, `shared_preferences`, `flutter_local_notifications`, `timezone`, `dio`, `fl_chart`, `mobile_scanner`, `qr_flutter`.

**Directory convention:** `lib/features/<feature>/{data,domain,presentation}/` — keep it.

---

## P0 — Blockers (ship these first; nothing else matters)

### 1. Wire real local notifications end-to-end

**Why:** The entire product promise is "reminders that ring." Today reminders are UI theater.

**Files to create/touch:**
- `lib/core/notifications/notification_service.dart` (new) — singleton wrapper around `flutter_local_notifications`
- `lib/core/notifications/notification_channels.dart` (new) — declare Android channels: `meds_default`, `meds_critical` (bypass DND), `refill_alerts`
- `lib/main.dart` — initialize `NotificationService` + `tz.initializeTimeZones()` before `runApp`
- `lib/features/medicines/data/medicine_scheduler.dart` (new) — converts a `Medicine` + schedule into `zonedSchedule` calls, one per dose per day for next 14 days (rolling)
- `lib/features/medicines/presentation/cubit/medicine_cubit.dart` — on add/edit/delete, call scheduler to (re)register notifications
- `android/app/src/main/AndroidManifest.xml` — add `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`
- `ios/Runner/Info.plist` — add background modes + notification usage description

**Acceptance:**
- Add a medicine scheduled 2 min in the future → notification fires with med name, dose, Take/Snooze/Skip actions.
- Tapping "Take" marks the dose taken and updates the home timeline.
- Snooze re-rings in N minutes per user's reminder settings.
- Killing the app does not prevent the notification.
- Reboot does not lose scheduled notifications (reschedule on boot via `RECEIVE_BOOT_COMPLETED`).

---

### 2. Persist everything with Hive

**Why:** Users add meds, close app, data vanishes. No trust = no retention.

**Files to create/touch:**
- `lib/core/storage/hive_boxes.dart` (new) — box names constants + `openBoxes()` called in `main.dart`
- Hive adapters (run `build_runner`) for: `Medicine`, `DoseEvent` (taken/missed/skipped/snoozed log), `Profile`, `Prescription`, `EmergencyCard`, `ReminderSettings`
- Each feature's Cubit: replace in-memory `List<>` with Hive box reads/writes. Emit state from box listeners so UI stays reactive.
- `lib/features/onboarding/` — persist `hasCompletedOnboarding` via `SharedPreferences` (not in-memory).

**Acceptance:**
- Add 3 meds, kill the app from recents, reopen → all 3 meds + today's dose log appear.
- Uninstall + reinstall → clean state (expected).
- No Cubit holds domain data in `List<>` fields anymore; all reads go through a repository backed by Hive.

---

### 3. Missed-dose reason modal

**Why:** Already in your wireframe. Turns a negative event (missed dose) into structured data + an engagement moment.

**Files:**
- `lib/features/medicines/presentation/widgets/missed_dose_sheet.dart` (new) — bottom sheet with 4 options: **Forgot**, **Side effects**, **Ran out**, **Didn't need it**. Plus free-text note.
- Triggered when a dose passes its window without a "Take" action (scheduled notification with a 30-min grace, then auto-prompt on next app open).
- Log reason into `DoseEvent.missedReason`.

**Acceptance:**
- Miss a dose by 30 min → next app open shows the sheet.
- Selected reason persists in history and is visible on the dose's detail row.
- "Ran out" reason auto-creates a refill reminder.

---

## P1 — Retention mechanics (do these next)

### 4. Refill prediction with CTA

**Why:** A static "low stock" bar is passive. "You'll run out Thursday" is actionable.

**Logic:** `daysRemaining = currentStock / dosesPerDay`. If `< 5`, show amber banner; if `< 2`, red + push notification. Tap → pre-filled pharmacy search or "Mark refilled" action that resets stock.

**Files:**
- `lib/features/medicines/domain/refill_predictor.dart` (new) — pure function, unit-tested.
- `lib/features/home/presentation/widgets/refill_banner.dart` (new) — replaces the current static low-stock card when any med predicts runout within 5 days.
- Schedule a daily background check (via `flutter_local_notifications` daily repeating) that fires a notification if any med crosses the threshold.

**Acceptance:**
- Set a med to 4 doses remaining, 2 doses/day → banner shows "Runs out in 2 days".
- Mark refilled → banner disappears, stock resets to configured value.

---

### 5. Weekly adherence insight notification

**Why:** Passive re-engagement. "You hit 94% this week, up from 81%" brings users back without nagging.

**Files:**
- `lib/features/history/domain/adherence_calculator.dart` (new) — computes weekly %, week-over-week delta.
- Schedule a weekly notification (Sunday 6pm local) with the actual computed string.
- Tapping opens the history screen with the week pre-selected.

**Acceptance:**
- After 2 weeks of use, a Sunday notification fires with real numbers.
- Notification is silenced if user opened the app that day already (check last-open timestamp in `SharedPreferences`).

---

### 6. Onboarding "aha moment"

**Why:** Current onboarding is 4 slides of marketing. Users should feel value in <60 seconds.

**Flow:**
1. Slide 1: value prop + "Add your first medicine"
2. **Inline** add-medicine mini-form (name, time) — not the full 4-step wizard
3. Request notification permission *in context* with copy: "We need this to remind you at 8:00 AM tomorrow"
4. Schedule a **demo notification 30 seconds later** that says "This is how your reminder will look ✅"
5. Then route to home

**Files:**
- `lib/features/onboarding/presentation/screens/first_medicine_screen.dart` (new)
- `lib/features/onboarding/presentation/screens/notification_demo_screen.dart` (new)
- Rewire `OnboardingCubit` to track new step order.

**Acceptance:**
- New install → within 90 seconds user has seen a real notification from the app.
- Permission denial path: clear explainer screen, not a dead end.

---

### 7. Fix empty states

**Why:** "No medicines scheduled" with no CTA is a dead end.

**Touch:**
- Home timeline empty state → illustrated, with "Add your first medicine" primary button.
- Prescriptions empty → "Scan your prescription" primary + "Add manually" secondary.
- History empty → "Log your first dose to start tracking."

Keep the existing empty-state widgets but add a primary CTA button to each.

---

## P2 — Differentiation (ship after P0/P1 are stable)

### 8. Reposition the paywall

**Why:** Gating OCR + PDF + unlimited profiles before free tier works is backwards. Let people succeed, then upsell the *family* angle — which is the real moat vs Medisafe/MyTherapy.

**Changes to `lib/features/premium/presentation/screens/paywall_screen.dart`:**
- **Free tier:** 1 profile, unlimited meds, all reminders, emergency card, basic history. (Currently these feel premium-adjacent — they shouldn't be.)
- **Premium hero:** "Care for your whole family" — unlimited profiles + caregiver dashboard + missed-dose alerts to family.
- **Secondary premium:** OCR scan, PDF export, cloud backup.
- **Remove** AI pill recognition from the pitch until it exists (don't promise vaporware).
- Trigger the paywall *contextually* (when adding a 2nd profile, when tapping "Invite caregiver") — not on app launch.

**Acceptance:**
- Fresh install never sees the paywall unless user taps a premium feature.
- Paywall copy emphasizes family + caregiver, not OCR.

---

### 9. Caregiver read-only web view (true moat)

**Why:** "Caregiver invite link, no app install required" is your killer feature — and it's currently just a screen with no backend.

**Minimum viable implementation:**
- Firebase (or Supabase) project: single `caregiver_shares` collection keyed by short token.
- App pushes a snapshot (current meds, today's adherence, emergency contact) when user enables sharing.
- Static web page at `meditime.app/c/<token>` renders the snapshot read-only.
- Snapshot refreshes each time the app opens + on dose events.

**Files:**
- `lib/features/caregiver/data/caregiver_sync_service.dart` (new)
- A separate tiny web project (`/web_caregiver_viewer/`) — static HTML + JS, reads from Firebase.

**Acceptance:**
- Enable sharing → get a link → open link in a browser (not logged in) → see today's dose status.
- Revoke → link 404s.

---

### 10. Doctor/clinic export

**Why:** Natural extension of emergency card PDF. Doctors asking "are you taking your meds?" is the moment users wish they had this.

**Files:**
- `lib/features/history/presentation/screens/export_screen.dart` (new)
- Reuse the existing PDF library used by emergency card.
- Export: last 30/90 days of dose log + adherence % + current med list, as a single PDF.

---

## Cut / defer

Don't build these; they're distractions right now:

- **AI pill recognition** — expensive, low-trust, rare use. Remove from paywall copy.
- **Gamification badges / leaderboards** — medication adherence isn't a game. Streaks are enough.
- **Social feed** — no social fit for this category.
- **Multi-language** (beyond English + Bangla if that's the primary market) — later.
- **Theme customization beyond light/dark** — premature.

---

## Definition of done (per task)

Each task is complete only when:
1. Code compiles with `flutter analyze` zero warnings in touched files.
2. New pure-logic functions (refill predictor, adherence calculator, scheduler) have unit tests under `test/`.
3. Manual smoke test on an Android emulator + a physical iOS device confirms the acceptance criteria above.
4. No Cubit holds domain data in memory-only fields after P0 is done.

---

## Execution order for Antigravity

Work strictly in this order — do not skip ahead:

1. Task 2 (Hive persistence) — everything else depends on data surviving.
2. Task 1 (Notifications) — the core product.
3. Task 3 (Missed-dose modal) — depends on 1 + 2.
4. Task 7 (Empty states) — small, ship while P1 is in flight.
5. Task 6 (Onboarding aha) — depends on 1.
6. Task 4 (Refill prediction) → Task 5 (Weekly insights).
7. Task 8 (Paywall repositioning) — pure UI/copy, can ship anytime after P0.
8. Task 9 (Caregiver web view) → Task 10 (Doctor export).

Stop after each task, run the acceptance checks, commit, then proceed.
