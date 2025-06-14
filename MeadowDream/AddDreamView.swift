//
//  AddDreamView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

enum InputMode {
    case text, voice
}

struct AddDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var dreamTitle: String = ""
    @State private var dreamContent: String = ""
    @State private var selectedTags: [String] = []
    @State private var selectedEmotion: EmotionType = .neutral
    @State private var inputMode: InputMode = .text
    @State private var isRecording = false
    @State private var showingTagSelection = false
    @State private var showingEmotionSelection = false
    @State private var isInterpreting = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @StateObject private var userSession = UserSessionManager.shared
    
    private let availableTags = ["Flying", "Water", "Animals", "People", "Places", "Colors", "Emotions", "Objects", "Nature", "Travel"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Input Mode Toggle
                inputModeToggle
                
                // Content Area
                ScrollView {
                    VStack(spacing: 16) {
                        // Title Input
                        titleInputView
                        
                        // Dream Content Input
                        if inputMode == .text {
                            textInputView
                        } else {
                            voiceInputView
                        }
                        
                        // Tags Section
                        tagsSection
                        
                        // Emotion Selection
                        emotionSection
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
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
    
    // MARK: - Input Mode Toggle
    private var inputModeToggle: some View {
        HStack(spacing: 12) {
            Button(action: {
                inputMode = .text
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "keyboard")
                        .font(.system(size: 14))
                    Text("Text")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(inputMode == .text ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    inputMode == .text ?
                    Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.1) :
                    Color(.secondarySystemFill)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Button(action: {
                inputMode = .voice
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "mic")
                        .font(.system(size: 14))
                    Text("Voice")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(inputMode == .voice ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    inputMode == .voice ?
                    Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.1) :
                    Color(.secondarySystemFill)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    // MARK: - Title Input View
    private var titleInputView: some View {
        TextField("Dream title...", text: $dreamTitle)
            .font(.system(size: 16, weight: .semibold))
            .padding(16)
            .background(Color(.secondarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: - Text Input View
    private var textInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Describe your dream")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            TextEditor(text: $dreamContent)
                .font(.system(size: 16))
                .padding(12)
                .frame(minHeight: 200)
                .background(Color(.secondarySystemFill))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(.separator), lineWidth: 1)
                )
        }
    }
    
    // MARK: - Voice Input View
    private var voiceInputView: some View {
        VStack(spacing: 20) {
            Text("Tap to record your dream")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            VStack(spacing: 20) {
                Button(action: {
                    toggleRecording()
                }) {
                    ZStack {
                        Circle()
                            .fill(isRecording ? Color.red : Color(red: 0.357, green: 0.498, blue: 1.0))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .scaleEffect(isRecording ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: isRecording)
                
                if isRecording {
                    HStack(spacing: 4) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color(red: 0.357, green: 0.498, blue: 1.0))
                                .frame(width: 8, height: 8)
                                .scaleEffect(isRecording ? 1.0 : 0.5)
                                .animation(
                                    Animation.easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isRecording
                                )
                        }
                    }
                    
                    Text("Recording...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                }
            }
            .frame(height: 200)
            .frame(maxWidth: .infinity)
            .background(Color(.secondarySystemFill))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if !dreamContent.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Transcription")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(dreamContent)
                        .font(.system(size: 16))
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemFill))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
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
    private func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            // Start recording logic
            print("Started recording")
        } else {
            // Stop recording and process
            print("Stopped recording")
            // Simulate transcription
            dreamContent = "I was flying over a beautiful city with tall buildings and green parks. The feeling was incredible, like I was completely free."
        }
    }
    
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
                } catch {
                    print("❌ Failed to update dream with interpretation: \(error)")
                }
            }
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