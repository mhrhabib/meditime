import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/core/widgets/components.dart';
import 'package:meditime/features/prescriptions/presentation/cubit/prescription_cubit.dart';

class PrescriptionsScreen extends StatelessWidget {
  const PrescriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prescriptions'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.document_scanner_outlined),
              tooltip: 'Scan or Upload',
            ),
            const SizedBox(width: 8),
          ],
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
                labelStyle:
                    tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                unselectedLabelStyle: tt.labelLarge,
                tabs: const [
                  Tab(text: 'By Date'),
                  Tab(text: 'By Doctor'),
                  Tab(text: 'By Disease'),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<PrescriptionCubit, PrescriptionState>(
          builder: (context, state) {
            if (state.prescriptions.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description_outlined,
                        size: 64, color: cs.outlineVariant),
                    const SizedBox(height: 16),
                    Text('No prescriptions found',
                        style:
                            tt.bodyLarge?.copyWith(color: cs.onSurfaceVariant)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Prescription'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: state.prescriptions.length,
              itemBuilder: (context, index) {
                final rx = state.prescriptions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: PrescriptionCard(
                    doctorName: rx.doctorName,
                    date: _formatDate(rx.date),
                    reason: rx.reason,
                    medicines: rx.medicines,
                    isScanned: rx.isScanned,
                    onScan: rx.isScanned ? null : () {},
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
