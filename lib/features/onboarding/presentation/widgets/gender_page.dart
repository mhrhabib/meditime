import 'package:flutter/material.dart';

import 'shared.dart';

class GenderPage extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onNext;
  const GenderPage({super.key, required this.initial, required this.onNext});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  late String _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            icon: Icons.wc_rounded,
            title: 'Select your\ngender',
            subtitle:
                'Some medicines behave differently. This stays private on your device.',
          ),
          const SizedBox(height: 28),
          Row(
            children: ['Male', 'Female'].map((g) {
              final isSelected = _selected == g;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: g != 'Other' ? 10 : 0),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = g),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 22),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? cs.primaryContainer
                            : cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? cs.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            g == 'Male'
                                ? Icons.male_rounded
                                : g == 'Female'
                                    ? Icons.female_rounded
                                    : Icons.transgender_rounded,
                            color: isSelected ? cs.primary : cs.outline,
                            size: 30,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            g,
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 14,
                              color: isSelected ? cs.primary : cs.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          NextButton(label: 'Continue', onTap: () => widget.onNext(_selected)),
        ],
      ),
    );
  }
}
