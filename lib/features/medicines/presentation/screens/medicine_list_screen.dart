import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';

// ─── MEDICINE LIST SCREEN ────────────────────────────────────
class MedicineListScreen extends StatefulWidget {
  const MedicineListScreen({super.key});

  @override
  State<MedicineListScreen> createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Medicines'),
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 2,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                labelColor: cs.primary,
                unselectedLabelColor: cs.onSurfaceVariant,
                labelStyle: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: tt.labelLarge,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Active'),
                  Tab(text: 'Low Stock'),
                  Tab(text: 'Completed'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _MedicineListTab(filter: 'all'),
            _MedicineListTab(filter: 'running'),
            _MedicineListTab(filter: 'low'),
            _MedicineListTab(filter: 'done'),
          ],
        ),
      ),
    );
  }
}

class _MedicineListTab extends StatelessWidget {
  final String filter;
  const _MedicineListTab({this.filter = 'all'});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicineCubit, MedicineState>(
      builder: (context, state) {
        final filteredMeds = state.medicines.where((med) {
          if (filter == 'running') return med.stockRemaining > 0 && !med.isLowStock;
          if (filter == 'low') return med.isLowStock;
          if (filter == 'done') return med.stockRemaining == 0;
          return true; // 'all'
        }).toList();

        if (filteredMeds.isEmpty) {
          return const Center(child: Text('No medicines found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filteredMeds.length + 1, // +1 for bottom padding
          itemBuilder: (context, index) {
            if (index == filteredMeds.length) {
              return const SizedBox(height: 80);
            }
            final med = filteredMeds[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: MedicineCard(
                name: med.name,
                type: med.type,
                schedule: med.schedule,
                stockRemaining: med.stockRemaining,
                stockTotal: med.stockTotal,
                daysLeft: med.daysLeft,
                isLowStock: med.isLowStock,
                onEdit: () {},
                onRefill: med.isLowStock ? () {} : null,
              ),
            );
          },
        );
      },
    );
  }
}

