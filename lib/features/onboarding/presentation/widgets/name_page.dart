import 'package:flutter/material.dart';

import 'shared.dart';

class NamePage extends StatefulWidget {
  final String initial;
  final ValueChanged<String> onNext;
  const NamePage({super.key, required this.initial, required this.onNext});

  @override
  State<NamePage> createState() => _NamePageState();
}

class _NamePageState extends State<NamePage> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initial);
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
            const PageHeader(
              icon: Icons.person_outline_rounded,
              title: "What's your\nname?",
              subtitle: 'We\'ll use this to personalise your reminders.',
            ),
            const SizedBox(height: 32),
            TextFormField(
              controller: _controller,
              textCapitalization: TextCapitalization.words,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Your name',
                hintText: 'e.g. Rafiq',
                prefixIcon: Icon(Icons.badge_outlined),
              ),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
            const SizedBox(height: 32),
            NextButton(label: 'Continue', onTap: _submit),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onNext(_controller.text.trim());
    }
  }
}
