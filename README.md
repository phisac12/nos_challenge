# Movie Catalog

Catálogo de filmes em Flutter: scroll vertical entre secções (páginas 1, 2 e 3 do endpoint `discover/movie`) e horizontal pelos filmes de cada secção.

## Como executar

Requer Flutter 3.35+ e uma API key do TMDB (não versionada).

```bash
flutter pub get
flutter run --dart-define=TMDB_API_KEY=<a_tua_key>
```

Testes:

```bash
flutter test
```

## Arquitetura

```
lib/
├── core/            # DI (get_it), Env (--dart-define), Result<T>
├── network/         # ApiClient (Dio), interceptor da api_key, endpoints, NetworkException
├── domain/          # Entidades, contratos de repositório, use cases (1 por serviço)
├── data/            # DTOs (fromJson → entidade), datasources remotos, repositórios
├── design_system/   # Tokens + componentes DS* (DSScreen, DSButton, DSMovieCard, ...)
└── modules/         # Funcionalidades: cada módulo tem cubit/ e pages/
    ├── catalog/
    └── movie_detail/
```

Fluxo: `Page → Cubit → UseCase → Repository → DataSource → ApiClient`.

## Decisões

- **Cubit (flutter_bloc)** — o fluxo é simples (carregar, selecionar); Cubit dá estado previsível e testável sem a cerimónia de eventos do Bloc.
- **Regras de negócio no cubit** — o limiar `>= 6.0` (destaque e acesso ao detalhe) e as páginas das secções vivem no `CatalogCubit`. As páginas só chamam métodos do cubit e desenham o estado.
- **Secções independentes** — o estado é um `Map<page, SectionState>` (loading/loaded/error por secção). Os três pedidos partem em paralelo e cada um emite quando termina, sem `Future.wait`. Cada secção tem *retry* próprio.
- **Efeitos one-shot** — navegação e aviso de classificação baixa são `CatalogEffect`s consumidos por um `BlocListener`, mantendo a UI sem lógica.
- **Use cases + repositório abstrato** — o cubit depende de `GetDiscoverMoviesUseCase`, que depende de um contrato do domínio. Facilita mocks nos testes e troca de fonte de dados (ex.: cache local).
- **`Result<T>` selado** — erros de rede são convertidos em `Failure` no repositório; nenhuma exceção chega ao cubit.
- **Camada de network isolada** — só o `ApiClient` conhece o Dio; a api_key entra por interceptor.
- **Design System interno** — componentes `DS*` sem conhecimento de domínio (recebem URL, nota, `highlighted`). Pode ser extraído para um package sem alterações.
- **Injeção de dependências** com `get_it`; cubits registados como `factory`.
- **Detalhe sem cubit** — o ecrã só apresenta um filme já validado; um cubit seria cerimónia sem ganho.

## Testes

- `CatalogCubit`: secções independentes, regra de destaque (incluindo o limite 6.0), abrir detalhe vs. aviso.
- `MovieModel`: parsing e construção da URL do poster.
