# InternGrow — Food Delivery Application

> Task 3 of the InternGrow Mobile Development Internship.
> A complete food ordering app built in Flutter, using flutter_bloc, TheMealDB REST API,
> Firebase Auth, Firebase Cloud Messaging, and OpenStreetMap-based delivery address selection.

🔗 **Live Demo (Web):** [interngrow-fooddelivery-app.vercel.app](https://interngrow-fooddelivery-app.vercel.app)
📱 **Download APK:** [Latest Release (v1.0.0)](https://github.com/nomanamir20/InternGrow_FoodDeliveryApp/releases/download/v1.0.0/app-release.apk)

---

## ✨ Features

- [x] Restaurant Listing — mock restaurants, each backed by a real TheMealDB category menu
- [x] Food Categories — browse all TheMealDB categories, filter meals by category
- [x] Search — debounced live search against TheMealDB
- [x] Product Details — full meal detail: real ingredients, measurements, and preparation steps
- [x] Cart Management — quantity controls, persisted locally
- [x] Delivery Address — interactive map picker with "use my location"
- [x] Order Tracking — live-progressing status timeline (Placed → Preparing → Out for Delivery → Delivered)
- [x] User Profile — account info, order stats, dark mode, logout

### Upgrade Features
- [x] Maps Integration — OpenStreetMap via `flutter_map`, free and API-key-free
- [x] Live Order Status — orders automatically advance through delivery stages in real time
- [x] Firebase Notifications — Cloud Messaging with in-app banner (foreground) and native OS notifications (background)
- [x] Coupon System — real discount code validation with percentage/fixed discounts and minimum-order rules

---

## 🛠️ Tech Stack

| Category | Choice |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc (Cubit) |
| Auth | Firebase Authentication |
| Food Data | [TheMealDB](https://www.themealdb.com) REST API |
| Maps | flutter_map + OpenStreetMap |
| Location | geolocator |
| Push Notifications | Firebase Cloud Messaging |
| Navigation | go_router (with a `StatefulShellRoute` bottom-tab shell) |
| HTTP Client | dio |
| Local Storage | shared_preferences (cart, addresses, order history, theme) |

### A note on Maps

Google Maps Platform requires a billing-enabled Google Cloud account, even for its free tier.
To keep this project genuinely free to build and run, delivery address selection uses
**OpenStreetMap** via `flutter_map` instead — same interactive map, marker placement, and
"use my current location" UX, with zero API key or billing requirement.

### A note on restaurant data

TheMealDB is a recipe API with no restaurant concept, so restaurants are modeled locally —
each one maps to a real TheMealDB category, and its "menu" is that category's real meals,
fetched live from the API. Prices are deterministically derived per meal ID since TheMealDB
has no pricing data.

---

## 📂 Project Structure

lib/
├── core/
│ ├── theme/ # Colors, ThemeData, ThemeCubit
│ ├── router/ # go_router config with shell-route bottom nav
│ ├── services/ # AuthService, MealApiService, LocationService, NotificationService
│ └── utils/ # Validators
├── features/
│ ├── auth/ # Login, Sign Up, AuthCubit
│ ├── home/ # Restaurant listing, restaurant menu, mock data
│ ├── categories/
│ ├── search/
│ ├── product/ # Meal model, product details
│ ├── cart/ # Cart model, CartCubit, cart screen
│ ├── address/ # Delivery address model, map picker
│ ├── orders/ # Order model, OrdersCubit, tracking + history
│ ├── coupons/ # Coupon model, CouponCubit
│ ├── profile/
│ └── notifications/ # NotificationBannerCubit
└── shared/
└── widgets/ # Reusable widgets, splash screen, nav shell


---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.3.0 or higher)
- A Firebase project (free Spark tier is enough)

### Setup

1. Clone the repo
```bash
   git clone https://github.com/nomanamir20/InternGrow_FoodDeliveryApp.git
   cd InternGrow_FoodDeliveryApp
```
2. Install dependencies
```bash
   flutter pub get
```
3. Connect Firebase — enable Email/Password Authentication and Cloud Messaging, then add your own `firebase_options.dart`
4. For push notifications on web, add your own Firebase config to `web/firebase-messaging-sw.js` and generate a Web Push certificate (VAPID key) under Project Settings → Cloud Messaging
5. Run
```bash
   flutter run
```

---

## 🧪 Building for Release

**Android APK:**
```bash
flutter build apk --release
```
(requires your own signing configuration)

**Web:**
```bash
flutter build web --release
```

---

## 📌 Status

✅ Complete — all 8 core features and all 4 upgrade features implemented and tested on both Web and Android.

---

## 👤 Author

Built by Noman Amir as part of the InternGrow Mobile Development Internship.