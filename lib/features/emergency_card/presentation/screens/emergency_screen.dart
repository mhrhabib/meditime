import 'package:flutter/material.dart';
import 'package:meditime/core/widgets/components.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Card'),
        centerTitle: false,
        actions: [
          IconButton(icon: const Icon(Icons.edit_note_rounded), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const EmergencyCardWidget(
              name: 'Rafiq Ahmed',
              age: '34',
              bloodGroup: 'B+',
              allergies: ['Penicillin', 'Sulfa drugs'],
              conditions: ['Type 2 Diabetes', 'Hypertension'],
              medicines: ['Metformin 500mg', 'Amlodipine 5mg'],
              emergencyContact: 'Sadia Ahmed — 017XXXXXXXX',
              lastUpdated: 'Updated 14 Mar',
            ),
            const SizedBox(height: 20),
            
            // Scannable QR section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: cs.onSurface.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(Icons.qr_code_2_rounded, size: 40, color: cs.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Scannable without app', 
                          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text('First responders scan this QR to see your card — no phone unlock needed.', 
                          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            AlertBanner(
              message: 'Add this as a lock screen widget so first responders can access it without unlocking your phone.',
              type: AlertType.warning,
              actionLabel: 'Set up',
              onAction: () {},
            ),
            
            const SizedBox(height: 32),
            
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.share_rounded, size: 18),
              label: const Text('Export Card as PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
