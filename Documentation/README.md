# CelestialGuide App

CelestialGuide is an iOS app that visualizes the relative positions of the Sun, Moon, and Earth (the user’s location) in real time. It’s designed to help you “find” the Sun and Moon by guiding you with on-screen arrows, and it provides basic astronomical data such as distance from Earth and lunar phase.

---

## Features

- **Real-Time Orientation**: Uses CoreLocation and CoreMotion to show where the Sun and Moon are located relative to your position.  
- **2D Sky View**: Minimalist interface displaying arrows for the Sun and Moon.  
- **Tap for Details**: Tapping an arrow reveals distance from Earth and other basic info.  
- **Lunar Phases**: Dynamically displays the current lunar phase (waxing, waning, full, new, etc.).  
- **Angular Separation**: (Planned) Option to visualize angular separation between the Sun and Moon.

---

## Requirements

- **iOS** 15.0 or later (recommended).  
- **Xcode** 14.0 or later.  
- **Swift** 5.0 or later.  
- **SwiftUI** for the UI.  
- **SwiftAA** (optional library) for advanced astronomical calculations.

---

## Installation

1. **Clone or Download** this repository to your local machine:

git clone [https://github.com/YOUR\_USERNAME/CelestialGuide.git](https://github.com/YOUR_USERNAME/CelestialGuide.git)

2. **Open the Project** in Xcode:  
   1. Double-click CelestialGuide.xcodeproj.  
3. **Install Dependencies** (if any):  
   1. If using SwiftAA or other Swift Packages, Xcode will prompt you to resolve dependencies automatically.  
4. **Select Your Device** or Simulator and press **Run** (the ▶︎ button).

---

**Usage**

	1\.	**Launch the App** on your iPhone (or simulator).

	2\.	**Grant Permissions**:

Allow location access so the app can compute Sun/Moon positions accurately.

Optionally, allow motion/compass access for real-time orientation tracking.

	3\.	**Point Your Phone** around to see arrows guiding you to the Sun and Moon.

	4\.	**Tap an Arrow** to see details like distance from Earth, current lunar phase, and more.

---

**Project Structure**

* **CelestialGuide/**  
  Main source code and SwiftUI views.  
* **CelestialGuideTests/**  
  Unit tests for the app’s logic.  
* **CelestialGuideUITests/**

UI tests for automated interface testing.

* **Documentation/**

Contains this README and any additional docs or design notes.

---

**Roadmap**

* **AR View**: Potentially add ARKit support for an augmented reality experience.  
* **Detailed Astronomy Data**: Expand SwiftAA usage to include sunrise/sunset times, more precise Moon phases, etc.  
* **Localization**: Support multiple languages.  
* **Custom Notifications**: Alert users about significant celestial events (full moon, eclipses, etc.).

---

**Contributing**

	1\.	**Fork** the project on GitHub.

	2\.	**Create a Feature Branch**:

`git checkout -b feature/YourFeature`

3\. **Commit Your Changes**:

`git commit -m 'Add a cool feature'`

4\. **Push to the branch**

`git push origin feature/YourFeature`

**5\.  Open a Pull Request on Github**

---

**License**

**MIT License** – Feel free to modify and use this project as you wish. See the LICENSE file for details.

---

**Contact**

	**•	Author: Your Name (or GitHub handle)**

	**•	Email: youremail@example.com**

	**•	Website: [https://www.sjtracey.com](https://www.sjtracey.com) (if applicable)**
