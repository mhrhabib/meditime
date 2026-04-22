import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

class EditMedicineSheet extends StatefulWidget {
  final Medicine medicine;

  const EditMedicineSheet({super.key, required this.medicine});

  static Future<Medicine?> show(BuildContext context, Medicine medicine) {
    return showModalBottomSheet<Medicine>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditMedicineSheet(medicine: medicine),
    );
  }

  @override
  State<EditMedicineSheet> createState() => _EditMedicineSheetState();
}

class _EditMedicineSheetState extends State<EditMedicineSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _strengthController;
  late final TextEditingController _stockController;
  late String _type;
  late String _unit;
  late List<TimeOfDay> _times;
  final _formKey = GlobalKey<FormState>();

  static const _types = ['Tablet', 'Capsule', 'Syrup', 'Injection', 'Drops'];
  static const _units = ['mg', 'mcg', 'g', 'ml', 'IU'];

  @override
  void initState() {
    super.initState();
    final m = widget.medicine;
    _nameController = TextEditingController(text: m.name);
    _amountController = TextEditingController(text: _fmt(m.amount));
    _strengthController = TextEditingController(text: m.strength ?? '');
    _stockController = TextEditingController(text: m.stockTotal.toString());
    _type = _types.contains(m.type) ? m.type : 'Tablet';
    _unit = _units.contains(m.unit) ? m.unit! : 'mg';
    _times = List<TimeOfDay>.from(m.times);
  }

  String _fmt(double v) => v % 1 == 0 ? v.toInt().toString() : v.toString();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _strengthController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _addTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) setState(() => _times.add(picked));
  }

  Future<void> _editTime(int i) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times[i],
    );
    if (picked != null) setState(() => _times[i] = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_times.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one reminder time')),
      );
      return;
    }
    final m = widget.medicine;
    final amount = double.tryParse(_amountController.text.trim()) ?? m.amount;
    final stockTotal =
        int.tryParse(_stockController.text.trim()) ?? m.stockTotal;
    final stockRemaining = m.stockRemaining.clamp(0, stockTotal);

    final updated = m.copyWith(
      name: _nameController.text.trim(),
      type: _type,
      amount: amount,
      strength: _strengthController.text.trim().isEmpty
          ? null
          : _strengthController.text.trim(),
      unit: _unit,
      times: _times,
      stockTotal: stockTotal,
      stockRemaining: stockRemaining,
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, controller) => Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: viewInsets),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                width: 44.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: cs.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              SizedBox(height: 14.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Icon(Icons.edit_rounded, color: cs.primary, size: 22.r),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        'Edit medicine',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: controller,
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            (v ?? '').trim().isEmpty ? 'Name required' : null,
                      ),
                      SizedBox(height: 12.h),
                      DropdownButtonFormField<String>(
                        initialValue: _type,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: _types
                            .map((t) => DropdownMenuItem(
                                  value: t,
                                  child: Text(t),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _type = v ?? _type),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _amountController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 12.h),
                                labelText: 'Dose',
                                border: const OutlineInputBorder(),
                              ),
                              validator: (v) {
                                final n = double.tryParse((v ?? '').trim());
                                if (n == null || n <= 0) {
                                  return 'Invalid';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _strengthController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 12.h),
                                labelText: 'Strength',
                                hintText: '500',
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              initialValue: _unit,
                              isDense: true,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 12.h),
                                labelText: 'Unit',
                                border: const OutlineInputBorder(),
                              ),
                              items: _units
                                  .map((u) => DropdownMenuItem(
                                      value: u, child: Text(u)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _unit = v ?? _unit),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reminder times',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: [
                          for (int i = 0; i < _times.length; i++)
                            InputChip(
                              label: Text(
                                _times[i].format(context),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              onPressed: () => _editTime(i),
                              onDeleted: () =>
                                  setState(() => _times.removeAt(i)),
                            ),
                          ActionChip(
                            avatar: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Add time'),
                            onPressed: _addTime,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      TextFormField(
                        controller: _stockController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Total stock capacity',
                          helperText:
                              'Remaining stock will be clamped to this value.',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) {
                          final n = int.tryParse((v ?? '').trim());
                          if (n == null || n < 0) return 'Invalid';
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 52.h,
                        child: FilledButton.icon(
                          onPressed: _save,
                          icon: const Icon(Icons.check_rounded),
                          label: Text(
                            'Save changes',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
