//
//  InputScreen.swift
//  DreamInterpretation
//

//

import SwiftUI
import FirebaseAuth

struct InputScreen: View {
    @State private var dreamText = ""
    @State private var navigateToResult = false
    @State private var showingSaveDraftSheet = false
    @State private var selectedMood = "Happy"
    @State private var customTitle = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirestoreManager
    
    private let moodOptions = ["Happy", "Excited", "Peaceful", "Anxious", "Scared", "Worried", "Sad", "Lonely", "Determined", "Confident"]
    
    private var draftTitle: String {
        if !customTitle.isEmpty {
            return customTitle
        }
        return generateAutomaticTitle()
    }
    
    private func generateAutomaticTitle() -> String {
        let words = dreamText.components(separatedBy: .whitespaces)
        let firstWords = Array(words.prefix(4)).joined(separator: " ")
        return firstWords.isEmpty ? "My Dream Draft" : firstWords + "... (Draft)"
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "moon.stars.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    Text("Record Your Dream")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Describe your dream in as much detail as you can remember")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Dream Input Section
                VStack(alignment: .leading, spacing: 15) {
                    Text("Dream Description")
                        .font(.headline)
                    
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $dreamText)
                            .frame(minHeight: 200)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(.systemGray4), lineWidth: 1)
                            )
                        
                        if dreamText.isEmpty {
                            Text("I dreamed about...")
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 20)
                                .padding(.top, 20)
                                .allowsHitTesting(false)
                        }
                    }
                }
                
                // Action Buttons
                VStack(spacing: 15) {
                    NavigationLink(destination: ResultScreen(dreamText: dreamText)) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Interpret Dream")
                                .fontWeight(.semibold)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(12)
                    }
                    .disabled(dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    
                    Button(action: {
                        dreamText = ""
                    }) {
                        Text("Clear")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Show error message if any
                if !firestoreManager.errorMessage.isEmpty {
                    Text(firestoreManager.errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal)
        }
        .navigationTitle("New Dream")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save Draft") {
                    showingSaveDraftSheet = true
                }
                .disabled(dreamText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .sheet(isPresented: $showingSaveDraftSheet) {
            SaveDraftSheet(
                dreamText: dreamText,
                customTitle: $customTitle,
                selectedMood: $selectedMood,
                moodOptions: moodOptions,
                onSave: {
                    Task {
                        await saveDraft()
                    }
                }
            )
        }
    }
    
    private func saveDraft() async {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let draft = DreamEntry(
            title: draftTitle,
            dreamText: dreamText,
            interpretation: "Draft - No interpretation yet",
            date: Date(),
            mood: selectedMood,
            userId: userId
        )
        
        await firestoreManager.saveDream(draft)
        
        if firestoreManager.errorMessage.isEmpty {
            showingSaveDraftSheet = false
            dismiss()
        }
    }
}

// MARK: - Save Draft Sheet

struct SaveDraftSheet: View {
    let dreamText: String
    @Binding var customTitle: String
    @Binding var selectedMood: String
    let moodOptions: [String]
    let onSave: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                VStack(spacing: 15) {
                    Image(systemName: "doc.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    
                    Text("Save as Draft")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("You can interpret this dream later")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
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
                                    .foregroundColor(selectedMood == mood ? .white : .orange)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(selectedMood == mood ? Color.orange : Color.orange.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button(action: {
                    onSave()
                }) {
                    Text("Save Draft")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
            .navigationTitle("Save Draft")
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

#Preview {
    NavigationStack {
        InputScreen()
            .environmentObject(FirestoreManager())
    }
} 
