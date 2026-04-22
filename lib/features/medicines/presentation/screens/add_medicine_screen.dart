import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

import 'package:uuid/uuid.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  int _step = 0;
  final List<TimeOfDay> _times = [
    const TimeOfDay(hour: 8, minute: 0),
    const TimeOfDay(hour: 20, minute: 0)
  ];
  String _selectedFrequency = 'Daily';
  String _selectedType = 'Tablet';
  String _selectedInstruction = 'After meal';
  String? _selectedProfileId;
  bool _repeatUntilConfirmed = true;
  bool _snoozeEnabled = true;
  bool _refillReminder = true;
  final _stockController = TextEditingController(text: '30');
  final _alertDaysController = TextEditingController(text: '3');
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController(text: '500');
  final _amountController = TextEditingController(text: '1');
  String _unit = 'mg';
  String? _imagePath;
  DateTime _startDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int _durationDays = -1; // -1 = Continuous
  int _alreadyStartedDays = 0;

  static const _stepTitles = [
    'Medicine Details',
    'Set Schedule',
    'Reminders & Alerts',
    'Stock & Prescription',
  ];

  @override
  void initState() {
    super.initState();
    final profileCubit = context.read<ProfileCubit>();
    _selectedProfileId = profileCubit.state.activeProfile?.id;
  }

  @override
  void dispose() {
    _stockController.dispose();
    _alertDaysController.dispose();
    _nameController.dispose();
    _strengthController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final result = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (result != null) {
      setState(() => _times.add(result));
    }
  }

  void _removeTime(int index) => setState(() => _times.removeAt(index));

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 70);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          'med_${DateTime.now().millisecondsSinceEpoch}${p.extension(pickedFile.path)}';
      final savedImage =
          await File(pickedFile.path).copy(p.join(appDir.path, fileName));
      setState(() => _imagePath = savedImage.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_stepTitles[_step], style: TextStyle(fontSize: 18.sp)),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, size: 24.r),
          onPressed: _step > 0
              ? () => setState(() => _step--)
              : () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Step progress bar ──────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                      4,
                      (i) => Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 6.h,
                              margin: EdgeInsets.only(right: i < 3 ? 8.w : 0),
                              decoration: BoxDecoration(
                                color: i <= _step
                                    ? cs.primary
                                    : cs.outlineVariant.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          )),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Step ${_step + 1} of 4',
                  style: tt.labelMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp),
                ),
              ],
            ),
          ),

          // ── Step content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: anim.drive(
                        Tween(begin: const Offset(0.05, 0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeOutCubic))),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: _buildStep(),
                ),
              ),
            ),
          ),

          // ── Bottom actions ─────────────────────────────────
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(80.w, 56.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: Text('Back', style: TextStyle(fontSize: 14.sp)),
                    ),
                    SizedBox(width: 12.w),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_step < 3) {
                          setState(() => _step++);
                        } else {
                          final name = _nameController.text;
                          if (name.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Please enter a medicine name')),
                            );
                            return;
                          }

                          final stock =
                              int.tryParse(_stockController.text) ?? 0;
                          final alertDays =
                              int.tryParse(_alertDaysController.text) ?? 3;
                          final scheduleStr =
                              '$_selectedFrequency · ${_times.length}× · $_selectedInstruction';
                          final dosesPerDay =
                              _times.isEmpty ? 1 : _times.length;
                          final daysLeft = stock ~/ dosesPerDay;

                          // Subtract already started days from the selected start date
                          final finalStartDate = _startDate.subtract(
                            Duration(days: _alreadyStartedDays),
                          );

                          final medicine = Medicine(
                            id: const Uuid().v4(),
                            name: name,
                            type: _selectedType.toLowerCase(),
                            schedule: scheduleStr,
                            stockRemaining: stock,
                            stockTotal: stock,
                            daysLeft: daysLeft,
                            isLowStock: daysLeft <= alertDays,
                            profileId: _selectedProfileId ?? 'me',
                            amount:
                                double.tryParse(_amountController.text) ?? 1.0,
                            strength: _strengthController.text,
                            unit: _unit,
                            imagePath: _imagePath,
                            times: _times,
                            startDate: finalStartDate,
                            durationDays: _durationDays,
                          );

                          context.read<MedicineCubit>().addMedicine(medicine);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$name added successfully! ✓'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: cs.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r)),
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: Size(double.infinity, 56.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r)),
                      ),
                      child: Text(_step < 3 ? 'Continue' : 'Complete Setup',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      default:
        return _buildStep4();
    }
  }

  Widget _buildStep1() {
    final cs = Theme.of(context).colorScheme;
    final types = [
      'Tablet',
      'Syrup',
      'Injection',
      'Drops',
      'Inhaler',
      'Capsule'
    ];
    final instructions = [
      'After meal',
      'Before meal',
      'Empty stomach',
      'With water'
    ];
    final units = ['mg', 'ml', 'mcg', 'IU', '%'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          style: TextStyle(fontSize: 15.sp),
          decoration: InputDecoration(
            labelText: 'Medicine Name *',
            labelStyle: TextStyle(fontSize: 14.sp),
            hintText: 'e.g. Metformin',
            prefixIcon: Icon(Icons.medication_rounded, size: 24.r),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
          ),
        ),
        SizedBox(height: 24.h),
        _label('MEDICINE FORM'),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: types
              .map((t) => ChoiceChip(
                    label: Text(t,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 13.sp)),
                    selected: _selectedType == t,
                    onSelected: (_) => setState(() => _selectedType = t),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _strengthController,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 15.sp),
                decoration: InputDecoration(
                  labelText: 'Dose Strength',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  filled: true,
                  fillColor: cs.surfaceContainerLowest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: DropdownButtonFormField<String>(
                initialValue: _unit,
                style: TextStyle(fontSize: 14.sp, color: cs.onSurface),
                decoration: InputDecoration(
                  labelText: 'Unit',
                  labelStyle: TextStyle(fontSize: 14.sp),
                  filled: true,
                  fillColor: cs.surfaceContainerLowest,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.r)),
                ),
                items: units
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (v) => setState(() => _unit = v!),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
        _label('DOSE AMOUNT'),
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: TextStyle(fontSize: 15.sp),
          decoration: InputDecoration(
            labelText: 'How many to take each time? *',
            labelStyle: TextStyle(fontSize: 14.sp),
            hintText: 'e.g. 1, 1.5, 2',
            prefixIcon: Icon(Icons.numbers_rounded, size: 24.r),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        ),
        SizedBox(height: 24.h),
        _label('INSTRUCTIONS'),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: instructions
              .map((i) => ChoiceChip(
                    label: Text(i,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 13.sp)),
                    selected: _selectedInstruction == i,
                    onSelected: (_) => setState(() => _selectedInstruction = i),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ))
              .toList(),
        ),
        SizedBox(height: 24.h),
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return DropdownButtonFormField<String>(
              initialValue: _selectedProfileId ?? state.activeProfile?.id,
              style: TextStyle(fontSize: 15.sp, color: cs.onSurface),
              decoration: InputDecoration(
                labelText: 'Add medicine for',
                labelStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.person_pin_rounded, size: 24.r),
                filled: true,
                fillColor: cs.surfaceContainerLowest,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r)),
              ),
              items: state.profiles
                  .map(
                      (p) => DropdownMenuItem(value: p.id, child: Text(p.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedProfileId = v!),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStep2() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final freqs = ['Daily', 'Weekly', 'Every other day', 'As needed (PRN)'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('FREQUENCY'),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: freqs
              .map((f) => ChoiceChip(
                    label: Text(f,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 13.sp)),
                    selected: _selectedFrequency == f,
                    onSelected: (_) => setState(() => _selectedFrequency = f),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ))
              .toList(),
        ),
        SizedBox(height: 28.h),
        _label('DOSES PER DAY'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [1, 2, 3, 4]
              .map((count) => ChoiceChip(
                    label: Text('${count}x',
                        style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 13.sp)),
                    selected: _times.length == count,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _times.clear();
                          if (count == 1) {
                            _times.add(const TimeOfDay(hour: 8, minute: 0));
                          } else if (count == 2) {
                            _times.add(const TimeOfDay(hour: 8, minute: 0));
                            _times.add(const TimeOfDay(hour: 20, minute: 0));
                          } else if (count == 3) {
                            _times.add(const TimeOfDay(hour: 8, minute: 0));
                            _times.add(const TimeOfDay(hour: 14, minute: 0));
                            _times.add(const TimeOfDay(hour: 20, minute: 0));
                          } else if (count == 4) {
                            _times.add(const TimeOfDay(hour: 8, minute: 0));
                            _times.add(const TimeOfDay(hour: 12, minute: 0));
                            _times.add(const TimeOfDay(hour: 18, minute: 0));
                            _times.add(const TimeOfDay(hour: 22, minute: 0));
                          }
                        });
                      }
                    },
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ))
              .toList(),
        ),
        SizedBox(height: 28.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('REMINDER TIMES'),
            TextButton.icon(
              onPressed: _addTime,
              icon: Icon(Icons.add_circle_outline_rounded, size: 18.r),
              label: Text('Add Time', style: TextStyle(fontSize: 13.sp)),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ..._times.asMap().entries.map((e) => Container(
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16.r),
                border:
                    Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(Icons.access_time_filled_rounded,
                      color: cs.primary, size: 20.r),
                ),
                title: Text(e.value.format(context),
                    style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 16.sp)),
                subtitle: Text(_timeLabel(e.key),
                    style: tt.bodySmall?.copyWith(fontSize: 12.sp)),
                trailing: IconButton(
                  icon: Icon(Icons.delete_outline_rounded,
                      color: cs.error, size: 22.r),
                  onPressed: () => _removeTime(e.key),
                ),
                onTap: () async {
                  final result = await showTimePicker(
                      context: context, initialTime: e.value);
                  if (result != null) setState(() => _times[e.key] = result);
                },
              ),
            )),
        SizedBox(height: 16.h),
        _ModernSwitchTile(
          value: _repeatUntilConfirmed,
          onChanged: (v) => setState(() => _repeatUntilConfirmed = v),
          title: 'Repeat until confirmed',
          subtitle: 'Re-rings every 5 min if not answered',
          icon: Icons.repeat_rounded,
        ),
        SizedBox(height: 12.h),
        _ModernSwitchTile(
          value: _snoozeEnabled,
          onChanged: (v) => setState(() => _snoozeEnabled = v),
          title: 'Allow snooze',
          subtitle: '10 min snooze, max 3 times',
          icon: Icons.snooze_rounded,
        ),
      ],
    );
  }

  String _timeLabel(int index) {
    if (_times.length == 1) return 'Once daily';
    const labels = [
      'Morning dose',
      'Afternoon dose',
      'Evening dose',
      'Night dose'
    ];
    return index < labels.length ? labels[index] : 'Dose ${index + 1}';
  }

  Widget _buildStep3() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('NOTIFICATION TYPE'),
        const _InfoTile(
          icon: Icons.notifications_active_rounded,
          title: 'Push Notification',
          subtitle: 'Standard reminder on your phone',
          isOn: true,
        ),
        SizedBox(height: 12.h),
        const _InfoTile(
          icon: Icons.priority_high_rounded,
          title: 'Critical Alert',
          subtitle: 'Overrides silent/DND mode',
          isOn: false,
        ),
        SizedBox(height: 24.h),
        TextField(
          style: TextStyle(fontSize: 15.sp),
          decoration: InputDecoration(
            labelText: 'Reminder Message',
            labelStyle: TextStyle(fontSize: 14.sp),
            hintText: 'e.g. Time to take Metformin',
            prefixIcon: Icon(Icons.chat_bubble_outline_rounded, size: 22.r),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        ),
        SizedBox(height: 24.h),
        _label('NOTIFICATION SOUND'),
        DropdownButtonFormField<String>(
          initialValue: 'Standard chime',
          style: TextStyle(fontSize: 15.sp, color: cs.onSurface),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.music_note_rounded, size: 22.r),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
          items: ['Standard chime', 'Soft bell', 'Alarm tone', 'Vibrate only']
              .map((s) => DropdownMenuItem(value: s, child: Text(s)))
              .toList(),
          onChanged: (_) {},
        ),
        SizedBox(height: 24.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cs.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: cs.secondaryContainer),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: cs.secondary, size: 20.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Quiet hours and repeat behavior can be configured in Global Settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSecondaryContainer, fontSize: 11.sp),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep4() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final durations = [
      {'label': 'Continues', 'days': -1},
      {'label': '3 Days', 'days': 3},
      {'label': '7 Days', 'days': 7},
      {'label': '14 Days', 'days': 14},
      {'label': '30 Days', 'days': 30},
      {'label': '6 Months', 'days': 180},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('PRESCRIPTION DURATION'),
        Wrap(
          spacing: 10.w,
          runSpacing: 8.h,
          children: durations
              .map((d) => ChoiceChip(
                    label: Text(d['label'] as String,
                        style: tt.bodyMedium?.copyWith(fontSize: 13.sp)),
                    selected: _durationDays == d['days'],
                    onSelected: (_) =>
                        setState(() => _durationDays = d['days'] as int),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r)),
                  ))
              .toList(),
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.calendar_today_rounded,
                    color: cs.secondary, size: 22.r),
                title: Text('Starting from', style: TextStyle(fontSize: 14.sp)),
                subtitle: Text(
                  '${_startDate.day}/${_startDate.month}/${_startDate.year} ${_startDate.day == DateTime.now().day && _startDate.month == DateTime.now().month ? "(Today)" : ""}',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 365)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) setState(() => _startDate = picked);
                  },
                  child: const Text('Change'),
                ),
              ),
              if (_durationDays != -1) ...[
                Divider(
                    height: 1, color: cs.outlineVariant.withValues(alpha: 0.5)),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      Icon(Icons.history_toggle_off_rounded,
                          color: cs.secondary, size: 22.r),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Already started?',
                                style: TextStyle(fontSize: 14.sp)),
                            Text('Subtract days from progress',
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: cs.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80.w,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: 'd',
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onChanged: (v) {
                            setState(() =>
                                _alreadyStartedDays = int.tryParse(v) ?? 0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 32.h),
        _label('INVENTORY TRACKING'),
        TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 15.sp),
          decoration: InputDecoration(
            labelText: 'Current Stock Quantity',
            labelStyle: TextStyle(fontSize: 14.sp),
            prefixIcon: Icon(Icons.inventory_2_rounded, size: 22.r),
            suffixText: _selectedType == 'Syrup' ? 'ml' : 'units',
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16.r),
            border:
                Border.all(color: cs.primaryContainer.withValues(alpha: 0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: cs.primary, size: 22.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-Calculated Supply',
                        style: tt.titleSmall?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13.sp)),
                    SizedBox(height: 2.h),
                    Text(
                      'Based on dose frequency: ~${int.tryParse(_stockController.text) != null ? (int.parse(_stockController.text) ~/ _times.length) : "?"} day supply remaining.',
                      style: tt.bodySmall?.copyWith(
                          color: cs.primary.withValues(alpha: 0.8),
                          fontSize: 11.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),
        _ModernSwitchTile(
          value: _refillReminder,
          onChanged: (v) => setState(() => _refillReminder = v),
          title: 'Refill Reminder',
          subtitle: 'Notify when stock is running low',
          icon: Icons.notifications_active_rounded,
        ),
        if (_refillReminder) ...[
          SizedBox(height: 12.h),
          TextField(
            controller: _alertDaysController,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: 15.sp),
            decoration: InputDecoration(
              labelText: 'Alert me when',
              labelStyle: TextStyle(fontSize: 14.sp),
              suffixText: 'days left',
              prefixIcon: Icon(Icons.upcoming_rounded, size: 22.r),
              filled: true,
              fillColor: cs.surfaceContainerLowest,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
          ),
        ],
        SizedBox(height: 32.h),
        _label('ATTACH MEDICINE PHOTO'),
        if (_imagePath != null) ...[
          Container(
            height: 160.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              image: DecorationImage(
                image: FileImage(File(_imagePath!)),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 8,
                  top: 8,
                  child: IconButton.filled(
                    onPressed: () => setState(() => _imagePath = null),
                    icon: Icon(Icons.close_rounded, size: 20.r),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
        _UploadOption(
          icon: Icons.camera_enhance_rounded,
          title: 'Take a Photo',
          subtitle: 'Capture the label or medicine',
          onTap: () => _pickImage(ImageSource.camera),
        ),
        SizedBox(height: 12.h),
        _UploadOption(
          icon: Icons.photo_library_rounded,
          title: 'Upload from Gallery',
          subtitle: 'Pick a photo from your gallery',
          onTap: () => _pickImage(ImageSource.gallery),
        ),
        SizedBox(height: 24.h),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip for now',
                style: tt.bodyMedium?.copyWith(
                    color: cs.outline,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.sp)),
          ),
        ),
        SizedBox(height: 32.h),
      ],
    );
  }

  Widget _label(String text) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Text(text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.0,
                fontSize: 10.sp,
              )),
    );
  }
}

class _ModernSwitchTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String title, subtitle;
  final IconData icon;

  const _ModernSwitchTile({
    required this.value,
    required this.onChanged,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: cs.primary,
        secondary: Icon(icon, color: cs.secondary, size: 22.r),
        title: Text(title,
            style: tt.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w700, fontSize: 15.sp)),
        subtitle:
            Text(subtitle, style: tt.bodySmall?.copyWith(fontSize: 12.sp)),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
      ),
    );
  }
}

class _InfoTile extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final bool isOn;
  const _InfoTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.isOn});

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  late bool _on;
  @override
  void initState() {
    super.initState();
    _on = widget.isOn;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: _on
            ? cs.primaryContainer.withValues(alpha: 0.1)
            : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: _on
                ? cs.primary.withValues(alpha: 0.3)
                : cs.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: ListTile(
        leading:
            Icon(widget.icon, color: _on ? cs.primary : cs.outline, size: 24.r),
        title: Text(widget.title,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.sp)),
        subtitle: Text(widget.subtitle, style: TextStyle(fontSize: 11.sp)),
        trailing: Switch(
            value: _on,
            onChanged: (v) => setState(() => _on = v),
            activeThumbColor: cs.primary),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _UploadOption(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
          color: cs.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r)),
              child: Icon(icon, color: cs.primary, size: 22.r),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14.sp)),
                  Text(subtitle,
                      style: TextStyle(
                          color: cs.onSurfaceVariant, fontSize: 11.sp)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20.r),
          ],
        ),
      ),
    );
  }
}
