# Victorious MARKET AI Development Rules

Welcome to the Victorious MARKET ecosystem! This file enforces strict rules and patterns that **ALL AIs** must adhere to when working on this repository.

## 1. Golden Rule: Read Before Writing
Before making ANY changes to this codebase, you MUST:
- Analyze the existing structure.
- Understand how your requested change integrates with the existing architecture.
- Do NOT introduce new architectural patterns (e.g., do not install Redux if the app uses Provider, do not use raw SQL if the backend uses Eloquent Repositories).
- You must always read `AI_CHANGELOG.md` in the root directory to understand recent modifications made by other AIs.

## 2. Mandatory Change Logging
Any time you make a functional change, fix a bug, or complete a feature, you **MUST** document it in `AI_CHANGELOG.md` located in the root of the workspace. This ensures all AIs remain synchronized on the project's state.

## 3. Strict Architectural Patterns

### A. The Laravel Backend (`backend/Admin and web new install V16.1`)
- **Queries:** Avoid N+1 queries at all costs. You MUST use Eager Loading (`->with()`) inside the `app/Repositories` classes.
- **Caching:** The storefront relies heavily on caching. If you add a new configuration or storefront setting, you must cache it using `Cache::remember()` in the `app/Utils/settings.php` file or equivalent utility.
- **Data Integrity:** All Eloquent Models must explicitly define a `$fillable` or `$guarded` array to prevent Mass Assignment.

### B. User App & Vendor App (Flutter)
- **State Management:** These apps use **Provider**. Do NOT introduce GetX, BLoC, or Riverpod.
- **Dependency Injection:** All services and providers must be registered using **GetIt** in `lib/di_container.dart`.
- **Security:** API tokens must ONLY be stored using `flutter_secure_storage`. Do not use `shared_preferences` for sensitive keys.
- **Architecture:** Follow the Feature-First directory structure (`lib/features/{feature_name}`).

### C. Delivery Man App (Flutter)
- **State Management:** This specific app uses **GetX** for state and routing. Do NOT use Provider here.
- **Security Notice:** If modifying token storage, upgrade it from `shared_preferences` to `flutter_secure_storage` to match the enterprise standards of the other apps.
- **Performance:** When dealing with maps and geolocation, ensure UI repaints are minimized via GetX reactive variables (`.obs`).

## 4. UI / UX Standards
- The platform uses a specific color scheme (Purple & Gold). Use the predefined theme colors.
- Maintain smooth 60fps performance on mobile apps. Use `cached_network_image` for all network images.
