//
//  DreamDetailView.swift
//  MeadowDream

import SwiftUI
import FirebaseAuth

struct DreamDetailView: View {
    let dream: Dream
    @Environment(\.presentationMode) var presentationMode
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var currentDream: Dream
    @State private var symbolsToDisplay: [DreamSymbol] = []
    @State private var forceUIUpdate = false
    
    // Lucid Dream Checklist States
    @State private var checkedItems: Set<String> = []
    
    init(dream: Dream) {
        self.dream = dream
        self._currentDream = State(initialValue: dream)
        self._symbolsToDisplay = State(initialValue: dream.symbols)
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBar
                
                ScrollView {
                    VStack(spacing: 0) {
                        dreamHeaderView
                        dreamContentView
                        sectionDivider
                        
                        if currentDream.isInterpreted {
                            interpretationSection
                            sectionDivider
                            symbolsSection
                            sectionDivider
                            guidanceSection
                            sectionDivider
                            lucidDreamChecklistSection
                        }
                        
                        Spacer(minLength: 30)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Delete Dream", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteDream()
            }
        } message: {
            Text("Are you sure you want to delete this dream? This action cannot be undone.")
        }
        .sheet(isPresented: $showingEditView) {
            // TODO: Add EditDreamView when implemented
            Text("Edit Dream functionality coming soon!")
                .padding()
        }
    }
    
    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            // Back Button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Dreams")
                        .font(.system(size: 16, weight: .medium))
                }
                .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
            }
            
            Spacer()
            
            // Title
            Text("Dream Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Menu Button
            Menu {
                Button(role: .destructive, action: {
                    showingDeleteAlert = true
                }) {
                    Label("Delete Dream", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color(.separator))
                .opacity(0.3),
            alignment: .bottom
        )
    }
    
    // MARK: - Dream Header View
    private var dreamHeaderView: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Date
            Text(currentDream.date)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            
            // Title
            Text(currentDream.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            // Tags Section
            VStack(alignment: .leading, spacing: 8) {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 70), spacing: 8)
                ], spacing: 8) {
                    ForEach(currentDream.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.357, green: 0.498, blue: 1.0).opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            
            // Mood Section
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Mood")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                }
                
                HStack(spacing: 6) {
                    Image(systemName: currentDream.emotion.icon)
                        .font(.system(size: 14))
                    Text(currentDream.emotion.text)
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(currentDream.emotion.color)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(currentDream.emotion.color.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Dream Content View
    private var dreamContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Dream Description")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            Text(currentDream.preview)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.primary)
                .lineSpacing(4)
                .lineLimit(nil)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Section Divider
    private var sectionDivider: some View {
        Rectangle()
            .fill(Color(.separator))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }
    
    // MARK: - Interpretation Section
    private var interpretationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Interpretation")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
            
            if let dreamInterpretation = currentDream.interpretation, !dreamInterpretation.isEmpty {
                FormattedTextView(content: dreamInterpretation)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity.combined(with: .scale))
            } else {
                Text("This dream has been interpreted with insights and symbols.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .animation(.easeInOut(duration: 0.5), value: currentDream.isInterpreted)
    }
    
    // MARK: - Symbols Section
    private var symbolsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "star.circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                
                Text("Dream Symbols")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if currentDream.isInterpreted && !symbolsToDisplay.isEmpty {
                    Text("\(symbolsToDisplay.count) symbols")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            if currentDream.isInterpreted && !symbolsToDisplay.isEmpty {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                    ForEach(symbolsToDisplay) { symbol in
                        SymbolCardView(symbol: symbol.symbol, meaning: symbol.meaning)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .id("symbols-\(symbolsToDisplay.count)-\(forceUIUpdate)")
            } else if currentDream.isInterpreted && symbolsToDisplay.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    Text("No specific symbols were identified in this dream")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.opacity)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "star.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.secondary.opacity(0.6))
                    
                    Text("Symbols will appear after interpretation")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .animation(.easeInOut(duration: 0.6).delay(0.2), value: currentDream.isInterpreted)
        .animation(.easeInOut(duration: 0.4), value: symbolsToDisplay.count)
        .onChange(of: currentDream.symbols) { newSymbols in
            print("🔄 Symbols changed: \(symbolsToDisplay.count) → \(newSymbols.count)")
            symbolsToDisplay = newSymbols
            forceUIUpdate.toggle()
        }
    }
    
    // MARK: - Guidance Section
    private var guidanceSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "lightbulb")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                
                Text("Lucid Dream Guidance")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            if let dreamGuidance = currentDream.guidance, !dreamGuidance.isEmpty {
                FormattedTextView(content: dreamGuidance)
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .transition(.opacity.combined(with: .scale))
            } else {
                Text("Lucid dream guidance will appear here after interpretation.")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .animation(.easeInOut(duration: 0.5), value: currentDream.isInterpreted)
    }
    
    // MARK: - Lucid Dream Checklist Section
    private var lucidDreamChecklistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
                
                Text("Lucid Dream Checklist")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            VStack(spacing: 12) {
                ChecklistItem(
                    title: "Dream Journal",
                    description: "Record dreams immediately upon waking",
                    isChecked: checkedItems.contains("dream_journal"),
                    onToggle: { toggleChecklistItem("dream_journal") }
                )
                
                ChecklistItem(
                    title: "Reality Checks",
                    description: "Perform 5+ reality checks throughout the day",
                    isChecked: checkedItems.contains("reality_checks"),
                    onToggle: { toggleChecklistItem("reality_checks") }
                )
                
                ChecklistItem(
                    title: "Sleep Schedule",
                    description: "Maintain consistent sleep and wake times",
                    isChecked: checkedItems.contains("sleep_schedule"),
                    onToggle: { toggleChecklistItem("sleep_schedule") }
                )
                
                ChecklistItem(
                    title: "MILD Technique",
                    description: "Practice Mnemonic Induction before sleep",
                    isChecked: checkedItems.contains("mild_technique"),
                    onToggle: { toggleChecklistItem("mild_technique") }
                )
                
                ChecklistItem(
                    title: "Meditation",
                    description: "10+ minutes of mindfulness meditation",
                    isChecked: checkedItems.contains("meditation"),
                    onToggle: { toggleChecklistItem("meditation") }
                )
                
                ChecklistItem(
                    title: "Dream Signs Review",
                    description: "Identify recurring patterns in dreams",
                    isChecked: checkedItems.contains("dream_signs"),
                    onToggle: { toggleChecklistItem("dream_signs") }
                )
            }
            
            // Progress indicator
            HStack {
                let completedCount = checkedItems.count
                let totalCount = 6
                
                Text("\(completedCount)/\(totalCount) habits completed")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("\(Int(Double(completedCount) / Double(totalCount) * 100))%")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 0.357, green: 0.498, blue: 1.0))
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private func toggleChecklistItem(_ itemId: String) {
        if checkedItems.contains(itemId) {
            checkedItems.remove(itemId)
        } else {
            checkedItems.insert(itemId)
        }
    }
    
    // MARK: - Delete Function
    private func deleteDream() {
        // Delete the dream using its ID
        LocalDataManager.shared.deleteDream(withID: currentDream.id)
        print("Dream deleted successfully: \(currentDream.title)")
        
        // Navigate back to the main screen
        presentationMode.wrappedValue.dismiss()
    }
    
    // MARK: - Refresh Current Dream
    private func refreshCurrentDream() {
        print("🔄 Refreshing current dream...")
        
        // Fetch the updated dream from local storage
        let allDreams = LocalDataManager.shared.fetchAllDreams()
        print("📚 Fetched \(allDreams.count) dreams from storage")
        
        if let updatedLocalDream = allDreams.first(where: { $0.id == currentDream.id }) {
            print("🎯 Found updated dream with \(updatedLocalDream.symbols.count) symbols")
            
            // Convert the updated LocalDream to Dream and update the current state
            let oldSymbolsCount = currentDream.symbols.count
            currentDream = Dream(from: updatedLocalDream)
            let newSymbolsCount = currentDream.symbols.count
            
            print("🔄 Updated currentDream: symbols \(oldSymbolsCount) → \(newSymbolsCount)")
            print("✅ Current dream refreshed with interpretation")
            print("🔸 Current dream symbols:")
            for symbol in currentDream.symbols {
                print("  • \(symbol.symbol): \(symbol.meaning)")
            }
        } else {
            print("❌ Failed to find updated dream in local storage with ID: \(currentDream.id)")
        }
    }
}

// MARK: - Supporting Views

struct FormattedTextView: View {
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(parseContent(), id: \.self) { section in
                VStack(alignment: .leading, spacing: 8) {
                    if section.isHeader {
                        Text(section.text)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                            .padding(.top, section.text == parseContent().first?.text ? 0 : 12)
                    } else {
                        Text(section.text)
                            .font(.system(size: 16))
                            .foregroundColor(.primary)
                            .lineSpacing(6)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
    }
    
    private func parseContent() -> [TextSection] {
        let lines = content.components(separatedBy: .newlines)
        var sections: [TextSection] = []
        var currentParagraph = ""
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Skip empty lines but use them as paragraph breaks
            if trimmedLine.isEmpty {
                if !currentParagraph.isEmpty {
                    sections.append(TextSection(text: currentParagraph, isHeader: false))
                    currentParagraph = ""
                }
                continue
            }
            
            // Check if line is a header (standalone line that doesn't end with punctuation)
            let isHeader = isHeaderLine(trimmedLine)
            
            if isHeader {
                // Finish current paragraph if exists
                if !currentParagraph.isEmpty {
                    sections.append(TextSection(text: currentParagraph, isHeader: false))
                    currentParagraph = ""
                }
                // Add header
                sections.append(TextSection(text: trimmedLine, isHeader: true))
            } else {
                // Add to current paragraph
                if !currentParagraph.isEmpty {
                    currentParagraph += " "
                }
                currentParagraph += trimmedLine
            }
        }
        
        // Add final paragraph if exists
        if !currentParagraph.isEmpty {
            sections.append(TextSection(text: currentParagraph, isHeader: false))
        }
        
        return sections
    }
    
    private func isHeaderLine(_ line: String) -> Bool {
        // Check if line looks like a header
        let headerKeywords = [
            "Overall Theme", "Key Symbols Analysis", "Emotional Journey", "Personal Insights",
            "Dream Awareness Techniques", "Reality Check Triggers", "Lucid Action Suggestions", 
            "Practice Recommendations"
        ]
        
        // If line matches header keywords
        if headerKeywords.contains(where: { line.contains($0) }) {
            return true
        }
        
        // If line is short (< 50 chars), doesn't end with punctuation, and doesn't start with number/dash
        if line.count < 50 && 
           !line.hasSuffix(".") && 
           !line.hasSuffix(",") && 
           !line.hasSuffix(":") &&
           !line.hasPrefix("1.") && 
           !line.hasPrefix("2.") && 
           !line.hasPrefix("-") {
            return true
        }
        
        return false
    }
}

struct TextSection: Hashable {
    let text: String
    let isHeader: Bool
}

struct ChecklistItem: View {
    let title: String
    let description: String
    let isChecked: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isChecked ? Color(red: 0.357, green: 0.498, blue: 1.0) : .secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(16)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SymbolCardView: View {
    let symbol: String
    let meaning: String
    
    private func limitedMeaning(_ text: String) -> String {
        let words = text.components(separatedBy: .whitespacesAndNewlines)
        if words.count <= 15 {
            return text
        } else {
            return words.prefix(15).joined(separator: " ") + "..."
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(limitedMeaning(meaning))
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let sampleSymbols = [
        DreamSymbol(symbol: "Flying", meaning: "Freedom and liberation"),
        DreamSymbol(symbol: "City", meaning: "Life complexity and social connections")
    ]
    
    let sampleLocalDream = LocalDream(
        userID: "preview-user",
        title: "Flying over the city",
        content: "I dreamed that I could fly, soaring freely over a modern city. I could feel the wind on my face and see the traffic and pedestrians below. This feeling was very liberating and relaxing, as if all the pressure had disappeared.",
        tags: ["Flying", "City"],
        emotion: "positive",
        isInterpreted: true,
        interpretation: "This dream represents your desire for freedom and escape from daily pressures. Flying symbolizes liberation from constraints, while the city below represents the complexities of modern life that you wish to rise above.",
        symbols: sampleSymbols
    )
    
    DreamDetailView(dream: Dream(from: sampleLocalDream))
} 
