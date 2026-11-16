import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../design_system/design_system.dart';
import '../../../domain/entities/app_theme_mode.dart';
import '../cubit/settings_cubit.dart';

/// Menu da app: tema e versão. Lê e altera só através do [SettingsCubit].
class SettingsDrawer extends StatelessWidget {
  const SettingsDrawer({super.key});

  static const _themeSegments = [
    DSSegment(
      value: AppThemeMode.system,
      label: 'Sistema',
      icon: Icons.brightness_auto_rounded,
    ),
    DSSegment(
      value: AppThemeMode.light,
      label: 'Claro',
      icon: Icons.light_mode_rounded,
    ),
    DSSegment(
      value: AppThemeMode.dark,
      label: 'Escuro',
      icon: Icons.dark_mode_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) => DSDrawer(
        title: state.appName,
        subtitle: 'Catálogo de filmes',
        children: [
          DSDrawerTile(
            icon: Icons.palette_outlined,
            title: 'Tema',
            bottom: DSSegmentedControl<AppThemeMode>(
              segments: _themeSegments,
              selected: state.themeMode,
              onChanged: context.read<SettingsCubit>().changeThemeMode,
            ),
          ),
          DSDrawerTile(
            icon: Icons.info_outline_rounded,
            title: 'Versão da app',
            subtitle: state.appVersion ?? '—',
          ),
        ],
      ),
    );
  }
}
