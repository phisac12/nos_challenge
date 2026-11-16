import 'package:flutter/material.dart';

import 'design_system/design_system.dart';
import 'modules/catalog/pages/catalog_page.dart';

class NosChallengeApp extends StatelessWidget {
  const NosChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nos Challenge',
      debugShowCheckedModeBanner: false,
      theme: DSTheme.dark,
      home: const CatalogPage(),
    );
  }
}
