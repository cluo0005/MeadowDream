//
//  OnboardingView.swift
//  MeadowDream

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    let onboardingPages = [
        OnboardingPage(
            image: "book.fill",
            title: "Record Your Dreams",
            description: "Easily record each dream through text or voice, capturing fleeting dream details"
        ),
        OnboardingPage(
            image: "brain.head.profile",
            title: "AI Dream Interpretation",
            description: "Get multi-dimensional insights into your dreams through advanced AI technology, discovering emotions and thoughts in your subconscious"
        ),
        OnboardingPage(
            image: "leaf.fill",
            title: "Positive Guidance",
            description: "Get personalized positive psychological guidance, transforming emotions from your dreams into growth momentum for daily life"
        )
    ]
    
    var body: some View {
        ZStack {
            // Background color (Theme.background)
            Color(red: 248/255, green: 250/255, blue: 252/255)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Page Content Area
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingPages.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingPages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Navigation Container (120px height for navigation area)
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Bottom Navigation (matching HTML layout)
                    HStack {
                        // Skip Button (left)
                        Button("Skip") {
                            completeOnboarding()
                        }
                        .foregroundColor(Color(red: 107/255, green: 114/255, blue: 128/255)) // Theme.secondaryText
                        .font(.system(size: 17, weight: .regular))
                        .frame(width: 80, alignment: .leading)
                        
                        Spacer()
                        
                        // Page Control (center)
                        HStack(spacing: 8) {
                            ForEach(0..<onboardingPages.count, id: \.self) { index in
                                Circle()
                                    .fill(currentPage == index ? 
                                          Color(red: 0.357, green: 0.498, blue: 1.0) : // Theme.primary
                                          Color(red: 203/255, green: 213/255, blue: 224/255)) // #CBD5E0
                                    .frame(width: 8, height: 8)
                                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                            }
                        }
                        
                        Spacer()
                        
                        // Next/Get Started Button (right)
                        Button(currentPage == onboardingPages.count - 1 ? "Get Started" : "Next") {
                            if currentPage < onboardingPages.count - 1 {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    currentPage += 1
                                }
                            } else {
                                completeOnboarding()
                            }
                        }
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .semibold))
                        .frame(width: 80, height: 44)
                        .background(Color(red: 0.357, green: 0.498, blue: 1.0)) // Theme.primary
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(width: 80, alignment: .trailing)
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 50)
                    .padding(.bottom, 20)
                }
                .frame(height: 120)
            }
        }
    }
    
    private func completeOnboarding() {
        hasSeenOnboarding = true
    }
}

struct OnboardingPage {
    let image: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 0) {
            // Illustration Container (350px height like HTML)
            VStack {
                Spacer()
                
                // Illustration Circle (280x280 like HTML)
                ZStack {
                    // Background circle with shadow
                    Circle()
                        .fill(Color(red: 235/255, green: 244/255, blue: 255/255)) // #EBF4FF
                        .frame(width: 280, height: 280)
                        .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 10)
                    
                    // Icon (120px like HTML)
                    Image(systemName: page.image)
                        .font(.system(size: 120))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0)) // Theme.primary
                }
                
                Spacer()
            }
            .frame(height: 350)
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Content Container (40px spacing from illustration like HTML)
            VStack(spacing: 16) {
                // Title
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 17/255, green: 24/255, blue: 39/255)) // Theme.primaryText
                    .multilineTextAlignment(.center)
                
                // Description (16px spacing from title like HTML)
                Text(page.description)
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(Color(red: 107/255, green: 114/255, blue: 128/255)) // Theme.secondaryText
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .frame(maxWidth: 320) // Max width like HTML
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
} 