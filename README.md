# Victorious MARKET

Victorious MARKET is a robust, high-performance, and secure multi-vendor e-commerce platform designed and optimized for local trade in Uyo, Nigeria. It provides a complete end-to-end ecosystem for customers to shop, vendors to sell, and delivery riders to fulfill orders.

The platform architecture is divided into a **Laravel 10 / PHP 8** web backend and three distinct native **Flutter** mobile applications.

---

## 🏗️ Ecosystem Architecture

*   **`backend/` (Laravel Web Application):**
    *   Serves as the central API gateway for all mobile apps.
    *   Contains the Super Admin dashboard for total platform control.
    *   Contains the Vendor dashboard for store owners to manage products, inventory, and payouts.
    *   Includes full storefront web layouts (Default Theme & Aster Theme) for desktop/mobile browser shoppers.
*   **`User app/` (Flutter):**
    *   The primary mobile shopping experience for Android & iOS.
    *   Features intuitive product browsing, cart management, secure checkout, and live order tracking.
*   **`Vendor app/` (Flutter):**
    *   The mobile command center for store owners.
    *   Enables vendors to add/edit products, track daily revenue, chat with delivery men, and process incoming orders on the go.
*   **`Delivery Man App/` (Flutter):**
    *   The dispatch rider application.
    *   Allows delivery personnel to accept delivery requests, view map routing, and securely verify successful handoffs using OTPs.

---

## 🚀 Deployment & Installation Guide

### 1. Web & Backend Installation (cPanel / Linux VPS)
The backend requires a server running **PHP 8.1+** and **MySQL**.
1. Compress the contents inside the `backend/` folder into a ZIP file.
2. Upload and extract the ZIP file into your `public_html` directory (e.g., `/public_html/shop.victoriousmarket.com.ng`).
3. Create a MySQL database and user, and link them together in your control panel.
4. Open your domain (e.g., `https://shop.victoriousmarket.com.ng`) in a web browser. You will be greeted by the automated installation wizard.
5. Follow the wizard. *Note:* The activation class is locally bypassed for development; you may enter any 36-character purchase key (e.g., `12345678-abcd-1234-abcd-1234567890ab`) to complete the setup.

### 2. Third-Party Integrations
Once the admin panel is live, navigate to **3rd Party Setup** to configure essential services:
*   **Payment Gateways:** Configure Paystack and Flutterwave under *Payment Methods* using your live API keys to accept Naira payments. Ensure you also add bank details under *Offline Payment Methods*.
*   **Push Notifications (Firebase):** Download your Firebase Service Account `.json` key from the Firebase Console and upload it under *Firebase Configuration* to enable cross-platform push notifications.
*   **Google Sign-In:** Register your application in the Google Cloud Console, and input your Client ID and Secret under *Social Login* to enable 1-tap authentication.

---

## 🛠️ Compiling the Mobile Apps

The Flutter applications require the **Flutter SDK**, **Android Studio**, and **Xcode** (for iOS).

### Automated Cloud Builds (GitHub Actions)
For ease of deployment, this repository is configured with automated GitHub Actions CI/CD pipelines. Every push to the `master` branch will automatically compile the apps on GitHub's cloud servers, outputting:
1.  **APK files (`.apk`)**: For manual Android testing and distribution.
2.  **App Bundles (`.aab`)**: The optimized binary required for submission to the Google Play Store.

### Local Compilation (Android)
If you wish to compile the apps manually on your local machine:
```bash
# Navigate to the app directory
cd "User app"

# Fetch dependencies
flutter pub get

# Build the release APK
flutter build apk --release
```
*Note: Ensure your machine has at least 16GB of RAM. If you encounter `java.lang.OutOfMemoryError` during Gradle tasks, increase your JVM heap size in your `gradle.properties` file: `org.gradle.jvmargs=-Xmx4096m`.*

---

## 🛡️ Security & Performance Standards

This ecosystem has undergone rigorous performance and security auditing to ensure enterprise-grade stability:

### Security Hardening
1.  **Mass Assignment Protection:** Eloquent models strictly define `$guarded` or `$fillable` arrays to prevent malicious payload injection.
2.  **Strict Chat Policies:** Direct vendor-to-customer communication is hard-disabled at the UI and Controller levels to prevent off-platform transactions and spam, ensuring all disputes are handled centrally.
3.  **SQL Injection Prevention:** All database queries utilize Laravel's query builder and PDO parameter binding to sanitize user inputs.
4.  **Code Obfuscation:** The Flutter applications are compiled to native ARM machine code, making reverse engineering highly complex.

### Performance Optimizations
1.  **N+1 Query Elimination:** Critical bottlenecks, such as the checkout API (`OrderManager`), utilize highly optimized bulk eager-loading. This drastically reduces database latency under high traffic.
2.  **Robust JSON Deserialization:** The Flutter data models use defensive typing (`is Map`) to gracefully handle unexpected nulls or empty arrays from the API, permanently eliminating blank-screen crashes.
3.  **Static Analysis:** The Dart codebases have been scrubbed of dead code, unused variables, and deprecated widgets to ensure minimal compiled binary sizes and fast startup times.
