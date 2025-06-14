import SwiftUI

struct RecordDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dreamStore: DreamStore
    @State private var inputMode: InputMode = .text
    @State private var title: String = ""
    @State private var dreamText: String = ""
    @State private var isRecording = false
    @State private var selectedEmotion: Emotion? = nil
    @State private var tags: [String] = []
    @State private var newTag: String = ""
    
    enum InputMode { case text, voice }
    enum Emotion: String, CaseIterable, Identifiable {
        case positive = "Positive", neutral = "Neutral", negative = "Negative", uncertain = "Uncertain"
        var id: String { rawValue }
        var icon: String {
            switch self {
            case .positive: return "smiley"
            case .neutral: return "face.neutral"
            case .negative: return "frown"
            case .uncertain: return "questionmark"
            }
        }
        var systemIcon: String {
            switch self {
            case .positive: return "smiley"
            case .neutral: return "face.neutral"
            case .negative: return "frown"
            case .uncertain: return "questionmark"
            }
        }
    }
    
    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !dreamText.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                Text("Record Dream")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                Spacer()
                Button(action: {
                    dreamStore.addDream(title: title, text: dreamText, emotion: selectedEmotion?.rawValue ?? "", tags: tags)
                    title = ""
                    dreamText = ""
                    selectedEmotion = nil
                    tags = []
                    dismiss()
                }) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(isSaveEnabled ? .white : .gray)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(isSaveEnabled ? Color.indigo : Color(.systemGray4))
                        .cornerRadius(8)
                }
                .disabled(!isSaveEnabled)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            // Input mode toggle
            HStack(spacing: 12) {
                Button(action: { inputMode = .text }) {
                    HStack {
                        Image(systemName: "keyboard")
                        Text("Text Input")
                    }
                    .foregroundColor(inputMode == .text ? .indigo : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(inputMode == .text ? Color(.systemGray6) : Color.clear)
                    .cornerRadius(8)
                }
                Button(action: { inputMode = .voice }) {
                    HStack {
                        Image(systemName: "mic")
                        Text("Voice Input")
                    }
                    .foregroundColor(inputMode == .voice ? .indigo : .secondary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(inputMode == .voice ? Color(.systemGray6) : Color.clear)
                    .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if inputMode == .text {
                        TextField("Dream title", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        TextEditor(text: $dreamText)
                            .frame(height: 160)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if dreamText.isEmpty {
                                        Text("Describe your dream...")
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .allowsHitTesting(false)
                                    }
                                }, alignment: .topLeading
                            )
                    } else {
                        VStack(spacing: 16) {
                            Button(action: { isRecording.toggle() }) {
                                ZStack {
                                    Circle()
                                        .fill(isRecording ? Color.red : Color.indigo)
                                        .frame(width: 80, height: 80)
                                    Image(systemName: isRecording ? "stop.fill" : "mic")
                                        .font(.system(size: 32))
                                        .foregroundColor(.white)
                                }
                            }
                            Text(isRecording ? "Recording..." : "Tap to start recording")
                                .font(.headline)
                            Text(isRecording ? "Tap the stop button to end recording" : "Please clearly describe your dream. Voice will be automatically converted to text.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: 240)
                        }
                        .padding(.vertical, 16)
                    }
                    // Emotion selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dream Emotion")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        HStack(spacing: 16) {
                            ForEach(Emotion.allCases) { emotion in
                                VStack(spacing: 6) {
                                    ZStack {
                                        Circle()
                                            .fill(selectedEmotion == emotion ? Color.indigo : Color(.systemGray6))
                                            .frame(width: 48, height: 48)
                                        Image(systemName: iconName(for: emotion))
                                            .font(.title2)
                                            .foregroundColor(selectedEmotion == emotion ? .white : .secondary)
                                    }
                                    Text(emotion.rawValue)
                                        .font(.caption)
                                        .foregroundColor(selectedEmotion == emotion ? .indigo : .secondary)
                                }
                                .onTapGesture { selectedEmotion = emotion }
                            }
                        }
                    }
                    // Tag selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        // Add new tag
                        HStack {
                            TextField("Add tag", text: $newTag)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button(action: {
                                let trimmed = newTag.trimmingCharacters(in: .whitespaces)
                                guard !trimmed.isEmpty, !tags.contains(trimmed) else { return }
                                tags.append(trimmed)
                                newTag = ""
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.indigo)
                            }
                        }
                        // Tag list
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(tags, id: \ .self) { tag in
                                    HStack(spacing: 4) {
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color(.systemIndigo).opacity(0.1))
                                            .foregroundColor(.indigo)
                                            .cornerRadius(8)
                                        Button(action: { tags.removeAll { $0 == tag } }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.caption)
                                                .foregroundColor(.indigo)
                                        }
                                    }
                                }
                                // Tap to add from allTags
                                ForEach(dreamStore.allTags.filter { !tags.contains($0) }, id: \ .self) { tag in
                                    Button(action: { tags.append(tag) }) {
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color(.systemGray6))
                                            .foregroundColor(.indigo)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
    
    private func iconName(for emotion: Emotion) -> String {
        switch emotion {
        case .positive: return "smiley"
        case .neutral: return "face.neutral"
        case .negative: return "frown"
        case .uncertain: return "questionmark"
        }
    }
} 