enum Flavor { dev, qa, prod }

/// Configuração do ambiente em execução. Definida uma vez no entrypoint
/// (`lib/flavors/main_dev.dart`, `main_qa.dart`, `main_prod.dart`) e injetada via get_it.
class FlavorConfig {
  const FlavorConfig._({
    required this.flavor,
    required this.appName,
    required this.enableNetworkLogs,
  });

  static const dev = FlavorConfig._(
    flavor: Flavor.dev,
    appName: 'Nos Challenge DEV',
    enableNetworkLogs: true,
  );

  static const qa = FlavorConfig._(
    flavor: Flavor.qa,
    appName: 'Nos Challenge QA',
    enableNetworkLogs: true,
  );

  static const prod = FlavorConfig._(
    flavor: Flavor.prod,
    appName: 'Nos Challenge',
    enableNetworkLogs: false,
  );

  final Flavor flavor;
  final String appName;
  final bool enableNetworkLogs;

  bool get isProd => flavor == Flavor.prod;

  /// Etiqueta mostrada no canto do ecrã fora de produção.
  String get label => flavor.name.toUpperCase();
}
