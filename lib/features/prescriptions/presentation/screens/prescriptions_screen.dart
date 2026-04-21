import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/prescriptions/domain/entities/prescription.dart';
import 'package:meditime/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:meditime/features/prescriptions/presentation/widgets/add_prescription_sheet.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  Future<void> _showAddPrescription(
    BuildContext context, {
    Prescription? initial,
    String? imageUrl,
  }) async {
    await AddPrescriptionSheet.show(
      context,
      initial: initial,
      imageUrl: imageUrl,
    );
  }

  Future<void> _pickPrescriptionImage(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_camera_outlined, size: 24.r),
              title: Text('Take photo', style: TextStyle(fontSize: 14.sp)),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library_outlined, size: 24.r),
              title:
                  Text('Choose from gallery', style: TextStyle(fontSize: 14.sp)),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: Icon(Icons.edit_note_outlined, size: 24.r),
              title:
                  Text('Enter manually', style: TextStyle(fontSize: 14.sp)),
              onTap: () => Navigator.pop(ctx, null),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );

    if (!context.mounted) return;

    String? imageUrl;
    if (source != null) {
      try {
        final picker = ImagePicker();
        final file = await picker.pickImage(source: source, imageQuality: 80);
        if (file == null) return;
        imageUrl = file.path;
      } catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $source: $e')),
        );
        return;
      }
    }

    if (!context.mounted) return;
    await _showAddPrescription(context, imageUrl: imageUrl);
  }

  Future<void> _confirmDelete(BuildContext context, Prescription rx) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete prescription?', style: TextStyle(fontSize: 18.sp)),
        content: Text(
          'Remove ${rx.doctorName}\'s prescription from ${_formatDate(rx.date)}?',
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(fontSize: 14.sp)),
          ),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      await context.read<PrescriptionCubit>().deletePrescription(rx.id);
    }
  }

  void _showCardActions(BuildContext context, Prescription rx) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit_outlined, size: 22.r),
              title: Text('Edit', style: TextStyle(fontSize: 14.sp)),
              onTap: () {
                Navigator.pop(ctx);
                _showAddPrescription(context, initial: rx);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded,
                  size: 22.r, color: Theme.of(context).colorScheme.error),
              title: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, rx);
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Prescriptions', style: TextStyle(fontSize: 20.sp)),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () => _pickPrescriptionImage(context),
              icon: Icon(Icons.document_scanner_outlined, size: 24.r),
              tooltip: 'Scan or upload',
            ),
            SizedBox(width: 8.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3.h,
                labelColor: cs.primary,
                unselectedLabelColor: cs.onSurfaceVariant,
                labelStyle: tt.labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                unselectedLabelStyle: tt.labelLarge?.copyWith(fontSize: 13.sp),
                tabs: const [
                  Tab(text: 'By Date'),
                  Tab(text: 'By Doctor'),
                  Tab(text: 'By Disease'),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 90.h),
          child: FloatingActionButton.extended(
            onPressed: () => _showAddPrescription(context),
            icon: Icon(Icons.add_rounded, size: 20.r),
            label: Text('Add', style: TextStyle(fontSize: 14.sp)),
          ),
        ),
        body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
          builder: (context, state) {
            if (state.prescriptions.isEmpty) {
              return _EmptyState(
                onAdd: () => _showAddPrescription(context),
                onScan: () => _pickPrescriptionImage(context),
              );
            }

            return TabBarView(
              children: [
                _byDate(context, state.prescriptions),
                _grouped(
                  context,
                  state.prescriptions,
                  (rx) => rx.doctorName.trim().isEmpty
                      ? 'Unknown doctor'
                      : rx.doctorName,
                ),
                _grouped(
                  context,
                  state.prescriptions,
                  (rx) =>
                      rx.reason.trim().isEmpty ? 'Uncategorized' : rx.reason,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _byDate(BuildContext context, List<Prescription> all) {
    final sorted = [...all]..sort((a, b) => b.date.compareTo(a.date));
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
      itemCount: sorted.length,
      itemBuilder: (context, index) => _card(context, sorted[index]),
    );
  }

  Widget _grouped(
    BuildContext context,
    List<Prescription> all,
    String Function(Prescription) key,
  ) {
    final map = <String, List<Prescription>>{};
    for (final rx in all) {
      map.putIfAbsent(key(rx), () => []).add(rx);
    }
    final groupKeys = map.keys.toList()..sort();
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 96.h),
      itemCount: groupKeys.length,
      itemBuilder: (context, index) {
        final k = groupKeys[index];
        final items = map[k]!..sort((a, b) => b.date.compareTo(a.date));
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: index == 0 ? 0 : 8.h, bottom: 8.h),
              child: Text(
                k,
                style: tt.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                  color: cs.onSurfaceVariant,
                ),
              ),
            ),
            ...items.map((rx) => _card(context, rx)),
          ],
        );
      },
    );
  }

  Widget _card(BuildContext context, Prescription rx) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Dismissible(
        key: ValueKey('rx-${rx.id}'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            Icons.delete_outline_rounded,
            color: Theme.of(context).colorScheme.onErrorContainer,
            size: 24.r,
          ),
        ),
        confirmDismiss: (_) async {
          await _confirmDelete(context, rx);
          return false;
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => _showAddPrescription(context, initial: rx),
          onLongPress: () => _showCardActions(context, rx),
          child: PrescriptionCard(
            doctorName: rx.doctorName,
            date: _formatDate(rx.date),
            reason: rx.reason,
            medicines: rx.medicines,
            isScanned: rx.isScanned,
            onScan: rx.isScanned
                ? null
                : () => _showAddPrescription(context, initial: rx),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day} ${_months[date.month - 1]} ${date.year}';
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onAdd;
  final VoidCallback onScan;

  const _EmptyState({required this.onAdd, required this.onScan});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined,
                size: 64.r, color: cs.outlineVariant),
            SizedBox(height: 16.h),
            Text(
              'No prescriptions yet',
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'Add your first prescription manually or scan an existing one.',
              textAlign: TextAlign.center,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: onScan,
                  icon: Icon(Icons.document_scanner_outlined, size: 18.r),
                  label: Text('Scan', style: TextStyle(fontSize: 14.sp)),
                ),
                SizedBox(width: 12.w),
                FilledButton.icon(
                  onPressed: onAdd,
                  icon: Icon(Icons.add_rounded, size: 18.r),
                  label: Text('Add manually', style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
