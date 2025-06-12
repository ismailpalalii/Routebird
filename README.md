# Routebird 🐦

A minimalist and playful iOS app for route tracking – built as a Martı case study with UIKit, SnapKit, and MVVM architecture. Routebird places a bird marker every 100 meters you travel, lets you track, reset, and review your path, and provides a smooth, modern UI.

---

## 🚀 Features

### **Must-Haves**
- **Live Location Tracking:**  
  The app follows the user’s location using CoreLocation.
- **Marker Placement:**  
  A new marker is placed on the map every 100 meters traveled.
- **Pause/Resume & Reset Route:**  
  Users can start, stop (pause/resume), and reset route tracking with easy buttons.
- **Map Centering:**  
  The map auto-centers on the user at start, and can be re-centered any time.
- **Address Details:**  
  Tapping a marker shows its address (reverse geocoding).
- **Background Mode:**  
  The app keeps tracking in the background if permissions are granted.
- **Persistent Route:**  
  Markers are saved and restored when the app restarts.

---

### **Nice-to-Haves & Enhancements**
- **Custom Marker Icon:**  
  Cute bird icon markers, visually consistent with the Routebird brand.
- **Marker Titles:**  
  Markers display as "Checkpoint (HH:mm, lat/lon)" for clarity.
- **Dynamic Speed Indicator:**  
  Shows current and average speed in km/h when tracking is active.
- **Reset Confirmation:**  
  Resets route only after confirmation, then shows a toast message ("Route cleared!").
- **Permission Alerts:**  
  If location permission is missing/denied, users get a clear alert before tracking starts.
- **Locate Button:**  
  A floating “target” button (bottom right) to instantly center the map on your location.
- **Launch Screen:**  
  Branded splash with bird logo and Routebird name for a smooth launch experience.
- **Unit Tests:**  
  Basic unit tests for MapViewModel and LocationService logic (can be extended).
- **Minimal, Touch-Friendly UI:**  
  SnapKit-powered responsive layout, big touch targets, native UIKit feel.

---

## 🛠️ Tech Stack

- UIKit & SnapKit (no Storyboards except LaunchScreen)
- MVVM Architecture
- CoreLocation & MapKit
- Codable, UserDefaults for persistence
- Custom annotations and views
- Unit Testing (XCTest)

---

## 📱 How to Run

1. **Clone the repo**  
   `git clone ...`
2. **Install dependencies**  
   (SnapKit via SPM or CocoaPods if needed)
3. **Open in Xcode**  
   Xcode 15+ recommended
4. **Set Deployment Target**  
   iOS 16.0+
5. **Add Bird Asset**  
   (See /Assets)
6. **Run on Simulator or Device**  
   Enable location in simulator; try “City Run” or “Apple” for route simulation!

---

## 🖼️ Screenshots & Video
<img src="https://github.com/user-attachments/assets/17fedc28-2544-4a50-9754-8045321bf92f" width="100">
<img src="https://github.com/user-attachments/assets/84ca8a90-9bf5-45b1-8c94-298843496ede" width="100">
<img src="https://github.com/user-attachments/assets/f622521a-882f-400e-93ab-69817eae3a16" width="100">
<img src="https://github.com/user-attachments/assets/03d68a6d-6bd4-4569-90cd-aa1ff1ba7de0" width="100">
<img src="https://github.com/user-attachments/assets/72f752a9-03b9-4790-965d-8b0f9331ac9f" width="100">
<img src="https://github.com/user-attachments/assets/0ce193d6-8d3f-4637-8e7c-6d57f08fe2dd" width="100">

---

## 👨‍💻 Development Approach

1. **Task Breakdown:**  
   Every requirement is split into an atomic task (with a clear Task ID, e.g. RB-1002).
2. **Feature Branching:**  
   New branches are created for each task under `feature/`, e.g. `feature/RB-1004-ui-ux-enhancements`.
3. **Atomic, Isolated PRs:**  
   Each feature branch is developed, reviewed, and tested separately.  
   When complete, a **pull request (PR)** is opened and merged into `development`.
4. **Strict Separation of Concerns:**  
   UI and business logic are separated (UIKit + MVVM).  
   Service, model, and UI layers do not mix.
5. **Continuous Integration:**  
   Each PR includes necessary unit tests and documentation if needed.
6. **Permissions & Background Modes:**  
   All required permissions and capabilities are included with each relevant feature branch.
7. **Code Quality:**  
   Code is thoroughly commented, modular, and readable.  
   Consistent naming conventions and best practices are followed.

## 📋 Must-Have List

- [x] Live location tracking (foreground & background)
- [x] Marker every 100 meters
- [x] Pause/resume & reset controls
- [x] Address on marker tap
- [x] User permission/alerts
- [x] Persistent route

---

## ✨ Additional Improvements

- [x] Custom brand icon for markers
- [x] Speed/average speed display
- [x] User-friendly reset flow
- [x] Toast & alert messages
- [x] Locate button (like Martı/Uber)
- [x] Branded launch screen
- [x] Basic unit tests

---

## 📢 Notes

- **No third-party analytics or tracking.**
- **No sensitive data stored.**
- For demonstration purposes – contact [ismail.palali.pp@gmail.com] for feedback!

---

> *Built for Martı iOS case by İsmail Palalı, June 2025.*
