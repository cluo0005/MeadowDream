import SwiftUI

struct EditDreamView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dreamStore: DreamStore
    let dream: Dream
    @State private var title: String
    @State private var text: String
    @State private var emotion: String
    @State private var tags: [String]
    @State private var newTag: String = ""
    init(dream: Dream) {
        self.dream = dream
        _title = State(initialValue: dream.title)
        _text = State(initialValue: dream.text)
        _emotion = State(initialValue: dream.emotion)
        _tags = State(initialValue: dream.tags)
    }
    var isSaveEnabled: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty && !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.indigo)
                    }
                    Text("Edit Dream")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.leading, 4)
                    Spacer()
                    Button(action: {
                        let updated = Dream(id: dream.id, title: title, text: text, date: dream.date, emotion: emotion, tags: tags)
                        dreamStore.updateDream(updated)
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
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        TextField("Dream title", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        TextEditor(text: $text)
                            .frame(height: 160)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                Group {
                                    if text.isEmpty {
                                        Text("Describe your dream...")
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal, 16)
                                            .padding(.vertical, 12)
                                            .allowsHitTesting(false)
                                    }
                                }, alignment: .topLeading
                            )
                        // Emotion selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Dream Emotion")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            HStack(spacing: 16) {
                                ForEach(["Positive", "Neutral", "Negative", "Uncertain"], id: \ .self) { emo in
                                    VStack(spacing: 6) {
                                        ZStack {
                                            Circle()
                                                .fill(emotion == emo ? Color.indigo : Color(.systemGray6))
                                                .frame(width: 48, height: 48)
                                            Image(systemName: iconName(for: emo))
                                                .font(.title2)
                                                .foregroundColor(emotion == emo ? .white : .secondary)
                                        }
                                        Text(emo)
                                            .font(.caption)
                                            .foregroundColor(emotion == emo ? .indigo : .secondary)
                                    }
                                    .onTapGesture { emotion = emo }
                                }
                            }
                        }
                        // Tag selection
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Tags")
                                .font(.subheadline)
                                .fontWeight(.semibold)
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
    }
    private func iconName(for emotion: String) -> String {
        switch emotion.lowercased() {
        case "positive": return "smiley"
        case "neutral": return "face.neutral"
        case "negative": return "frown"
        case "uncertain": return "questionmark"
        default: return "questionmark"
        }
    }
} 