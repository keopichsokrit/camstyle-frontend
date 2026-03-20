# camstyle_frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:
MVC strucutre:
``` bash
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart     <-- [THE ENGINE] Holds URLs + HTTP Logic (Get/Post/Auth)]
│   ├── routes/
│   │   └── app_routes.dart        <-- NEW: Centralized Route logic
│   ├── theme/
│   │   └── app_theme.dart         <-- NEW: ThemeData definitions
│   └── utils/
│       └── storage_helper.dart    # Manages JWT tokens
├── models/                       # Plain Data Objects (No logic)
│   ├── user_model.dart
│   ├── product_model.dart
│   └── cart_model.dart
├── controllers/                  <-- THE LOGIC (Calls Services)
│   ├── auth_controller.dart      # Handles login/role logic
│   ├── product_controller.dart   # Logic for sorting/filtering products
│   └── cart_controller.dart      # Logic for totals & payment triggers
├── views/                        <-- THE DESIGN (Calls Controllers)
│   ├── auth/                     # Login/Register UI
│   ├── admin/                    # Admin Dashboard/Edit UI
│   ├── user/                     # User Home/Profile UI
│   ├── cart/                     # Cart/QR Code UI
│   └── widget/                   # Reusable UI components (Buttons/Inputs)
└── main.dart                     # Application Entry
```
