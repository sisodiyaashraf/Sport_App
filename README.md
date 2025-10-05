# Sport_App

A modern Flutter Sports Training App that helps users improve skills, track progress, and stay motivated through beautiful UI, animations, and personalized drills.

---

## Features

- **Skill Explorer:** Browse and learn sports skills with detailed images and levels.  
- **Interactive Drill Timer:** Start drills with customizable durations (15s, 30s, 45s, 60s).  
- **Progress Tracking:** Automatically marks drills as completed and stores progress locally.  
- **Global Theme Switch:** Instantly toggle between dark and light modes using `ThemeProvider`.  
- **Motivational UI:** Animated texts, smooth transitions, and Lottie success animations.  
- **Local Storage:** Saves user preferences and progress using `shared_preferences`.  
- **Responsive Design:** Looks great on phones, tablets, and desktops.  

---

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
