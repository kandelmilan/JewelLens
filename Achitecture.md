# Jewellens — App Architecture

This document explains how the codebase is organized and why, so a new developer can get productive without a walkthrough call.

## 1. High-level pattern

This app follows **Feature-First architecture** with a **GetX-flavored MVVM** inside each feature, plus a thin **Repository layer** between the Controller and the Service.

```
View  ⇄  Controller (GetxController)  ⇄  Repository  ⇄  Service (raw API calls, via Model)
```

- **Model** — plain Dart classes with `fromJson` factories, matching the API response shape (e.g. `LoginModel`, `RegisterModel`).
- **Service** — Pure API calls (Dio requests) for one feature. No business logic, no state. Returns parsed Models.
- **Repository** — An abstract interface + one concrete implementation per feature (e.g. `AuthRepository` / `AuthRepositoryImpl`). Today it's a thin pass-through to the Service. The Controller depends on the *interface*, never on the Service or Dio directly.
- **Controller** — Holds UI state (`.obs` variables), handles user actions (button taps, form submits), calls the Repository, and stores results (e.g. saving a token via `TokenStorage`). Never imports a Service or Dio directly.
- **View** — Flutter widgets. No business logic, no direct API calls. Reads state from a controller via `Obx()` / `GetX<T>`.

**Why bother with a Repository that just forwards to the Service today?** Two reasons, applied consistently from the start so it's a habit rather than a retrofit:

1. **Testability** — a Controller can be unit tested by passing in a fake `Repository` (plain Dart class implementing the interface), with no Dio, no network, no HTTP mocking. See `AuthController`'s constructor — it accepts an optional `AuthRepository` for exactly this.
2. **Future-proofing data sources** — if a feature later needs offline support, local caching, or combining two APIs, only that feature's `RepositoryImpl` changes. The Controller and View never know or care.

Every new feature follows this shape from day one — see §7 for the exact template. This is a conscious choice to pay a small, consistent cost per feature now rather than doing a larger retrofit across many controllers later.

We do **not** use full Clean Architecture (no separate `entities`, no use-case classes per action) — that level of ceremony isn't earning its keep for this app's complexity. If a specific feature grows real business-rule complexity (e.g. checkout with multiple payment/discount rules), it's fine to add a use-case layer *just for that feature* — don't apply it everywhere by default.

## 2. Folder structure

```
lib/
  main.dart                  # App entry point — bootstrap ONLY (see §3)
  app.dart                   # MyApp / GetMaterialApp widget lives here

  core/                      # App-wide infrastructure, not tied to any feature
    bindings/
      controller_binding.dart
    network/
      api_client.dart          # Dio instance + base config
      auth_interceptor.dart    # attaches auth token, handles 401
      inspector_interceptor.dart # debug-only network inspector, gated by kDebugMode
    routers/                  # (if using named routes — see note below)
    theme/
    utils/
      app_size.dart
    assets/
      app_assets.dart

  services/                  # CROSS-CUTTING services only — used by many features
    storage/
      token_storage.dart      # secure token persistence
    inactivity/
      inactivity_service.dart # auto-logout after 5 min idle

  features/                  # One folder per feature. Self-contained.
    auth/
      controllers/
        auth_controller.dart
      repositories/
        auth_repository.dart  # abstract AuthRepository + AuthRepositoryImpl
      services/
        auth_service.dart     # only auth_repository.dart calls this
      models/
        login_model.dart
        register_model.dart
      views/
        login_view.dart
        register_view.dart
    product/
      controllers/
      repositories/
      services/
      models/
      views/
      widgets/               # widgets used only within this feature
    category/
    home/
    onboarding/
    splash/
    main_nav/

  widgets/                   # Shared/reusable widgets used across MULTIPLE features
```

### The rule for "does this go in `core`/root `services`, or inside a feature?"

Ask: **"If I deleted this feature entirely, would this file be deleted with it?"**

- Yes → it belongs inside that feature's folder (e.g. `product_service.dart` → `features/product/services/`)
- No, other features would break → it's cross-cutting → goes in `core/` or root `services/`

Examples: `TokenStorage` and `InactivityService` are used by every feature → root `services/`. `ProductService` is only ever called from Product's controller/repository → `features/product/services/`.

## 3. `main.dart` vs `app.dart`

`main.dart` is a **bootstrap file only** — it initializes bindings/services and calls `runApp()`. It does not contain the `GetMaterialApp` widget itself.

`app.dart` contains the actual `App` widget — theme, initial route, and the global `Listener` that feeds touch events into `InactivityService` (see §5).

**Why split:** keeps `main.dart` minimal as more init steps get added (env config, crash reporting, Firebase, etc.), and allows multiple entry points later (`main_dev.dart`, `main_prod.dart`) without duplicating the app widget.

## 4. Network layer (`core/network/`)

- **`api_client.dart`** — single shared `Dio` instance (`ApiClient.dio`) used by every feature's service. All base config (base URL, timeouts, headers) lives here.
- **`auth_interceptor.dart`** —
  - `onRequest`: reads the current access token from `TokenStorage` and attaches `Authorization: Bearer <token>` to every outgoing request automatically. No service needs to do this manually.
  - `onError`: if a request comes back `401`, clears stored tokens and force-navigates to `LoginView`. This is the single place session expiry is handled — don't duplicate 401 handling in individual controllers.
- **`inspector_interceptor.dart`** — wraps `requests_inspector`, gated behind `kDebugMode`. Returns an empty interceptor list in release builds, so `ApiClient` never ships this in production. **Never remove the `kDebugMode` gate** — it would expose full request/response bodies (including tokens) on production devices.

Any new feature's service should call `ApiClient.dio` for all requests — never create a new `Dio()` instance per feature.

## 5. Session & security services (root `services/`)

- **`TokenStorage`** (`services/storage/token_storage.dart`) — wraps `flutter_secure_storage`. Holds `saveAccessToken`, `getAccessToken`, `saveRefreshToken`, `getRefreshToken`, `hasToken`, `clear`. This is the single source of truth for "is the user logged in" — checked in `SplashView` on app launch.
- **`InactivityService`** (`services/inactivity/inactivity_service.dart`) — a `GetxService` registered once in `main.dart`. `app.dart` wraps the whole app in a `Listener` that calls `registerInteraction()` on any touch, resetting a 5-minute timer. On timeout, it clears `TokenStorage` and redirects to `LoginView`.
  - `startWatching()` must be called after successful login and when `SplashView` finds a valid existing token.
  - `stopWatching()` must be called on manual logout.

## 6. Conventions

- **All folders and files are `snake_case`** — no exceptions, no PascalCase folder names. This isn't cosmetic: inconsistent casing causes import failures on case-sensitive build servers (CI/Linux) even if it works locally on Mac/Windows.
- **One `Dio` instance app-wide** (`ApiClient.dio`) — never instantiate Dio directly in a feature.
- **Debug-only tooling is always gated by `kDebugMode`**, never a hardcoded `true`/`false` — applies to the inspector and any future debug tooling.
- **Controllers never call a Service or Dio directly** — always go through that feature's Repository.
- **New feature checklist:**
  1. Create `features/<name>/` with `controllers/`, `repositories/`, `services/`, `models/`, `views/` (add `widgets/` if needed)
  2. `Model` — plain class + `fromJson`, matches the API response shape
  3. `Service` — raw calls via `ApiClient.dio`, returns parsed Models. Nothing else.
  4. `Repository` — abstract interface listing the methods the Controller needs, plus one `Impl` class forwarding to the Service
  5. `Controller` — takes the Repository interface as an optional constructor param (default to the real `Impl`), holds `.obs` state, calls the repository, never imports the Service
  6. Register the controller in `controller_binding.dart` if it needs to be injected
  7. `View` — reads from the Controller only, via `Obx()`/`GetX<T>`

  `auth` is the reference implementation of this shape — copy its structure for new features.

## 7. Open items / things to decide as the app grows

- **`core/routers/`** — currently unused; navigation is done via `Get.offAll(() => const SomeView())` with widget references. Either populate this with named routes (`AppRoutes` + `AppPages`) if deep linking or route guards become necessary, or remove the empty folder.
- **Refresh token flow** — `AuthInterceptor` currently logs the user out immediately on a 401. If the backend supports refresh tokens, this should be upgraded to attempt a silent refresh-and-retry once before forcing logout.
- **Base URL / environment config** — currently hardcoded in `api_client.dart`. Should move to environment-specific config before adding a staging/prod split.