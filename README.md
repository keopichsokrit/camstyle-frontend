# camstyle_frontend
 A frontend project building a mobile app base on material desing from using flutter it`s an ecommerce app.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:
MVC strucutre:
``` bash
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart     <-- [THE ENGINE] Holds URLs + HTTP Logic (Get/Post/Auth)]
│   ├── routes/
│   │   └── app_routes.dart        <-- NEW: Centralized Route logic
│   ├── theme/
│   │   └── app_theme.dart         <-- NEW: ThemeData definitions
│   └── utils/
│       └── storage_helper.dart    # Manages JWT tokens
├── models/                       # Plain Data Objects (No logic)
│   ├── user_model.dart
│   ├── product_model.dart
│   ├── category_model.dart
│   └── cart_model.dart
├── controllers/                  <-- THE LOGIC (Calls Services)
│   ├── auth_controller.dart      # Handles login/role logic
│   ├── admin_controller.dart
│   ├── user_controller.dart
│   ├── payment_controller.dart
│   ├── category_controller.dart
│   ├── product_controller.dart   # Logic for sorting/filtering products
│   └── cart_controller.dart      # Logic for totals & payment triggers
├── views/                        <-- THE DESIGN (Calls Controllers)
│   ├── auth/
│   │   ├── login_screen.dart		# Login/Register UI
│   │   ├── register_screen.dart                     
│   │   └── start_screen.dart 
│   ├── admin/                    # Admin Dashboard/Edit UI
│   │   ├── new_product_screen.dart
│   │   ├── new_category_screen.dart
│   │   ├── update_product_screen.dart
│   │   ├── udpate_category_screen.dart
│   │   └── admin_dashboard.dart
│   ├── user/                     # User Home/Profile UI
│   │   ├── home_screen.dart 
│   │   ├── profile_screen.dart
│   │   └── product_detail_screen.dart 
│   ├── cart/                     # Cart/QR Code UI
│   │   ├── cart_screen.dart
│   │   └── payment_screen.dart
│   └── widget/                   # Reusable UI components (Buttons/Inputs)
└── main.dart                     # Application Entry

```
