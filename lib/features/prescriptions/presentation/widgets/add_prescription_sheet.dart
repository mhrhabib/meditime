import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/prescriptions/domain/entities/prescription.dart';
import 'package:meditime/features/prescriptions/presentation/cubit/prescription_cubit.dart';

class AddPrescriptionSheet extends StatefulWidget {
  final Prescription? initial;
  final List<String> prefilledMedicines;
  final String? imageUrl;

  const AddPrescriptionSheet({
    super.key,
    this.initial,
    this.prefilledMedicines = const [],
    this.imageUrl,
  });

  static Future<Prescription?> show(
    BuildContext context, {
    Prescription? initial,
    List<String> prefilledMedicines = const [],
    String? imageUrl,
  }) {
    return showModalBottomSheet<Prescription>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (_) => AddPrescriptionSheet(
        initial: initial,
        prefilledMedicines: prefilledMedicines,
        imageUrl: imageUrl,
      ),
    );
  }

  @override
  State<AddPrescriptionSheet> createState() => _AddPrescriptionSheetState();
}

class _AddPrescriptionSheetState extends State<AddPrescriptionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _doctorCtrl;
  late final TextEditingController _reasonCtrl;
  late final TextEditingController _medicineInputCtrl;
  late DateTime _date;
  late List<String> _medicines;
  String? _imageUrl;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _doctorCtrl = TextEditingController(text: initial?.doctorName ?? '');
    _reasonCtrl = TextEditingController(text: initial?.reason ?? '');
    _medicineInputCtrl = TextEditingController();
    _date = initial?.date ?? DateTime.now();
    _medicines = [
      ...?initial?.medicines,
      ...widget.prefilledMedicines,
    ];
    _imageUrl = widget.imageUrl ?? initial?.imageUrl;
  }

  @override
  void dispose() {
    _doctorCtrl.dispose();
    _reasonCtrl.dispose();
    _medicineInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _addMedicine() {
    final value = _medicineInputCtrl.text.trim();
    if (value.isEmpty) return;
    if (_medicines.contains(value)) {
      _medicineInputCtrl.clear();
      return;
    }
    setState(() {
      _medicines.add(value);
      _medicineInputCtrl.clear();
    });
  }

  void _removeMedicine(String name) {
    setState(() => _medicines.remove(name));
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final rx = Prescription(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      doctorName: _doctorCtrl.text.trim(),
      date: _date,
      reason: _reasonCtrl.text.trim(),
      imageUrl: _imageUrl,
      medicines: List.unmodifiable(_medicines),
      isScanned: _medicines.isNotEmpty,
    );

    final cubit = context.read<PrescriptionCubit>();
    if (_isEditing) {
      await cubit.updatePrescription(rx);
    } else {
      await cubit.addPrescription(rx);
    }
    if (!mounted) return;
    Navigator.of(context).pop(rx);
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isEditing ? 'Edit Prescription' : 'Add Prescription',
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _doctorCtrl,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Doctor name',
                  hintText: 'Dr. Last name',
                  prefixIcon: Icon(Icons.medical_services_outlined, size: 20.r),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 12.h),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(8.r),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Visit date',
                    prefixIcon:
                        Icon(Icons.calendar_today_outlined, size: 20.r),
                  ),
                  child: Text(_formatDate(_date),
                      style: TextStyle(fontSize: 14.sp)),
                ),
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _reasonCtrl,
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: 'Reason / diagnosis',
                  hintText: 'e.g. Diabetes checkup',
                  prefixIcon: Icon(Icons.notes_outlined, size: 20.r),
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 16.h),
              Text('Medicines',
                  style: tt.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700, fontSize: 13.sp)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _medicineInputCtrl,
                      textCapitalization: TextCapitalization.words,
                      onSubmitted: (_) => _addMedicine(),
                      decoration: InputDecoration(
                        hintText: 'Add medicine name',
                        isDense: true,
                        prefixIcon:
                            Icon(Icons.medication_outlined, size: 20.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  FilledButton.tonalIcon(
                    onPressed: _addMedicine,
                    icon: Icon(Icons.add_rounded, size: 18.r),
                    label: Text('Add', style: TextStyle(fontSize: 13.sp)),
                  ),
                ],
              ),
              if (_medicines.isNotEmpty) ...[
                SizedBox(height: 12.h),
                Wrap( 
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: _medicines
                      .map((m) => Chip(
                            label: Text(m, style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 13.sp)),
                            onDeleted: () => _removeMedicine(m),
                            deleteIcon: Icon(Icons.close_rounded, size: 16.r),
                          ))
                      .toList(),
                ),
              ],
              if (_imageUrl != null) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.image_outlined,
                          size: 18.r, color: cs.onSurfaceVariant),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Image attached',
                          style: TextStyle(fontSize: 12.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, size: 18.r),
                        onPressed: () => setState(() => _imageUrl = null),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: FilledButton(
                      onPressed: _save,
                      child: Text(_isEditing ? 'Save' : 'Add',
                          style: TextStyle(fontSize: 14.sp)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
