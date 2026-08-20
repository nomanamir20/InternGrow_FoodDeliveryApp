# InternGrow — Food Delivery Application

> Task 3 of the InternGrow Mobile Development Internship.
> A complete food ordering app built in Flutter, using flutter_bloc, TheMealDB REST API,
> Firebase Auth, OpenStreetMap-based delivery maps, and simulated live order tracking.

🔗 **Live Demo (Web):** _coming soon_
📱 **Download APK:** _coming soon (see GitHub Releases)_

---

## ✨ Features

- [x] Restaurant Listing
- [x] Food Categories
- [x] Search
- [x] Product Details
- [x] Cart Management
- [ ] Delivery Address
- [ ] Order Tracking
- [ ] User Profile

### Upgrade Features
- [ ] Maps Integration (OpenStreetMap via flutter_map)
- [ ] Live Order Status
- [ ] Firebase Notifications
- [ ] Coupon System

---

## 🛠️ Tech Stack

| Category | Choice |
|---|---|
| Framework | Flutter (Dart) |
| State Management | flutter_bloc (Cubit) |
| Auth | Firebase Authentication |
| Food Data | TheMealDB REST API |
| Maps | flutter_map + OpenStreetMap |
| Location | geolocator |
| Push Notifications | Firebase Cloud Messaging |
| Navigation | go_router |

### A note on Maps

Google Maps Platform requires a billing-enabled Google Cloud account even for its free tier.
To keep this project genuinely free to build and run, delivery address selection uses
**OpenStreetMap** via `flutter_map` instead — same map/marker/location-picker UX, no API key
or billing required.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.3.0 or higher)
- A Firebase project

### Setup

1. Clone the repo
```bash
   git clone https://github.com/<your-username>/InternGrow_FoodDeliveryApp.git
   cd InternGrow_FoodDeliveryApp
```
2. Install dependencies
```bash
   flutter pub get
```
3. Connect Firebase (Auth + Cloud Messaging)
4. Run
```bash
   flutter run
```

---

## 📌 Status

🚧 In active development as part of the InternGrow Internship (Task 3 of 6).