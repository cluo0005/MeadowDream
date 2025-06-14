# Meadow Dream (SwiftUI)

A high-fidelity iOS app for dream recording, AI interpretation, and positive guidance, based on the Meadow Dream PRD and UI prototypes.

## Features
- Onboarding & Login
- Home (Dream List, Empty State)
- Dream Recording (Text/Voice, Emotion/Tag selection)
- Dream Detail & Search
- AI Dream Interpretation & Positive Guidance
- Tag Management (Library, Create, Edit)
- Statistics (Overview, Emotion Trends, Tag Analysis)
- Settings (Notifications, Account, Lucid Dream Guide)

## Folder Structure
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
│   └── (Assets.xcassets, etc.)
├── Package.swift (or .xcodeproj)
└── README.md
```

## Getting Started
1. Open in Xcode 14+
2. Build & run on iOS 16+ simulator or device
3. Explore the app via the main tabs

## Notes
- All UI is built with SwiftUI
- Navigation and state are simplified for demo
- Extend each View with real data and logic as needed
