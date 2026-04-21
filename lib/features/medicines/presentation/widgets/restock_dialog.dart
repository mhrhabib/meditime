import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/medicines/domain/entities/medicine.dart';

class RestockDialog extends StatefulWidget {
  final Medicine medicine;

  const RestockDialog({super.key, required this.medicine});

  static Future<int?> show(BuildContext context, Medicine medicine) {
    return showDialog<int>(
      context: context,
      builder: (_) => RestockDialog(medicine: medicine),
    );
  }

  @override
  State<RestockDialog> createState() => _RestockDialogState();
}

class _RestockDialogState extends State<RestockDialog> {
  final _controller = TextEditingController(text: '30');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final m = widget.medicine;
    return AlertDialog(
      title: Text('Restock ${m.name}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current stock: ${m.stockRemaining} / ${m.stockTotal}',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14.sp,
                color: cs.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 14.h),
            TextFormField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Units to add',
                hintText: 'e.g. 30',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                final n = int.tryParse((v ?? '').trim());
                if (n == null || n <= 0) return 'Enter a number greater than 0';
                return null;
              },
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              children: [
                for (final quick in const [10, 30, 60, 90])
                  ActionChip(
                    label: Text('+$quick', style: Theme.of(context).textTheme.labelSmall),
                    onPressed: () =>
                        _controller.text = quick.toString(),
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            final amount = int.parse(_controller.text.trim());
            Navigator.pop(context, amount);
          },
          child: const Text('Add to stock'),
        ),
      ],
    );
  }
}
