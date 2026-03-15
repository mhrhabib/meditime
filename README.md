# MediTime — Flutter Material 3 UI

A production-ready Flutter UI kit for the MediTime medication reminder app,
built with Material Design 3 (M3) and Nunito font for a warm, medical-safe aesthetic.

---

## Project Structure

```
lib/
│
├── main.dart
│
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   │
│   ├── constants/
│   │   └── app_constants.dart
│   │
│   ├── widgets/
│   │   └── components.dart
│   │
│   └── utils/
│       └── helpers.dart
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── app_shell.dart
│
├── features/
│
│   ├── home/
│   │
│   │   ├── presentation/
│   │   │
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   │
│   │   │   ├── cubit/
│   │   │   │   ├── home_cubit.dart
│   │   │   │   └── home_state.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │
│   │   ├── domain/
│   │   │
│   │   │   ├── entities/
│   │   │   │   └── dashboard.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── home_repository.dart
│   │   │   │
│   │   │   └── usecases/
│   │   │       └── get_dashboard_data.dart
│   │   │
│   │   └── data/
│   │
│   │       ├── models/
│   │       │   └── dashboard_model.dart
│   │       │
│   │       ├── repositories/
│   │       │   └── home_repository_impl.dart
│   │       │
│   │       └── datasources/
│   │           └── home_local_datasource.dart
│
│
│   ├── medicines/
│   │
│   │   ├── presentation/
│   │   │
│   │   │   ├── screens/
│   │   │   │   ├── medicine_list_screen.dart
│   │   │   │   └── add_medicine_screen.dart
│   │   │   │
│   │   │   ├── cubit/
│   │   │   │   ├── medicine_cubit.dart
│   │   │   │   └── medicine_state.dart
│   │   │   │
│   │   │   └── widgets/
│   │   │
│   │   ├── domain/
│   │   │
│   │   │   ├── entities/
│   │   │   │   └── medicine.dart
│   │   │   │
│   │   │   ├── repositories/
│   │   │   │   └── medicine_repository.dart
│   │   │   │
│   │   │   └── usecases/
│   │   │       ├── add_medicine.dart
│   │   │       └── get_medicines.dart
│   │   │
│   │   └── data/
│   │
│   │       ├── models/
│   │       │   └── medicine_model.dart
│   │       │
│   │       ├── repositories/
│   │       │   └── medicine_repository_impl.dart
│   │       │
│   │       └── datasources/
│   │           └── medicine_local_datasource.dart
│
│
│   ├── prescriptions/
│   │   └── same structure
│
│   ├── emergency_card/
│   │   └── same structure
│
│   └── premium/
│       ├── presentation/
│       │   ├── screens/
│       │   │   └── paywall_screen.dart
│       │   └── cubit/
│       │       ├── premium_cubit.dart
│       │       └── premium_state.dart
│       ├── domain/
│       └── data/
│
└── injection_container.dart

---

## Reusable Widgets

| Widget | Description |
|---|---|
| `ProfileSwitcher` | Pill dropdown — shows current profile + dependents, tap to switch |
| `StatCard` | Dashboard stat tile with icon, large value, label |
| `MedicineTile` | Timeline dose row — shows taken/missed/pending with inline actions |
| `MedicineCard` | Medicine list card with stock progress bar + quick refill button |
| `StockBar` | Visual inventory bar — turns red as stock depletes |
| `StreakRow` | 7-day habit streak — green/red/amber/gray day cells |
| `AlertBanner` | Contextual alert strip — warning/error/success/info variants |
| `SectionHeader` | Row with title + optional "See all" action link |
| `PrescriptionCard` | Rx card with medicine chips and OCR scan button |
| `EmergencyCardWidget` | Full emergency card — red-themed, shows vitals/meds/contact |

---

## Setup

### 1. Flutter version
Requires Flutter 3.16+ (Dart 3.0+)

```bash
flutter --version
# Flutter 3.16.x or higher required
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Add Nunito font
Download from Google Fonts: https://fonts.google.com/specimen/Nunito

Place the .ttf files in `assets/fonts/`:
- Nunito-Regular.ttf
- Nunito-Medium.ttf
- Nunito-SemiBold.ttf
- Nunito-Bold.ttf
- Nunito-ExtraBold.ttf

### 4. Run
```bash
flutter run
```

---

## Design System

### Color palette (M3 seed: #0B6E6E teal)

| Token | Hex | Usage |
|---|---|---|
| `primary` | #0B6E6E | Buttons, active states, links |
| `primaryContainer` | #B2EFEF | Card highlights, selected chips |
| `success` | #1B6B3A | Taken doses, adherence good |
| `successContainer` | #B7F0CE | Taken dose backgrounds |
| `warning` | #7A4F00 | Low stock, pending doses |
| `warningContainer` | #FFDEAD | Warning backgrounds |
| `error` | #BA1A1A | Missed doses, critical alerts |
| `errorContainer` | #FFDAD6 | Missed dose backgrounds |

### Typography
Font: **Nunito** — warm, rounded, high readability for health contexts.
Weights used: 400 (body), 600 (labels), 700 (titles), 800 (display/hero numbers).

### Key M3 components used
- `NavigationBar` (bottom nav with indicator pills)
- `FilledButton`, `OutlinedButton`, `FilledButton.tonal`
- `Card` with custom border and radius
- `TabBar` with pill indicator
- `SwitchListTile` for permission toggles
- `ChoiceChip` for medicine type selection
- `SliverAppBar` with `FlexibleSpaceBar` (premium screen)
- `CustomScrollView` + `SliverToBoxAdapter`

---

## Next Steps

1. **Add go_router navigation** — wire up all screens with named routes
2. **Hive local DB** — store medicines, doses, prescriptions offline-first
3. **flutter_local_notifications** — set up alarm-style reminders with repeat
4. **Riverpod state** — `MedicineProvider`, `DoseProvider`, `ProfileProvider`
5. **OCR integration** — use Google ML Kit or Tesseract for prescription scanning
6. **QR generation** — use `qr_flutter` to generate the emergency card QR
7. **Biometric lock** — `local_auth` for PIN/fingerprint on app open

---

## Screens Implemented

- [x] Home dashboard (profile switcher, stat cards, timeline, streak)
- [x] Medicine list (tabs, stock bars, refill action)
- [x] Add medicine (4-step wizard with progress bar)
- [x] Prescriptions (scan/upload, OCR status, medicine chips)
- [x] Emergency card (QR code, lock screen prompt)
- [x] Premium paywall (animated plan toggle, BDT pricing)

## Screens To Build Next

- [x] Onboarding (4 slides + permission request)
- [x] Profile setup (3-step wizard)
- [x] Missed dose flow (bottom sheet modal with 4 reason options)
- [x] Medical history (adherence charts with fl_chart)
- [x] Caregiver module (permissions + invite link)
- [x] Reminder settings (quiet hours, snooze config)
- [x] Settings (theme, language, backup)
