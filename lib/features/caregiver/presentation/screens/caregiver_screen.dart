import 'package:flutter/material.dart';

class CaregiverScreen extends StatefulWidget {
  const CaregiverScreen({super.key});

  @override
  State<CaregiverScreen> createState() => _CaregiverScreenState();
}

class _CaregiverScreenState extends State<CaregiverScreen> {
  // Mock internal state for caregiver permissions
  bool _canView = true;
  bool _canEdit = false;
  bool _missedAlerts = true;
  bool _dailySummary = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Caregiver Access'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'Share your schedule with family or doctors so they can help you stay on track.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.link),
                label: const Text('Invite caregiver by link'),
                style: FilledButton.styleFrom(
                   padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Center(
               child: Text(
                'Caregivers don\'t need to install the app',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.outline),
              ),
            ),

            const SizedBox(height: 32),
            const Text('Active Caregivers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            // Mock Caregiver Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Text('FH', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Fahmidah (Daughter)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Active since Mar 2026', style: TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 13)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert),
                        onPressed: () {},
                        color: Theme.of(context).colorScheme.outline,
                      )
                    ],
                  ),
                  const Divider(height: 32),
                  _buildToggleRow('View medicines', _canView, (v) => setState(() => _canView = v)),
                  _buildToggleRow('Edit & refill meds', _canEdit, (v) => setState(() => _canEdit = v)),
                  _buildToggleRow('Missed dose alerts', _missedAlerts, (v) => setState(() => _missedAlerts = v)),
                  _buildToggleRow('Daily summary emails', _dailySummary, (v) => setState(() => _dailySummary = v)),
                  
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () {}, 
                    icon: Icon(Icons.cancel, color: Theme.of(context).colorScheme.error, size: 18),
                    label: Text('Revoke access', style: TextStyle(color: Theme.of(context).colorScheme.error)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Switch(
            value: value, 
            onChanged: onChanged,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
