import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injector.dart';
import 'core/flavor/flavor_config.dart';
import 'design_system/design_system.dart';
import 'domain/entities/app_theme_mode.dart';
import 'modules/catalog/pages/catalog_page.dart';
import 'modules/settings/cubit/settings_cubit.dart';

class NosChallengeApp extends StatelessWidget {
  const NosChallengeApp({super.key, required this.config});

  final FlavorConfig config;

  @override
  Widget build(BuildContext context) {
    // Acima do MaterialApp: o tema é global e o drawer de qualquer ecrã o lê.
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..loadAppInfo(),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, settings) => MaterialApp(
          title: config.appName,
          debugShowCheckedModeBanner: false,
          theme: DSTheme.light,
          darkTheme: DSTheme.dark,
          themeMode: _toThemeMode(settings.themeMode),
          builder: (context, child) => config.isProd
              ? child!
              : DSFlavorBanner(label: config.label, child: child!),
          home: const CatalogPage(),
        ),
      ),
    );
  }

  /// Converte a preferência do domínio para o tipo do Flutter.
  static ThemeMode _toThemeMode(AppThemeMode mode) => switch (mode) {
    AppThemeMode.system => ThemeMode.system,
    AppThemeMode.light => ThemeMode.light,
    AppThemeMode.dark => ThemeMode.dark,
  };
}
