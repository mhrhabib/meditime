import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/medicines/domain/refill_predictor.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/medicines/presentation/widgets/edit_medicine_sheet.dart';
import 'package:meditime/features/medicines/presentation/widgets/restock_dialog.dart';

// ─── MEDICINE LIST SCREEN ────────────────────────────────────
class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Medicines', style: TextStyle(fontSize: 20.sp)),
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
          actions: [
            IconButton(
              icon: Icon(Icons.sort_rounded, size: 24.r),
              onPressed: () {},
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(108.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: TextStyle(fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'Search medicines...',
                      hintStyle: TextStyle(fontSize: 14.sp),
                      prefixIcon: Icon(Icons.search_rounded, size: 20.r),
                      filled: true,
                      fillColor: cs.surfaceContainerHigh,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3.h,
                    labelColor: cs.primary,
                    unselectedLabelColor: cs.onSurfaceVariant,
                    labelStyle: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 13.sp),
                    unselectedLabelStyle: tt.labelLarge?.copyWith(fontSize: 13.sp),
                    tabs: const [
                      Tab(text: 'All'),
                      Tab(text: 'Active'),
                      Tab(text: 'Low Stock'),
                      Tab(text: 'Completed'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _MedicineListTab(filter: 'all', searchQuery: _searchQuery),
            _MedicineListTab(filter: 'running', searchQuery: _searchQuery),
            _MedicineListTab(filter: 'low', searchQuery: _searchQuery),
            _MedicineListTab(filter: 'done', searchQuery: _searchQuery),
          ],
        ),
      ),
    );
  }
}

class _MedicineListTab extends StatelessWidget {
  final String filter;
  final String searchQuery;
  const _MedicineListTab({this.filter = 'all', this.searchQuery = ''});

  void _toast(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineCubit, MedicineState>(
      builder: (context, state) {
        final filteredMeds = state.medicines.where((med) {
          final matchesSearch = med.name.toLowerCase().contains(searchQuery.toLowerCase());
          if (!matchesSearch) return false;

          if (filter == 'running') return med.stockRemaining > 0 && !med.isLowStock;
          if (filter == 'low') return med.isLowStock;
          if (filter == 'done') return med.stockRemaining == 0;
          return true; // 'all'
        }).toList();

        if (filteredMeds.isEmpty) {
          return Center(
            child: Text(
              'No medicines found.',
              style: TextStyle(fontSize: 14.sp, color: Theme.of(context).colorScheme.outline),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: filteredMeds.length + 1,
          itemBuilder: (context, index) {
            if (index == filteredMeds.length) {
              return SizedBox(height: 80.h);
            }
            final med = filteredMeds[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: MedicineCard(
                name: med.name,
                type: med.type,
                schedule: med.schedule,
                stockRemaining: med.stockRemaining,
                stockTotal: med.stockTotal,
                daysLeft: med.daysLeft,
                isLowStock: med.isLowStock,
                onEdit: () async {
                  final updated = await EditMedicineSheet.show(context, med);
                  if (updated == null) return;
                  if (!context.mounted) return;
                  await context.read<MedicineCubit>().updateMedicine(updated);
                  _toast('Updated ${updated.name}');
                },
                onRestock: () async {
                  final amount = await RestockDialog.show(context, med);
                  if (amount == null) return;
                  if (!context.mounted) return;
                  final newRemaining = (med.stockRemaining + amount)
                      .clamp(0, med.stockTotal + amount);
                  final newTotal = newRemaining > med.stockTotal
                      ? newRemaining
                      : med.stockTotal;
                  final dosesPerDay =
                      RefillPredictor.parseDosesPerDay(med.schedule);
                  final prediction = RefillPredictor.predict(
                    currentStock: newRemaining,
                    dosesPerDay: dosesPerDay,
                  );
                  await context.read<MedicineCubit>().updateMedicine(
                        med.copyWith(
                          stockRemaining: newRemaining,
                          stockTotal: newTotal,
                          daysLeft: prediction.daysRemaining,
                          isLowStock: prediction.isWarning,
                        ),
                      );
                  _toast('Restocked ${med.name} (+$amount)');
                },
                onRefill: med.isLowStock
                    ? () async {
                        final amount =
                            await RestockDialog.show(context, med);
                        if (amount == null) return;
                        if (!context.mounted) return;
                        final newRemaining = (med.stockRemaining + amount)
                            .clamp(0, med.stockTotal + amount);
                        final newTotal = newRemaining > med.stockTotal
                            ? newRemaining
                            : med.stockTotal;
                        final dosesPerDay = RefillPredictor.parseDosesPerDay(
                            med.schedule);
                        final prediction = RefillPredictor.predict(
                          currentStock: newRemaining,
                          dosesPerDay: dosesPerDay,
                        );
                        await context
                            .read<MedicineCubit>()
                            .updateMedicine(
                              med.copyWith(
                                stockRemaining: newRemaining,
                                stockTotal: newTotal,
                                daysLeft: prediction.daysRemaining,
                                isLowStock: prediction.isWarning,
                              ),
                            );
                        _toast('Refilled ${med.name} (+$amount)');
                      }
                    : null,
                onDelete: () {
                  context.read<MedicineCubit>().deleteMedicine(med.id);
                  _toast('Removed ${med.name}');
                },
              ),
            );
          },
        );
      },
    );
  }
}
