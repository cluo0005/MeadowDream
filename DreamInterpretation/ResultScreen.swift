//
//  ResultScreen.swift
//  DreamInterpretation
//

import SwiftUI
import FirebaseAuth

struct ResultScreen: View {
    let dreamText: String?
    let dreamEntry: DreamEntry?
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    @EnvironmentObject var aiService: AIService
    @State private var isLoading = false
    @State private var selectedMood = "Happy"
    @State private var customTitle = ""
    @State private var showingSaveOptions = false
    @State private var aiInterpretation = ""
    @State private var hasStartedInterpretation = false
    @State private var showingEditSheet = false
    @State private var editTitle = ""
    @State private var editMood = ""
    
    private let moodOptions = ["Happy", "Excited", "Peaceful", "Anxious", "Scared", "Worried", "Sad", "Lonely", "Determined", "Confident"]
    
    // Initialize with either new dream text or existing dream entry
    init(dreamText: String) {
        self.dreamText = dreamText
        self.dreamEntry = nil
    }
    
    init(dreamEntry: DreamEntry) {
        self.dreamText = nil
        self.dreamEntry = dreamEntry
    }
    
    private var currentDreamText: String {
        dreamText ?? dreamEntry?.dreamText ?? ""
    }
    
    private var interpretation: String {
        if let dreamEntry = dreamEntry {
            return dreamEntry.interpretation
        } else {
            return aiInterpretation.isEmpty ? "Generating interpretation..." : aiInterpretation
        }
    }
    
    private var dreamTitle: String {
        if !customTitle.isEmpty {
            return customTitle
        }
        return dreamEntry?.title ?? generateAutomaticTitle()
    }
    
    private func generateAutomaticTitle() -> String {
        let words = currentDreamText.components(separatedBy: .whitespaces)
        let firstWords = Array(words.prefix(4)).joined(separator: " ")
        return firstWords.isEmpty ? "My Dream" : firstWords + "..."
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header Section
                VStack(spacing: 15) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text(dreamTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    if let entry = dreamEntry {
                        Text(entry.date, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Generated just now")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)
                
                // Dream Text Section
                VStack(alignment: .leading, spacing: 15) {
                    SectionHeader(title: "Your Dream", icon: "moon.fill")
                    
                    Text(currentDreamText)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                // Interpretation Section
                VStack(alignment: .leading, spacing: 15) {
                    SectionHeader(title: "AI Interpretation", icon: "brain.head.profile")
                    
                    if aiService.isLoading || (dreamText != nil && aiInterpretation.isEmpty && hasStartedInterpretation) {
                        LoadingView()
                    } else {
                        Text(interpretation)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding()
                            .background(Color.blue.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                            )
                    }
                    
                    // Show AI error if any
                    if !aiService.errorMessage.isEmpty {
                        VStack(spacing: 15) {
                            Text(aiService.errorMessage)
                                .font(.caption)
                                .foregroundColor(.red)
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                Task {
                                    hasStartedInterpretation = true
                                    aiInterpretation = await aiService.interpretDream(currentDreamText)
                                    // If this is an existing dream entry, update it
                                    if dreamEntry != nil {
                                        await updateDreamWithInterpretation()
                                    }
                                }
                            }) {
                                HStack {
                                    if aiService.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .foregroundColor(.white)
                                    } else {
                                        Image(systemName: "arrow.clockwise")
                                    }
                                    Text("Retry")
                                        .fontWeight(.semibold)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            .disabled(aiService.isLoading)
                        }
                    }
                }
                
                // Mood Section (if from existing entry)
                if let entry = dreamEntry {
                    VStack(alignment: .leading, spacing: 15) {
                        SectionHeader(title: "Mood", icon: "heart.fill")
                        
                        HStack {
                            MoodBadge(mood: entry.mood)
                            Spacer()
                        }
                    }
                }
                
                // Action Buttons
                VStack(spacing: 15) {
                    if dreamText != nil && !aiInterpretation.isEmpty {
                        // New dream save button
                        Button(action: {
                            showingSaveOptions = true
                        }) {
                            HStack {
                                if firestoreManager.isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .foregroundColor(.white)
                                } else {
                                    Image(systemName: "heart.fill")
                                }
                                Text("Save Dream")
                                    .fontWeight(.semibold)
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                        }
                        .disabled(firestoreManager.isLoading)
                    }
                    
                    if let dreamEntry = dreamEntry {
                        if dreamEntry.isDraft {
                            // Interpret draft button
                            Button(action: {
                                Task {
                                    hasStartedInterpretation = true
                                    aiInterpretation = await aiService.interpretDream(currentDreamText)
                                    // Update the dream with interpretation
                                    await updateDreamWithInterpretation()
                                }
                            }) {
                                HStack {
                                    if aiService.isLoading {
                                        ProgressView()
                                            .scaleEffect(0.8)
                                            .foregroundColor(.white)
                                    } else {
                                        Image(systemName: hasStartedInterpretation && !aiService.errorMessage.isEmpty ? "arrow.clockwise" : "sparkles")
                                    }
                                    Text(hasStartedInterpretation && !aiService.errorMessage.isEmpty ? "Retry Interpretation" : "Interpret Dream")
                                        .fontWeight(.semibold)
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                            }
                            .disabled(aiService.isLoading)
                        } else {
                            Button(action: {
                                showingEditSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Edit Dream")
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    // Show error message if any
                    if !firestoreManager.errorMessage.isEmpty {
                        Text(firestoreManager.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal)
        }
        .navigationTitle("Interpretation")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSaveOptions) {
            SaveDreamSheet(
                dreamText: currentDreamText,
                interpretation: aiInterpretation,
                customTitle: $customTitle,
                selectedMood: $selectedMood,
                moodOptions: moodOptions,
                onSave: {
                    Task {
                        await saveDream()
                    }
                }
            )
        }
        .sheet(isPresented: $showingEditSheet) {
            EditDreamSheet(
                dreamEntry: dreamEntry!,
                editTitle: $editTitle,
                editMood: $editMood,
                moodOptions: moodOptions,
                onSave: {
                    Task {
                        await updateDreamDetails()
                    }
                }
            )
        }
        .onAppear {
            if dreamText != nil && aiInterpretation.isEmpty {
                // Get AI interpretation for new dreams
                Task {
                    hasStartedInterpretation = true
                    aiInterpretation = await aiService.interpretDream(currentDreamText)
                }
            }
            
            // Initialize edit fields with current dream data
            if let dreamEntry = dreamEntry {
                editTitle = dreamEntry.title
                editMood = dreamEntry.mood
            }
        }
    }
    
    private func saveDream() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let dream = DreamEntry(
            title: dreamTitle,
            dreamText: currentDreamText,
            interpretation: aiInterpretation,
            date: Date(),
            mood: selectedMood,
            userId: userId
        )
        
        await firestoreManager.saveDream(dream)
        
        if firestoreManager.errorMessage.isEmpty {
            showingSaveOptions = false
            dismiss()
        }
    }
    
    private func updateDreamWithInterpretation() async {
        guard let dreamEntry = dreamEntry,
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let updatedDream = DreamEntry(
            id: dreamEntry.id,
            title: dreamEntry.title,
            dreamText: dreamEntry.dreamText,
            interpretation: aiInterpretation,
            date: dreamEntry.date,
            mood: dreamEntry.mood,
            userId: userId
        )
        
        await firestoreManager.updateDream(updatedDream)
    }
    
    private func updateDreamDetails() async {
        guard let dreamEntry = dreamEntry,
              let userId = Auth.auth().currentUser?.uid else { return }
        
        let updatedDream = DreamEntry(
            id: dreamEntry.id,
            title: editTitle,
            dreamText: dreamEntry.dreamText,
            interpretation: dreamEntry.interpretation,
            date: dreamEntry.date,
            mood: editMood,
            userId: userId
        )
        
        await firestoreManager.updateDream(updatedDream)
        
        if firestoreManager.errorMessage.isEmpty {
            showingEditSheet = false
        }
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.blue)
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
        }
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                        .scaleEffect(isAnimating ? 1.0 : 0.5)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }
            }
            
            Text("AI is analyzing your dream...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .onAppear {
            isAnimating = true
        }
    }
}

struct SaveDreamSheet: View {
    let dreamText: String
    let interpretation: String
    @Binding var customTitle: String
    @Binding var selectedMood: String
    let moodOptions: [String]
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.green)
                    
                    Text("Save Your Dream")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Dream Title")
                        .font(.headline)
                    
                    TextField("Enter a title for your dream", text: $customTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("How did this dream make you feel?")
                        .font(.headline)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 10) {
                        ForEach(moodOptions, id: \.self) { mood in
                            Button(action: {
                                selectedMood = mood
                            }) {
                                Text(mood)
                                    .font(.subheadline)
                                    .foregroundColor(selectedMood == mood ? .white : .blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedMood == mood ? Color.blue : Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    onSave()
                }) {
                    Text("Save Dream")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Save Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview("New Dream Result") {
    NavigationStack {
        ResultScreen(dreamText: "I was flying over a beautiful city with golden buildings and clear blue skies. I felt free and peaceful, soaring through the clouds without any fear.")
    }
}

#Preview("Existing Dream Result") {
    NavigationStack {
        ResultScreen(dreamEntry: DreamEntry(
            id: UUID(),
            title: "Flying Over the City",
            dreamText: "I was soaring through the clouds above a beautiful cityscape...",
            interpretation: "Flying dreams often represent freedom and ambition...",
            date: Date(),
            mood: "Excited"
        ))
    }
}

// MARK: - Edit Dream Sheet

struct EditDreamSheet: View {
    let dreamEntry: DreamEntry
    @Binding var editTitle: String
    @Binding var editMood: String
    let moodOptions: [String]
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Edit Dream")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.top)
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Dream Title")
                        .font(.headline)
                    
                    TextField("Enter a title for your dream", text: $editTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: 15) {
                    Text("Mood")
                        .font(.headline)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                        ForEach(moodOptions, id: \.self) { mood in
                            Button(action: {
                                editMood = mood
                            }) {
                                Text(mood)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(editMood == mood ? .white : .primary)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(editMood == mood ? Color.blue : Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                // Show error message if any
                if !firestoreManager.errorMessage.isEmpty {
                    Text(firestoreManager.errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 15) {
                    Button(action: {
                        onSave()
                    }) {
                        HStack {
                            if firestoreManager.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "checkmark")
                            }
                            Text("Save Changes")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(firestoreManager.isLoading || editTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Edit Dream")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 