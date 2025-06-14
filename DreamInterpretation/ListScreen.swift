//
//  ListScreen.swift
//  DreamInterpretation
//
//

import SwiftUI

struct ListScreen: View {
    @State private var searchText = ""
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    var filteredDreams: [DreamEntry] {
        if searchText.isEmpty {
            return firestoreManager.dreams
        } else {
            return firestoreManager.dreams.filter { dream in
                dream.title.localizedCaseInsensitiveContains(searchText) ||
                dream.dreamText.localizedCaseInsensitiveContains(searchText) ||
                dream.mood.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Search Bar
            SearchBar(text: $searchText)
                .padding(.horizontal)
                .padding(.top, 10)
            
            if firestoreManager.isLoading && firestoreManager.dreams.isEmpty {
                // Loading State
                VStack(spacing: 20) {
                    Spacer()
                    
                    ProgressView()
                        .scaleEffect(1.2)
                    
                    Text("Loading your dreams...")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            } else if filteredDreams.isEmpty {
                // Empty State
                VStack(spacing: 20) {
                    Spacer()
                    
                    Image(systemName: "moon.zzz.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text(searchText.isEmpty ? "No Dreams Yet" : "No Dreams Found")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text(searchText.isEmpty ? 
                         "Start recording your dreams to see them here" : 
                         "Try adjusting your search terms")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    if searchText.isEmpty {
                        NavigationLink(destination: InputScreen()) {
                            Text("Record First Dream")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Show error message if any
                    if !firestoreManager.errorMessage.isEmpty {
                        Text(firestoreManager.errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.top)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 40)
            } else {
                // Dreams List
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(filteredDreams) { dream in
                            NavigationLink(destination: ResultScreen(dreamEntry: dream)) {
                                DreamRowView(dream: dream)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .refreshable {
                    firestoreManager.refreshForCurrentUser()
                }
            }
        }
        .navigationTitle("My Dreams")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: InputScreen()) {
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
        }
    }
}

struct DreamRowView: View {
    let dream: DreamEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with title and date
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(dream.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        if dream.isDraft {
                            Text("DRAFT")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.orange)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(dream.date, style: .date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                MoodBadge(mood: dream.mood)
            }
            
            // Dream preview
            Text(dream.dreamText)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Footer with interpretation/draft status
            HStack {
                if dream.isDraft {
                    Image(systemName: "doc.text")
                        .font(.caption)
                        .foregroundColor(.orange)
                    
                    Text("Tap to interpret")
                        .font(.caption)
                        .foregroundColor(.orange)
                } else {
                    Image(systemName: "sparkles")
                        .font(.caption)
                        .foregroundColor(.blue)
                    
                    Text("Interpretation available")
                        .font(.caption)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        ListScreen()
    }
} 
