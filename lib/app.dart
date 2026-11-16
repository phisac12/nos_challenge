import 'package:flutter/material.dart';

import 'core/flavor/flavor_config.dart';
import 'design_system/design_system.dart';
import 'modules/catalog/pages/catalog_page.dart';

class NosChallengeApp extends StatelessWidget {
  const NosChallengeApp({super.key, required this.config});

  final FlavorConfig config;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appName,
      debugShowCheckedModeBanner: false,
      theme: DSTheme.dark,
      builder: (context, child) => config.isProd
          ? child!
          : DSFlavorBanner(label: config.label, child: child!),
      home: const CatalogPage(),
    );
  }
}
