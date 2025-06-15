//
//  AddDreamView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

struct AddDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dreamTitle: String = ""
    @State private var dreamContent: String = ""
    @State private var selectedTags: [String] = []
    @State private var selectedEmotion: EmotionType = .neutral
    @State private var showingTagSelection = false
    @State private var showingEmotionSelection = false
    @State private var isInterpreting = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @StateObject private var userSession = UserSessionManager.shared
    
    private let availableTags = ["Flying", "Water", "Animals", "People", "Places", "Colors", "Emotions", "Objects", "Nature", "Travel"]
    private let maxCharacters = 2000
    
    var body: some View {
        NavigationView {
            ZStack {
                // Main Content
                VStack(spacing: 0) {
                    // Content Area
                    ScrollView {
                        VStack(spacing: 20) {
                            // Title Input
                            titleInputView
                            
                            // Dream Content Input
                            textInputView
                            
                            // Tags Section
                            tagsSection
                            
                            // Emotion Selection
                            emotionSection
                            
                            Spacer(minLength: 100)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                .navigationTitle("Record Dream")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.secondary)
                        .disabled(isInterpreting)
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        if isInterpreting {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Button("Interpret") {
                                interpretDream()
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(canInterpret ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                            .disabled(!canInterpret)
                        }
                    }
                }
                
                // Interpretation Animation Overlay
                if isInterpreting {
                    DreamInterpretationAnimationView()
                }
            }
        }
        .sheet(isPresented: $showingTagSelection) {
            TagSelectionView(selectedTags: $selectedTags, availableTags: availableTags)
        }
        .sheet(isPresented: $showingEmotionSelection) {
            EmotionSelectionView(selectedEmotion: $selectedEmotion)
        }
        .alert("Interpretation Failed", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Computed Properties
    private var canSave: Bool {
        !dreamTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !dreamContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private var canInterpret: Bool {
        canSave
    }
    
    private var characterCount: Int {
        dreamContent.count
    }
    
    // MARK: - Title Input View
    private var titleInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            TextField("Dream title", text: $dreamTitle)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                )
                .accentColor(.white)
        }
    }
    
    // MARK: - Text Input View
    private var textInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(red: 0.2, green: 0.25, blue: 0.35))
                    .frame(minHeight: 200)
                
                if dreamContent.isEmpty {
                    Text("Describe your dream in detail...")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(16)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $dreamContent)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                    .onChange(of: dreamContent) { newValue in
                        if newValue.count > maxCharacters {
                            dreamContent = String(newValue.prefix(maxCharacters))
                        }
                    }
            }
            
            // Character count
            HStack {
                Spacer()
                Text("\(characterCount)/\(maxCharacters) characters")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - Tags Section
    private var tagsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Tags")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    showingTagSelection = true
                }) {
                    Text("Add Tags")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                }
            }
            
            if selectedTags.isEmpty {
                Text("No tags selected")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                    ForEach(selectedTags, id: \.self) { tag in
                        HStack {
                            Text(tag)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                            
                            Button(action: {
                                selectedTags.removeAll { $0 == tag }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 10, weight: .medium))
                                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
    
    // MARK: - Emotion Section
    private var emotionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Emotion")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    showingEmotionSelection = true
                }) {
                    Text("Change")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                }
            }
            
            HStack(spacing: 8) {
                Image(systemName: selectedEmotion.icon)
                    .font(.system(size: 16))
                    .foregroundColor(selectedEmotion.color)
                
                Text(selectedEmotion.text)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(selectedEmotion.color)
                
                Spacer()
            }
            .padding(12)
            .background(selectedEmotion.color.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - Actions
    private func interpretDream() {
        guard let currentUserID = userSession.currentUserID else {
            errorMessage = "No user logged in"
            showingError = true
            return
        }
        
        isInterpreting = true
        
        // Create and save the dream first
        let dream = LocalDream(
            userID: currentUserID,
            title: dreamTitle,
            content: dreamContent,
            tags: selectedTags,
            emotion: selectedEmotion.rawValue
        )
        
        // Save dream to local storage
        LocalDataManager.shared.saveDream(dream)
        print("💾 Dream saved with ID: \(dream.id)")
        
        // Now interpret the dream
        NovitaAIClient().fetchDreamInterpretationWithSymbols(dreamContent: dreamContent) { [self] result in
            DispatchQueue.main.async {
                isInterpreting = false
                
                switch result {
                case .success(let response):
                    print("✅ Dream interpretation successful")
                    
                    // Update the dream with interpretation
                    updateDreamWithInterpretation(dreamId: dream.id, interpretation: response.interpretation, guidance: response.guidance, symbols: response.symbols)
                    
                    // Dismiss the add dream view
                    dismiss()
                    
                case .failure(let error):
                    print("❌ Dream interpretation failed: \(error)")
                    errorMessage = "Failed to interpret dream: \(error.localizedDescription)"
                    showingError = true
                }
            }
        }
    }
    
    private func updateDreamWithInterpretation(dreamId: String, interpretation: String, guidance: String, symbols: [DreamSymbol]) {
        // Get all dreams and find the one to update
        var allDreams = LocalDataManager.shared.fetchAllDreams()
        
        if let index = allDreams.firstIndex(where: { $0.id == dreamId }) {
            let originalDream = allDreams[index]
            
            // Create updated dream with interpretation
            let updatedDream = LocalDream(
                id: originalDream.id,
                userID: originalDream.userID,
                title: originalDream.title,
                content: originalDream.content,
                tags: originalDream.tags,
                emotion: originalDream.emotion,
                createdAt: originalDream.createdAt,
                isInterpreted: true,
                interpretation: interpretation,
                guidance: guidance,
                symbols: symbols
            )
            
            // Replace the dream
            allDreams[index] = updatedDream
            
            // Save all dreams back
            if let url = LocalDataManager.shared.dreamsFileURL {
                do {
                    let data = try JSONEncoder().encode(allDreams)
                    try data.write(to: url)
                    print("💾 Dream updated with interpretation successfully")
                    
                    // Post notification to refresh the dream list
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .dreamWasUpdated, object: nil)
                        print("📢 Posted dreamWasUpdated notification")
                    }
                } catch {
                    print("❌ Failed to update dream with interpretation: \(error)")
                }
            }
        }
    }
}

// MARK: - Dream Interpretation Animation View
struct DreamInterpretationAnimationView: View {
    @State private var rotationAngle: Double = 0
    @State private var progress: Double = 0
    
    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Main content
            VStack(spacing: 24) {
                // Circular progress indicator
                ZStack {
                    // Background circle
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 4)
                        .frame(width: 80, height: 80)
                    
                    // Progress circle
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            Color(red: 0.357, green: 0.498, blue: 1.0),
                            style: StrokeStyle(lineWidth: 4, lineCap: .round)
                        )
                        .frame(width: 80, height: 80)
                        .rotationEffect(.degrees(-90))
                        .rotationEffect(.degrees(rotationAngle))
                }
                
                // Title
                Text("Analyzing Your Dream")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                
                // Description
                Text("Our AI is carefully analyzing the symbols and themes within your dream to provide meaningful insights.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                // Progress bar
                VStack(spacing: 8) {
                    HStack {
                        Rectangle()
                            .fill(Color(red: 0.357, green: 0.498, blue: 1.0))
                            .frame(height: 4)
                            .frame(width: UIScreen.main.bounds.width * 0.6 * progress)
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.6)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 2))
                    
                    Text("\(Int(progress * 100))% Complete")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal, 40)
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        // Rotation animation
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
        
        // Progress animation
        withAnimation(.easeInOut(duration: 3)) {
            progress = 0.75
        }
    }
}

// MARK: - Supporting Views

struct TagSelectionView: View {
    @Binding var selectedTags: [String]
    let availableTags: [String]
    @Environment(\.dismiss) private var dismiss
    @State private var customTagText: String = ""
    @State private var showingCustomTagInput: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Select tags that describe your dream")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(availableTags, id: \.self) { tag in
                        Button(action: {
                            if selectedTags.contains(tag) {
                                selectedTags.removeAll { $0 == tag }
                            } else {
                                selectedTags.append(tag)
                            }
                        }) {
                            Text(tag)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(selectedTags.contains(tag) ? .white : .primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedTags.contains(tag) ?
                                    Color(red: 0.357, green: 0.498, blue: 1.0) :
                                    Color(.secondarySystemFill)
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Custom tag input section
                VStack(alignment: .leading, spacing: 12) {
                    if showingCustomTagInput {
                        VStack(spacing: 12) {
                            HStack {
                                TextField("Enter custom tag", text: $customTagText)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .onSubmit {
                                        addCustomTag()
                                    }
                                
                                Button("Add") {
                                    addCustomTag()
                                }
                                .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                                .disabled(customTagText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                            
                            Button("Cancel") {
                                showingCustomTagInput = false
                                customTagText = ""
                            }
                            .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 20)
                    } else {
                        Button(action: {
                            showingCustomTagInput = true
                        }) {
                            HStack {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 16))
                                Text("Add Custom Tag")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                Spacer()
            }
            .navigationTitle("Select Tags")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private func addCustomTag() {
        let trimmedTag = customTagText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !selectedTags.contains(trimmedTag) {
            selectedTags.append(trimmedTag)
            customTagText = ""
            showingCustomTagInput = false
        }
    }
}

struct EmotionSelectionView: View {
    @Binding var selectedEmotion: EmotionType
    @Environment(\.dismiss) private var dismiss
    
    private let emotions: [EmotionType] = [.positive, .neutral, .negative]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("How did this dream make you feel?")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 16) {
                    ForEach(emotions, id: \.self) { emotion in
                        Button(action: {
                            selectedEmotion = emotion
                        }) {
                            HStack(spacing: 16) {
                                Image(systemName: emotion.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(emotion.color)
                                    .frame(width: 40)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(emotion.text)
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primary)
                                    
                                    Text(emotion.description)
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                if selectedEmotion == emotion {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                                }
                            }
                            .padding(16)
                            .background(
                                selectedEmotion == emotion ?
                                emotion.color.opacity(0.1) :
                                Color(.secondarySystemBackground)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .navigationTitle("Select Emotion")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

// MARK: - Extensions

extension EmotionType {
    var description: String {
        switch self {
        case .positive:
            return "Happy, excited, peaceful, or uplifting feelings"
        case .negative:
            return "Sad, anxious, fearful, or disturbing feelings"
        case .neutral:
            return "Calm, indifferent, or mixed emotions"
        }
    }
} 