import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meditime/app/router.dart';
import 'package:meditime/core/theme/app_theme.dart';
import 'package:meditime/core/theme/cubit/theme_cubit.dart';
import 'package:meditime/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:meditime/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:meditime/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:meditime/features/history/presentation/cubit/history_cubit.dart';
import 'package:meditime/features/medicines/presentation/cubit/medicine_cubit.dart';
import 'package:meditime/features/prescriptions/presentation/cubit/prescription_cubit.dart';
import 'package:meditime/features/reminders/presentation/cubit/settings_cubit.dart';
import 'package:meditime/core/sync/sync_service.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediTimeApp extends StatefulWidget {
  const MediTimeApp({super.key});

  @override
  State<MediTimeApp> createState() => _MediTimeAppState();
}

class _MediTimeAppState extends State<MediTimeApp> with WidgetsBindingObserver {
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authCubit = AuthCubit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Trigger sync on app resume
      SyncService.instance.sync();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: _authCubit),
            BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
            BlocProvider<OnboardingCubit>(create: (_) => OnboardingCubit()),
            BlocProvider<ProfileCubit>(create: (_) => ProfileCubit()),
            BlocProvider<MedicineCubit>(
              create: (context) =>
                  MedicineCubit(profileCubit: context.read<ProfileCubit>()),
            ),
            BlocProvider<HistoryCubit>(create: (_) => HistoryCubit()),
            BlocProvider<PrescriptionCubit>(create: (_) => PrescriptionCubit()),
            BlocProvider<SettingsCubit>(create: (_) => SettingsCubit()),
          ],
          child: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final isDark = themeState.themeMode == ThemeMode.dark ||
                  (themeState.themeMode == ThemeMode.system &&
                      MediaQuery.platformBrightnessOf(context) ==
                          Brightness.dark);

              SystemChrome.setSystemUIOverlayStyle(
                SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness:
                      isDark ? Brightness.light : Brightness.dark,
                  systemNavigationBarColor: isDark
                      ? AppTheme.dark().colorScheme.surface
                      : AppTheme.light().colorScheme.surface,
                  systemNavigationBarIconBrightness:
                      isDark ? Brightness.light : Brightness.dark,
                ),
              );

              return MaterialApp.router(
                title: 'MediTime',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light(),
                darkTheme: AppTheme.dark(),
                themeMode: themeState.themeMode,
                routerConfig: AppRouter.buildRouter(_authCubit),
              );
            },
          ),
        );
      },
    );
  }
}
