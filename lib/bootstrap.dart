import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/flavor/flavor_config.dart';

/// Arranque comum a todos os flavors: só a configuração muda.
Future<void> bootstrap(FlavorConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carregado antes do runApp para a app abrir já com o tema guardado.
  final prefs = await SharedPreferences.getInstance();
  setupInjector(config, prefs);
  runApp(NosChallengeApp(config: config));
}
