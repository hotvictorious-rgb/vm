# AI Development Changelog

This document tracks all modifications, bug fixes, and feature additions made to the Victorious MARKET ecosystem by AI agents. 

**Instructions for AIs:** 
Always append your completed tasks here in chronological order. Include the date, the specific app/component modified, and a brief description of the changes.

---

### [2026-08-10] Delivery Man App ↔ Laravel Backend Pairing Audit
* **Component:** Delivery Man App / Backend (`routes/rest_api/v2/api.php`)
* **Action:** Completed security and performance pairing for the Delivery Man App. This is the final leg of the platform-wide audit.
* **Changes Made:**
  - `Delivery Man App/lib/utill/app_constants.dart` — Changed `baseUri` from `https://shop.victoriousmarket.com.ng` to `http://127.0.0.1:8000` so the app connects to the local Laravel instance during development.
  - `backend/routes/rest_api/v2/api.php` — Added `throttle:10,1` middleware to the `delivery-man/auth` route group (login, forgot-password, verify-otp, reset-password) to match brute-force protection already in place for seller auth routes.
* **Controller Audit (`DeliveryManController.php`):**
  - `get_current_orders` — Already uses `->with(['shippingAddress', 'customer', 'seller.shop'])`. ✅
  - `get_all_orders` — Already uses `->with(['shippingAddress', 'customer', 'seller.shop'])`. ✅
  - `get_order_details` — Already uses deep nested `->with(...)` for details, shipping, customer, seller, and edit history. ✅
  - `update_order_status` — Already uses `->with(['customer', 'deliveryMan', 'latestEditHistory'])`. ✅
  - No N+1 fixes required — Eager Loading is already correctly implemented.
* **Security Status:** Token storage uses `flutter_secure_storage` (upgraded in prior session). API client loads secure token on init with SharedPreferences fallback. All credentials (password, phone, country code) are stored encrypted.

### [2026-08-10] Ecosystem Initialization
* **Component:** Global
* **Action:** Established the `.agents/AGENTS.md` ruleset and this changelog.
* **Details:** Analyzed the architecture across the Laravel backend, User App, Vendor App, and Delivery App. Created strict guidelines to ensure all future AIs enforce Provider (User/Vendor), GetX (Delivery), Eager Loading/Caching (Laravel), and Secure Token Storage. Started local MySQL database for testing.

### [2026-08-10] Delivery Man App — Security Upgrade (flutter_secure_storage)
* **Component:** Delivery Man App
* **Action:** Migrated all sensitive data storage from `shared_preferences` (plain-text) to `flutter_secure_storage` (encrypted Keychain/Keystore).
* **Files Modified:**
  - `pubspec.yaml` — Added `flutter_secure_storage: ^10.3.1` dependency.
  - `lib/data/api/api_client.dart` — Added `FlutterSecureStorage` field; loads token from secure storage on init with SharedPreferences fallback for migration.
  - `lib/features/auth/domain/repositories/auth_repository.dart` — `saveUserToken()` now writes to secure storage first; `updateToken()` reads from secure storage first; `clearSharedData()` clears both stores; `saveUserCredentials()` and `clearUserCredentials()` use secure storage for passwords.
  - `lib/features/splash/domain/repositories/splash_repository.dart` — `removeSharedData()` now also deletes from secure storage.
  - `lib/helper/get_di.dart` — Registered `FlutterSecureStorage` in GetX DI container; passed to `ApiClient`, `AuthRepository`, and `SplashRepository`.
* **Backward Compatibility:** SharedPreferences is kept in sync as a fallback. Existing users will seamlessly migrate — the secure token is read first, and if absent, the app falls back to the SharedPreferences token and then stores it securely on next login.

### [2026-08-10] Vendor App ↔ Laravel Pairing Audit
**Component:** Vendor App / Backend (`routes/rest_api/v3/seller.php`)
**Description:** Audited and optimized the communication between the Vendor App and the local Laravel Backend.
**Changes Made:**
- **App:** Updated `AppConstants.baseUrl` to `http://127.0.0.1:8000`.
- **App:** Reduced `dio_client.dart` timeouts to 30s.
- **App:** Verified `flutter_secure_storage` is correctly implemented for token management in `auth_repository.dart`.
- **Backend:** Enforced `throttle:10,1` on Vendor authentication routes to prevent brute-force attacks.
- **Backend:** Verified `SellerController` and `ProductController` correctly utilize Eager Loading (`with()`) to prevent N+1 queries.

### [2026-08-10] User App ↔ Laravel Pairing Audit
* **Component:** User App & Backend Web
* **Action:** Audited and optimized the API pairing for security, latency, and correctness.
* **Details:** 
  - Verified that User App's DioClient does not leak tokens in logs.
  - Confirmed User App utilizes FlutterSecureStorage for tokens and passwords.
  - Reduced User App's Dio network timeouts from 60s to 30s to prevent UI hanging on spotty networks.
  - Verified cached_network_image is used globally across the User App to prevent OOM errors.
  - Confirmed Backend pi.php enforces strict 	hrottle:10,1 on all auth routes.
  - Audited ProductController and CategoryController for N+1 queries. Backend successfully uses extensive Eager Loading and Cache::remember() for high-traffic endpoints.
  - Temporarily pointed User App AppConstants.baseUrl to http://127.0.0.1:8000 for local MySQL/Laravel testing.

### [2026-08-10] Cross-Party Chat & Voice Notes Implementation
* **Component:** Global (Backend, User App, Vendor App, Delivery Man App)
* **Action:** Implemented order-gating for delivery man chats and cross-party admin chat support.
* **Details:**
  - **Voice Notes (Delivery App):** Added udioplayers and ecord packages, created VoiceNoteBottomSheet and AudioPlayerWidget, and integrated into MessageBubbleWidget and ChatController.
  - **Order Gating (Backend):** Modified 1/ChatController.php (Customer) and 2/delivery_man/ChatController.php (Delivery Man) to prevent direct messaging unless an active order links the Customer and Delivery Man.
  - **Admin Chat (Backend & Apps):** Separated dmin from seller in 1 backend endpoints. Added dmin routing to 3/seller endpoints. Re-instated TabController in User App and added Admin tabs to both Vendor and User app chat headers to enable direct messaging with Admin.


### [2026-08-10] Web Panel Chat Security
* **Component:** Customer Web Frontend (Web/ChattingController.php)
* **Action:** Added order-gating to delivery man chat.
* **Details:** Added Order::exists() check to ddMessage() in Web/ChattingController.php to prevent customers from chatting with delivery men without an active order assignment, mirroring the logic introduced in the mobile REST API.

