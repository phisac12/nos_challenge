import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/flavor/flavor_config.dart';

/// Arranque comum a todos os flavors: só a configuração muda.
void bootstrap(FlavorConfig config) {
  WidgetsFlutterBinding.ensureInitialized();
  setupInjector(config);
  runApp(NosChallengeApp(config: config));
}
