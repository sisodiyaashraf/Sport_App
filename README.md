# Sport_App

A modern Flutter Sports Training App that helps users improve skills, track progress, and stay motivated through beautiful UI, animations, and personalized drills — powered by **MockAPI** for dynamic data management.

---

## Overview

Sport_App is designed to enhance athletic performance by allowing users to explore skills, start drills with custom timers, and monitor progress — all in one place.  
It features elegant UI, dark/light themes, animations, and remote data integration using **MockAPI.io**.

---

## Features

- **Dynamic Skill Data (via MockAPI):**  
  Fetches real-time sports skill data (name, level, image, and description) from a MockAPI REST endpoint.

- **Interactive Drill Timer:**  
  A modern circular timer for training drills with selectable durations (15s, 30s, 45s, 60s).

- **Progress Tracking:**  
  Automatically marks drills as completed and stores progress locally using `shared_preferences`.

- **Global Theme Switch:**  
  Toggle between light and dark mode — applies across all pages using `ThemeProvider`.

- **Motivational Design:**  
  Animated texts, gradient themes, and smooth transitions for a professional training experience.

- **Lottie Animations:**  
  Success animations when completing drills.

- **Responsive UI:**  
  Adaptive layout that scales beautifully across devices.

---

## MockAPI Integration

The app uses **[MockAPI.io](https://mockapi.io/)** as a lightweight backend to manage and serve dynamic skill data.

### Example MockAPI Endpoint
```bash
https://your-mockapi-url.mockapi.io/api/v1/skills


## Folder Structure

lib/
│
├── main.dart # Entry point
│
├── models/
│ └── skills.dart # Skill data model
│
├── provider/
│ └── theme_provider.dart # Theme management (light/dark)
│
├── screens/
│ ├── drill_screen.dart # Timer + drill functionality
│ ├── profile_screen.dart # User profile page
│ ├── progress_screen.dart # Skill progress tracker
│ ├── skill_detail_screen.dart # Skill details with drill start
│ └── skills_screen.dart # Skill list screen
│
├── widgets/
│ ├── bottom_navbar.dart # Custom bottom navigation bar
│ └── skill_card.dart # Reusable skill display widget
│
├── assets/
│ ├── images/ # App images
│ └── animations/ # Lottie files
│
└── pubspec.yaml # Dependencies & assets


---

## Tech Stack

| Category | Tools / Packages |
|-----------|------------------|
| Framework | Flutter (Dart) |
| State Management | Provider |
| Local Storage | Shared Preferences |
| Network  | HTTP (MockAPI integration) |
| Animations | Lottie, Animated Text Kit |
| UI Enhancements | Google Fonts, Sleek Circular Slider, Shimmer |
| Design | Material 3, Gradient Themes |

---

Developer

Mohd Ashraf
Email: sisodiyaashraf@gmail.com

GitHub: https://github.com/sisodiyaashraf

"Train Hard • Play Smart • Stay Consistent"

License

This project is licensed under the MIT License — feel free to use, modify, and learn from it.
