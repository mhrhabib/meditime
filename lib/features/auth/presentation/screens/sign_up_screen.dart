import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/auth_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    HapticFeedback.lightImpact();
    context.read<AuthCubit>().signUp(_emailCtrl.text.trim(), _passCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (ctx, state) {
        if (state is AuthAuthenticated) {
          ctx.go('/');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: state.message.contains('confirm')
                  ? cs.primary
                  : cs.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (state.message.contains('confirm')) {
            Future.delayed(const Duration(seconds: 2), () {
              if (ctx.mounted) ctx.go('/sign-in');
            });
          }
        }
      },
      child: Scaffold(
        backgroundColor:
            isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF5F7FF),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                Text('Create account',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ))
                    .animate()
                    .fadeIn(duration: 400.ms),
                SizedBox(height: 6.h),
                Text(
                    'One account — all family members, all devices synced.',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 14.sp,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ))
                    .animate()
                    .fadeIn(delay: 80.ms, duration: 400.ms),
                SizedBox(height: 32.h),
                // Consent pill
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                        color: cs.primary.withValues(alpha: 0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined,
                          size: 18.r, color: cs.primary),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          'Your medication data is stored encrypted on secure servers. '
                          'Only devices signed into this account can read it.',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            fontSize: 12.sp,
                            color: cs.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
                SizedBox(height: 28.h),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthInputField(
                        controller: _emailCtrl,
                        label: 'Email address',
                        hint: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Email is required';
                          }
                          if (!v.contains('@')) return 'Enter a valid email';
                          return null;
                        },
                      ).animate().fadeIn(delay: 160.ms, duration: 400.ms),
                      SizedBox(height: 16.h),
                      AuthInputField(
                        controller: _passCtrl,
                        label: 'Password',
                        hint: 'Min. 6 characters',
                        obscureText: _obscurePass,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: cs.outline,
                            size: 20.r,
                          ),
                          onPressed: () =>
                              setState(() => _obscurePass = !_obscurePass),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Password is required';
                          }
                          if (v.length < 6) return 'Minimum 6 characters';
                          return null;
                        },
                      ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                      SizedBox(height: 16.h),
                      AuthInputField(
                        controller: _confirmCtrl,
                        label: 'Confirm password',
                        hint: '••••••••',
                        obscureText: _obscureConfirm,
                        prefixIcon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirm
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: cs.outline,
                            size: 20.r,
                          ),
                          onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm),
                        ),
                        validator: (v) {
                          if (v != _passCtrl.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ).animate().fadeIn(delay: 240.ms, duration: 400.ms),
                      SizedBox(height: 28.h),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (ctx, state) {
                          final loading = state is AuthAuthenticating;
                          return SizedBox(
                            width: double.infinity,
                            height: 54.h,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [cs.primary, cs.tertiary],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: cs.primary.withValues(alpha: 0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  )
                                ],
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                ),
                                onPressed: loading ? null : _submit,
                                child: loading
                                    ? SizedBox(
                                        width: 22.r,
                                        height: 22.r,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text('Create Account',
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                        )),
                              ),
                            ),
                          ).animate().fadeIn(delay: 280.ms, duration: 400.ms);
                        },
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account? ',
                              style: TextStyle(
                                fontFamily: 'Nunito',
                                fontSize: 14.sp,
                                color: cs.onSurface.withValues(alpha: 0.55),
                              )),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Text('Sign In',
                                style: TextStyle(
                                  fontFamily: 'Nunito',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary,
                                )),
                          ),
                        ],
                      ).animate().fadeIn(delay: 320.ms, duration: 400.ms),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
