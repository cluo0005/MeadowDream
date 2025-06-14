import SwiftUI
import Models

struct HomeView: View {
    @State private var selectedSegment = 0
    @State private var showRecordDream = false
    @StateObject var dreamStore = DreamStore()
    @State private var searchText = ""
    let segments = ["All", "Favorites"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Meadow Dream")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(.title2)
                                .foregroundColor(.indigo)
                        }
                        Button(action: {}) {
                            Image(systemName: "gearshape")
                                .font(.title2)
                                .foregroundColor(.indigo)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                // Segmented control
                HStack(spacing: 4) {
                    ForEach(segments.indices, id: \ .self) { i in
                        Button(action: { selectedSegment = i }) {
                            Text(segments[i])
                                .fontWeight(selectedSegment == i ? .bold : .regular)
                                .foregroundColor(selectedSegment == i ? .white : .indigo)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(selectedSegment == i ? Color.indigo : Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                // Simple stats
                HStack {
                    Text("Total dreams: \(dreamStore.dreams.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("Tags: \(dreamStore.allTags.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top, 4)
                TextField("Search dreams...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                // Content
                if dreamStore.dreams.isEmpty {
                    Spacer()
                    VStack(spacing: 20) {
                        Image(systemName: "cloud.moon")
                            .font(.system(size: 60))
                            .foregroundColor(Color(.systemGray4))
                        Text("No dreams yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Start recording your dreams to see them here.")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Button(action: { showRecordDream = true }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Dream")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.indigo)
                            .cornerRadius(12)
                        }
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(filteredDreams, id: \ .id) { dream in
                                NavigationLink(destination: DreamDetailView(dream: dream).environmentObject(dreamStore)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(dream.date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        Text(dream.title)
                                            .font(.headline)
                                        Text(dream.text)
                                            .font(.body)
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                        if !dream.emotion.isEmpty {
                                            Text("Emotion: \(dream.emotion.capitalized)")
                                                .font(.caption)
                                                .foregroundColor(.indigo)
                                        }
                                        HStack(spacing: 8) {
                                            ForEach(dream.tags, id: \ .self) { tag in
                                                Text(tag)
                                                    .font(.caption)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 4)
                                                    .background(Color(.systemIndigo).opacity(0.1))
                                                    .foregroundColor(.indigo)
                                                    .cornerRadius(8)
                                            }
                                            if dream.tags.isEmpty {
                                                Text("No tags")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(16)
                                    .shadow(color: Color(.black).opacity(0.04), radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showRecordDream) {
                RecordDreamView()
                    .environmentObject(dreamStore)
            }
        }
    }
    
    private var filteredDreams: [Dream] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return dreamStore.dreams
        }
        let lower = searchText.lowercased()
        return dreamStore.dreams.filter { d in
            d.title.lowercased().contains(lower) ||
            d.text.lowercased().contains(lower) ||
            d.tags.contains(where: { $0.lowercased().contains(lower) })
        }
    }
} 