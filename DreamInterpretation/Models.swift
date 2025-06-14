//
//  Models.swift
//  DreamInterpretation
//
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseAuth

// MARK: - AI Service

class AIService: ObservableObject {
    private let apiKey = "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"
    private let baseURL = "https://openrouter.ai/api/v1/chat/completions"
    
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    func interpretDream(_ dreamText: String) async -> String {
        print("🤖 Starting AI interpretation for dream text: \(dreamText.prefix(50))...")
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        // Step 1: Generate prompt that combines with user input
        let prompt = """
        You are an expert dream interpreter with deep knowledge of psychology, symbolism, and dream analysis. You combine insights from Jungian psychology, Freudian analysis, and modern dream research to provide meaningful interpretations.

        **DREAM TO INTERPRET:**
        \(dreamText)

        **INSTRUCTIONS:**
        Provide a comprehensive dream interpretation using the following structured format. Be empathetic, insightful, and avoid overly technical jargon. Focus on practical insights the dreamer can apply to their life.

        **RESPONSE FORMAT:**

        ## 🔍 **Dream Overview**
        Provide a brief 2-3 sentence summary of the dream's main narrative and emotional tone.

        ## 🎭 **Key Symbols & Meanings**
        Identify and explain 3-5 most significant symbols, objects, or characters:
        • **[Symbol Name]**: Explanation of meaning and significance
        • **[Symbol Name]**: Explanation of meaning and significance

        ## 💭 **Emotional Landscape**
        Analyze the emotions present in the dream:
        • Primary emotions experienced
        • What these emotions might represent in waking life
        • Any emotional conflicts or resolutions

        ## 🌉 **Connections to Waking Life**
        Explore possible links to the dreamer's current life situation:
        • Recent events or concerns that might have influenced the dream
        • Relationships or situations reflected in the dream
        • Subconscious processing of daily experiences

        ## 🌱 **Personal Growth Insights**
        Offer meaningful guidance for personal development:
        • What the dream might be trying to tell you
        • Areas of life to pay attention to
        • Positive actions or mindset shifts to consider

        ## 💡 **Key Takeaway**
        Conclude with one powerful, memorable insight or message from the dream.

        **TONE:** Be warm, understanding, and non-judgmental. Speak as if you're a wise, caring friend offering insights. Use "you" to address the dreamer directly and make it personal.
        """
        
        let requestBody: [String: Any] = [
            "model": "openai/gpt-3.5-turbo",
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": 1000,
            "temperature": 0.7
        ]
        
        do {
            guard let url = URL(string: baseURL) else {
                print("❌ Invalid API URL: \(baseURL)")
                await MainActor.run {
                    self.errorMessage = "Invalid API URL"
                    self.isLoading = false
                }
                return "Unable to connect to AI service."
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Dream-Interpretation-App", forHTTPHeaderField: "HTTP-Referer")
            
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
            request.httpBody = jsonData
            
            print("🌐 Making API request to: \(baseURL)")
            print("🔑 Using API key: \(apiKey.prefix(20))...")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 {
                    print("❌ Non-200 status code: \(httpResponse.statusCode)")
                    
                    // Print response data for debugging
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("🔍 API Response: \(responseString)")
                    }
                }
            }
            
            // Parse the response
            guard let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("❌ Failed to parse JSON response")
                await MainActor.run {
                    self.errorMessage = "Invalid JSON response from API"
                    self.isLoading = false
                }
                return "Unable to interpret dream at this time. Please try again."
            }
            
            print("✅ Received JSON response: \(jsonResponse.keys)")
            
            // Check for API error first
            if let error = jsonResponse["error"] as? [String: Any] {
                let errorMessage = error["message"] as? String ?? "Unknown API error"
                let errorCode = error["code"] as? String ?? "unknown"
                print("❌ API Error - Code: \(errorCode), Message: \(errorMessage)")
                
                await MainActor.run {
                    self.errorMessage = "API Error: \(errorMessage)"
                    self.isLoading = false
                }
                return "Unable to interpret dream at this time. Please try again."
            }
            
            // Parse successful response
            if let choices = jsonResponse["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                print("✅ Successfully received AI interpretation")
                
                await MainActor.run {
                    self.isLoading = false
                }
                return content.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                print("❌ Failed to parse choices/message/content from response")
                print("🔍 Response structure: \(jsonResponse)")
                
                await MainActor.run {
                    self.errorMessage = "Failed to parse AI response"
                    self.isLoading = false
                }
                return "Unable to interpret dream at this time. Please try again."
            }
            
        } catch {
            print("❌ Network/Request error: \(error.localizedDescription)")
            
            await MainActor.run {
                self.errorMessage = "Network error: \(error.localizedDescription)"
                self.isLoading = false
            }
            return "Unable to connect to AI service. Please check your internet connection."
        }
    }
}

// MARK: - Data Models

struct DreamEntry: Identifiable, Codable {
    @DocumentID var id: String?
    let title: String
    let dreamText: String
    let interpretation: String
    let date: Date
    let mood: String
    let userId: String
    
    // Computed property to check if this is a draft
    var isDraft: Bool {
        return interpretation == "Draft - No interpretation yet"
    }
    
    // Custom initializer for creating new dreams
    init(title: String, dreamText: String, interpretation: String, date: Date = Date(), mood: String, userId: String) {
        self.title = title
        self.dreamText = dreamText
        self.interpretation = interpretation
        self.date = date
        self.mood = mood
        self.userId = userId
    }
    
    // Initializer with existing ID for updates
    init(id: String?, title: String, dreamText: String, interpretation: String, date: Date, mood: String, userId: String) {
        self.id = id
        self.title = title
        self.dreamText = dreamText
        self.interpretation = interpretation
        self.date = date
        self.mood = mood
        self.userId = userId
    }
    
    // For backward compatibility with existing code
    init(id: UUID, title: String, dreamText: String, interpretation: String, date: Date, mood: String) {
        self.id = id.uuidString
        self.title = title
        self.dreamText = dreamText
        self.interpretation = interpretation
        self.date = date
        self.mood = mood
        self.userId = Auth.auth().currentUser?.uid ?? ""
    }
}

// MARK: - Firestore Manager

class FirestoreManager: ObservableObject {
    @Published var dreams: [DreamEntry] = []
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    private let db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    init() {
        setupListener()
    }
    
    deinit {
        listener?.remove()
    }
    
    // Set up real-time listener for user's dreams
    private func setupListener() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("dreams")
            .whereField("userId", isEqualTo: userId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let documents = snapshot?.documents else { return }
                
                self?.dreams = documents.compactMap { document in
                    try? document.data(as: DreamEntry.self)
                }
            }
    }
    
    // Save a new dream
    func saveDream(_ dream: DreamEntry) async {
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            try db.collection("dreams").addDocument(from: dream)
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Update an existing dream
    func updateDream(_ dream: DreamEntry) async {
        guard let dreamId = dream.id else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            try db.collection("dreams").document(dreamId).setData(from: dream)
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Delete a dream
    func deleteDream(_ dream: DreamEntry) async {
        guard let dreamId = dream.id else { return }
        
        await MainActor.run {
            isLoading = true
            errorMessage = ""
        }
        
        do {
            try await db.collection("dreams").document(dreamId).delete()
            await MainActor.run {
                self.isLoading = false
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    // Refresh the listener when user changes
    func refreshForCurrentUser() {
        listener?.remove()
        dreams = []
        setupListener()
    }
}

// MARK: - Shared UI Components

struct MoodBadge: View {
    let mood: String
    
    private var moodColor: Color {
        switch mood.lowercased() {
        case "happy", "excited", "peaceful": return .green
        case "anxious", "scared", "worried": return .orange
        case "sad", "lonely": return .blue
        case "determined", "confident": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        Text(mood)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(moodColor)
            .cornerRadius(8)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search dreams...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
} 
