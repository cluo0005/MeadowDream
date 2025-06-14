import SwiftUI

struct DreamDetailView: View {
    let dream: Dream
    @EnvironmentObject var dreamStore: DreamStore
    @Environment(\.dismiss) private var dismiss
    @State private var showEdit = false
    @State private var showDeleteAlert = false
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.indigo)
                }
                Text("Dream Detail")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(.leading, 4)
                Spacer()
                HStack(spacing: 16) {
                    Button(action: { showEdit = true }) {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.indigo)
                    }
                    Button(action: { showDeleteAlert = true }) {
                        Image(systemName: "trash")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    Button(action: { /* Share action */ }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title2)
                            .foregroundColor(.indigo)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(dream.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(dream.title)
                        .font(.title)
                        .fontWeight(.bold)
                    HStack(spacing: 8) {
                        if !dream.emotion.isEmpty {
                            Label(dream.emotion.capitalized, systemImage: emotionIcon(for: dream.emotion))
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(emotionColor(for: dream.emotion).opacity(0.15))
                                .foregroundColor(emotionColor(for: dream.emotion))
                                .cornerRadius(8)
                        }
                        ForEach(dream.tags, id: \ .self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray5))
                                .foregroundColor(.indigo)
                                .cornerRadius(8)
                        }
                    }
                    Text(dream.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .padding(.top, 4)
                    Divider().padding(.vertical, 8)
                    Text("Dream Interpretation")
                        .font(.headline)
                        .foregroundColor(.indigo)
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemIndigo).opacity(0.08))
                        .frame(minHeight: 80)
                        .overlay(
                            Text("AI analysis coming soon...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        )
                }
                .padding()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showEdit) {
            EditDreamView(dream: dream)
                .environmentObject(dreamStore)
        }
        .alert("Delete this dream?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                dreamStore.deleteDream(dream)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }
    private func emotionIcon(for emotion: String) -> String {
        switch emotion.lowercased() {
        case "positive": return "smiley"
        case "neutral": return "face.neutral"
        case "negative": return "frown"
        case "uncertain": return "questionmark"
        default: return "questionmark"
        }
    }
    private func emotionColor(for emotion: String) -> Color {
        switch emotion.lowercased() {
        case "positive": return .green
        case "neutral": return .gray
        case "negative": return .red
        case "uncertain": return .orange
        default: return .gray
        }
    }
} 