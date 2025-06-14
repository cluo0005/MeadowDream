# 🌙 MeadowDream

MeadowDream is an iOS app that helps users record and reflect on dreams, with AI-powered interpretation and guidance features. Designed with mental wellness in mind, the app uses lucid dreaming as a core theme and leverages multi-agent AI development for rapid prototyping and iteration.

> 🏆 Built for the **Trae AI IDE: Zero Limits Hackathon | Lablab.ai** using [Trae AI IDE](https://trae.ai) and [Novita AI](https://novita.ai)

---

## 🚀 Features

- 📝 **Dream Recording** – Record dreams via text or voice input  
- 🌌 **Lucid Dream Tracking** – Tag lucid dreams and monitor patterns  
- 🧠 **AI Dream Interpretation** – Generate AI-powered insights on demand  
- 🎭 **Emotional Tagging** – Label dreams with mood, theme, or symbols  
- 📊 **Dream Statistics** – Visualize emotion trends and tag analysis  
- 📤 **Data Export** – Backup or move your dream archive securely  
- 🔐 **Privacy First** – All interpretations are opt-in and local-first  

---

## 🧱 Tech Stack

- **Frontend**: SwiftUI, UIKit  
- **AI Backend**: Novita AI model APIs  
- **State Management**: Swift Combine  
- **Backend/Storage**: Firebase (for auth + storage)  
- **Development Environment**: [Trae AI IDE](https://trae.ai)

---

## 🧠 AI Multi-Agent Development (via Trae)

We used Trae's multi-agent system to speed up development and decision-making:

- **🧭 Product Manager Agent**  
  - Drafted PRD, roadmap, and evaluation criteria  
  - Defined user stories and flows

- **🎨 UI/UX Designer Agent**  
  - Designed 33+ high-fidelity, interactive HTML prototypes  
  - Followed Apple HIG and structured UI flows

- **🛠️ Developer Agent**  
  - Integrated Novita AI model APIs  
  - Built Swift components with clean architecture  
  - Implemented responsive UI (UIKit + SwiftUI)  
  - Performed testing and debugging

These AI agents **augmented** our human effort — allowing rapid MVP iteration within 48-hour hackathon window.


---

## 📂 App Structure
```
MeadowDream/
├── MeadowDreamApp.swift
├── Views/
│   ├── MainTabView.swift
│   ├── OnboardingView.swift
│   ├── LoginView.swift
│   ├── SignupView.swift
│   ├── HomeView.swift
│   ├── DreamRecordingView.swift
│   ├── DreamListView.swift
│   ├── DreamDetailView.swift
│   ├── DreamSearchView.swift
│   ├── InterpretationView.swift
│   ├── InterpretationResultView.swift
│   ├── PositiveGuidanceView.swift
│   ├── FeedbackView.swift
│   ├── TagLibraryView.swift
│   ├── TagCreateView.swift
│   ├── TagEditView.swift
│   ├── StatsOverviewView.swift
│   ├── EmotionTrendsView.swift
│   ├── TagAnalysisView.swift
│   ├── SettingsView.swift
│   ├── NotificationSettingsView.swift
│   ├── AccountSettingsView.swift
│   └── LucidDreamGuideView.swift
├── Models/
│   └── Dream.swift
├── Resources/
│   └── Assets.xcassets
└── README.md
```

---

## 🛠️ Getting Started

### Prerequisites

- Xcode 14 or newer  
- iOS Simulator or device (iOS 16+)

### Installation

1. Clone the repo  
   ```bash
   git clone https://github.com/your-username/MeadowDream.git
   cd MeadowDream

---

## 📌 Notes

- All UI is built using **SwiftUI**
- Navigation and state logic are simplified for demo
- Extend each view with real data and logic as needed
- For the UI/UX experience without setup, view the live prototype:  
  👉 [https://cluo0005.github.io/MeadowDream/](https://cluo0005.github.io/MeadowDream/)

---

## 🙌 Why It Matters

Meadow Dream isn’t just about decoding dreams — it’s about using them to fuel personal growth.  
By combining lucid dream patterns with emotional self-reflection and AI-guided guidance, the app helps users uncover recurring thoughts, process emotions, and cultivate clarity.

---

## 📣 Acknowledgments

Built with ❤️ using:  
**Trae AI IDE** – for structured agent-based collaboration  
**Novita AI** – for LLM-driven dream interpretation  
as part of the **Zero Limits Hackathon | Lablab.ai**


## 📺 Optional: Video Demo

Coming soon — demo walkthrough of the app in action.

---

## 🧪 Try It via TestFlight

TestFlight beta coming soon — stay tuned!


