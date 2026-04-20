import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';

class ProfileSetupScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const ProfileSetupScreen({super.key, required this.onComplete});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  String _selectedGender = 'Male';
  String _selectedBlood = 'O+';
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Profile', style: TextStyle(fontSize: 20.sp)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Details',
              style: tt.headlineSmall?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),
            Text(
              'Let\'s build your medical profile for accurate reminders.',
              style: tt.bodyMedium?.copyWith(
                    color: cs.outline,
                    fontSize: 14.sp,
                  ),
            ),
            SizedBox(height: 32.h),
            TextField(
              controller: _nameController,
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.person, size: 24.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    style: TextStyle(fontSize: 14.sp, color: cs.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(fontSize: 14.sp),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    items: ['Male', 'Female', 'Other'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                    onChanged: (v) => setState(() => _selectedGender = v!),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBlood,
                    style: TextStyle(fontSize: 14.sp, color: cs.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Blood Group',
                      labelStyle: TextStyle(fontSize: 14.sp),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                    items: ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-']
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedBlood = v!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            TextField(
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                labelText: 'Health Conditions (e.g. Diabetes, BP)',
                labelStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.medical_information, size: 24.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              maxLines: 2,
            ),
            SizedBox(height: 20.h),
            TextField(
              style: TextStyle(fontSize: 15.sp),
              decoration: InputDecoration(
                labelText: 'Allergies',
                labelStyle: TextStyle(fontSize: 14.sp),
                prefixIcon: Icon(Icons.warning_amber, size: 24.r),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: FilledButton(
            onPressed: _isSaving
                ? null
                : () async {
                    setState(() => _isSaving = true);

                    final name = _nameController.text.trim();
                    if (name.isNotEmpty) {
                      await context.read<ProfileCubit>().addProfile(name);
                    }

                    await Future.delayed(const Duration(milliseconds: 600));
                    widget.onComplete();
                  },
            style: FilledButton.styleFrom(
              minimumSize: Size(double.infinity, 56.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
            ),
            child: _isSaving
                ? SizedBox(
                    height: 20.r, width: 20.r, child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text('Save Profile', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
