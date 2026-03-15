import 'package:flutter/material.dart';

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
  String _selectedProfile = 'Me (Rafiq)';
  bool _repeatUntilConfirmed = true;
  bool _snoozeEnabled = true;
  bool _refillReminder = true;
  final _stockController = TextEditingController(text: '30');
  final _alertDaysController = TextEditingController(text: '3');
  final _nameController = TextEditingController();
  final _strengthController = TextEditingController(text: '500');
  String _unit = 'mg';

  static const _stepTitles = [
    'Medicine Details',
    'Set Schedule',
    'Reminders & Alerts',
    'Stock & Prescription',
  ];

  @override
  void dispose() {
    _stockController.dispose();
    _alertDaysController.dispose();
    _nameController.dispose();
    _strengthController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_stepTitles[_step]),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _step > 0
              ? () => setState(() => _step--)
              : () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // ── Step progress bar ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(
                      4,
                      (i) => Expanded(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              height: 6,
                              margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
                              decoration: BoxDecoration(
                                color: i <= _step ? cs.primary : cs.outlineVariant.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step ${_step + 1} of 4',
                  style: tt.labelMedium?.copyWith(color: cs.onSurfaceVariant, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          
          // ── Step content ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => FadeTransition(
                  opacity: anim,
                  child: SlideTransition(
                    position: anim.drive(Tween(begin: const Offset(0.05, 0), end: Offset.zero).chain(CurveTween(curve: Curves.easeOutCubic))),
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
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    OutlinedButton(
                      onPressed: () => setState(() => _step--),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(80, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Back'),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (_step < 3) {
                          setState(() => _step++);
                        } else {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Medicine added successfully! ✓'),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: cs.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      },
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(_step < 3 ? 'Continue' : 'Complete Setup'),
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
    
    final types = ['Tablet', 'Syrup', 'Injection', 'Drops', 'Inhaler', 'Capsule'];
    final instructions = ['After meal', 'Before meal', 'Empty stomach', 'With water'];
    final units = ['mg', 'ml', 'mcg', 'IU', '%'];
    final profiles = ['Me (Rafiq)', 'Mum (Parent)', 'Sadia (Daughter)'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            labelText: 'Medicine Name *',
            hintText: 'e.g. Metformin',
            prefixIcon: const Icon(Icons.medication_rounded),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: cs.outlineVariant),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _label('MEDICINE FORM'),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: types.map((t) => ChoiceChip(
            label: Text(t),
            selected: _selectedType == t,
            onSelected: (_) => setState(() => _selectedType = t),
            showCheckmark: false,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )).toList(),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _strengthController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dose Strength',
                  filled: true,
                  fillColor: cs.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _unit,
                decoration: InputDecoration(
                  labelText: 'Unit',
                  filled: true,
                  fillColor: cs.surfaceContainerLowest,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
                items: units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                onChanged: (v) => setState(() => _unit = v!),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _label('INSTRUCTIONS'),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: instructions.map((i) => ChoiceChip(
            label: Text(i),
            selected: _selectedInstruction == i,
            onSelected: (_) => setState(() => _selectedInstruction = i),
            showCheckmark: false,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )).toList(),
        ),
        const SizedBox(height: 24),
        DropdownButtonFormField<String>(
          value: _selectedProfile,
          decoration: InputDecoration(
            labelText: 'Add medicine for',
            prefixIcon: const Icon(Icons.person_pin_rounded),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: profiles.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
          onChanged: (v) => setState(() => _selectedProfile = v!),
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
          spacing: 10,
          runSpacing: 8,
          children: freqs.map((f) => ChoiceChip(
            label: Text(f),
            selected: _selectedFrequency == f,
            onSelected: (_) => setState(() => _selectedFrequency = f),
            showCheckmark: false,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )).toList(),
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('REMINDER TIMES'),
            TextButton.icon(
              onPressed: _addTime,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
              label: const Text('Add Time'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ..._times.asMap().entries.map((e) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.access_time_filled_rounded, color: cs.primary, size: 20),
            ),
            title: Text(e.value.format(context), 
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            subtitle: Text(_timeLabel(e.key), style: tt.bodySmall),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: cs.error, size: 22),
              onPressed: () => _removeTime(e.key),
            ),
            onTap: () async {
              final result = await showTimePicker(context: context, initialTime: e.value);
              if (result != null) setState(() => _times[e.key] = result);
            },
          ),
        )),
        const SizedBox(height: 16),
        _ModernSwitchTile(
          value: _repeatUntilConfirmed,
          onChanged: (v) => setState(() => _repeatUntilConfirmed = v),
          title: 'Repeat until confirmed',
          subtitle: 'Re-rings every 5 min if not answered',
          icon: Icons.repeat_rounded,
        ),
        const SizedBox(height: 12),
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
    const labels = ['Morning dose', 'Afternoon dose', 'Evening dose', 'Night dose'];
    return index < labels.length ? labels[index] : 'Dose ${index + 1}';
  }

  Widget _buildStep3() {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('NOTIFICATION TYPE'),
        _InfoTile(
          icon: Icons.notifications_active_rounded,
          title: 'Push Notification',
          subtitle: 'Standard reminder on your phone',
          isOn: true,
        ),
        const SizedBox(height: 12),
        _InfoTile(
          icon: Icons.priority_high_rounded,
          title: 'Critical Alert',
          subtitle: 'Overrides silent/DND mode',
          isOn: false,
        ),
        const SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            labelText: 'Reminder Message',
            hintText: 'e.g. Time to take Metformin',
            prefixIcon: const Icon(Icons.chat_bubble_outline_rounded),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 24),
        _label('NOTIFICATION SOUND'),
        DropdownButtonFormField<String>(
          value: 'Standard chime',
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.music_note_rounded),
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          items: ['Standard chime', 'Soft bell', 'Alarm tone', 'Vibrate only']
              .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (_) {},
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.secondaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.secondaryContainer),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: cs.secondary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Quiet hours and repeat behavior can be configured in Global Settings.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSecondaryContainer),
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
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('INVENTORY TRACKING'),
        TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Current Stock Quantity',
            prefixIcon: const Icon(Icons.inventory_2_rounded),
            suffixText: _selectedType == 'Syrup' ? 'ml' : 'units',
            filled: true,
            fillColor: cs.surfaceContainerLowest,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: cs.primaryContainer.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome_rounded, color: cs.primary, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Auto-Calculated Supply', style: tt.titleSmall?.copyWith(color: cs.primary, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(
                      'Based on dose frequency: ~${int.tryParse(_stockController.text) != null ? (int.parse(_stockController.text) ~/ _times.length) : "?"} day supply remaining.',
                      style: tt.bodySmall?.copyWith(color: cs.primary.withOpacity(0.8)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _ModernSwitchTile(
          value: _refillReminder,
          onChanged: (v) => setState(() => _refillReminder = v),
          title: 'Refill Reminder',
          subtitle: 'Notify when stock is running low',
          icon: Icons.notifications_active_rounded,
        ),
        if (_refillReminder) ...[
          const SizedBox(height: 12),
          TextField(
            controller: _alertDaysController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Alert me when',
              suffixText: 'days supply left',
              prefixIcon: const Icon(Icons.upcoming_rounded),
              filled: true,
              fillColor: cs.surfaceContainerLowest,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
        const SizedBox(height: 32),
        _label('ATTACH PRESCRIPTION (OPTIONAL)'),
        _UploadOption(
          icon: Icons.camera_enhance_rounded,
          title: 'Take a Photo',
          subtitle: 'Capture the label or paper',
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _UploadOption(
          icon: Icons.photo_library_rounded,
          title: 'Upload from Gallery',
          subtitle: 'Pick a photo or PDF file',
          onTap: () {},
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Skip for now', style: tt.bodyMedium?.copyWith(color: cs.outline, fontWeight: FontWeight.normal)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _label(String text) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: cs.primary,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
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
    required this.value, required this.onChanged, 
    required this.title, required this.subtitle, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeColor: cs.primary,
        secondary: Icon(icon, color: cs.secondary, size: 22),
        title: Text(title, style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: tt.bodySmall),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

class _InfoTile extends StatefulWidget {
  final IconData icon;
  final String title, subtitle;
  final bool isOn;
  const _InfoTile({required this.icon, required this.title, required this.subtitle, required this.isOn});

  @override
  State<_InfoTile> createState() => _InfoTileState();
}

class _InfoTileState extends State<_InfoTile> {
  late bool _on;
  @override
  void initState() { super.initState(); _on = widget.isOn; }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: _on ? cs.primaryContainer.withOpacity(0.1) : cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _on ? cs.primary.withOpacity(0.3) : cs.outlineVariant.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Icon(widget.icon, color: _on ? cs.primary : cs.outline),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        subtitle: Text(widget.subtitle, style: const TextStyle(fontSize: 12)),
        trailing: Switch(value: _on, onChanged: (v) => setState(() => _on = v), activeColor: cs.primary),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
    );
  }
}

class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _UploadOption({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
          color: cs.surfaceContainerLow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: cs.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: cs.primary, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: cs.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
