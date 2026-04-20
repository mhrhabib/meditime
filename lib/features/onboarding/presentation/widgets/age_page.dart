import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';

import 'shared.dart';

class AgePage extends StatefulWidget {
  final int? initial;
  final ValueChanged<int> onNext;
  const AgePage({super.key, required this.initial, required this.onNext});

  @override
  State<AgePage> createState() => _AgePageState();
}

class _AgePageState extends State<AgePage> {
  late final TextEditingController _controller = TextEditingController(
      text: widget.initial != null ? widget.initial.toString() : '');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              icon: Icons.cake_outlined,
              title: _headerTitle(context),
              subtitle:
                  'Helps us tailor dose warnings and refill timing for you.',
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'e.g. 34',
                prefixIcon: Icon(Icons.cake_outlined),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Please enter your age';
                final age = int.tryParse(v);
                if (age == null || age < 1 || age > 120) {
                  return 'Enter a valid age';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            NextButton(label: 'Continue', onTap: _submit),
          ],
        ),
      ),
    );
  }

  String _headerTitle(BuildContext context) {
    final name = context.read<OnboardingCubit>().state.userName;
    return name != null && name.isNotEmpty
        ? 'Nice to meet you,\n$name. Your age?'
        : 'How old\nare you?';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(int.parse(_controller.text));
    }
  }
}
