import 'package:flutter/material.dart';

import 'design_system/design_system.dart';
import 'modules/catalog/pages/catalog_page.dart';

class MovieCatalogApp extends StatelessWidget {
  const MovieCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      debugShowCheckedModeBanner: false,
      theme: DSTheme.dark,
      home: const CatalogPage(),
    );
  }
}
