import Foundation

/// ObservableObject store for managing dreams, tags, and persistence
class DreamStore: ObservableObject {
    /// All dreams, newest first
    @Published var dreams: [Dream] = [] {
        didSet { saveDreamsToUserDefaults() }
    }
    
    /// Initialize and load dreams from UserDefaults
    init() {
        loadDreamsFromUserDefaults()
    }
    
    /// Add a new dream to the store
    func addDream(title: String, text: String, emotion: String, tags: [String]) {
        let newDream = Dream(title: title, text: text, emotion: emotion, tags: tags)
        dreams.insert(newDream, at: 0)
    }
    
    // MARK: - UserDefaults Persistence
    /// Key for UserDefaults
    private let dreamsKey = "dreams"
    /// Load dreams from UserDefaults
    private func loadDreamsFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: dreamsKey) else { return }
        if let decoded = try? JSONDecoder().decode([Dream].self, from: data) {
            dreams = decoded
        }
    }
    /// Save dreams to UserDefaults
    private func saveDreamsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(dreams) {
            UserDefaults.standard.set(encoded, forKey: dreamsKey)
        }
    }
    // MARK: - Tag Management
    /// All unique tags from all dreams, sorted
    var allTags: [String] {
        Set(dreams.flatMap { $0.tags }).sorted()
    }
    // MARK: - Firebase Integration (future)
    /// Load dreams from Firebase (stub)
    func loadDreamsFromFirebase() {
        // Placeholder for future Firebase load logic
    }
    /// Save a dream to Firebase (stub)
    func saveDreamToFirebase(_ dream: Dream) {
        // Placeholder for future Firebase save logic
    }
    // MARK: - Extension Points
    /// Update an existing dream by id
    func updateDream(_ updated: Dream) {
        if let idx = dreams.firstIndex(where: { $0.id == updated.id }) {
            dreams[idx] = updated
        }
    }
    /// Delete a dream by id
    func deleteDream(_ dream: Dream) {
        dreams.removeAll { $0.id == dream.id }
    }
    // Add more methods for editing, deleting, filtering, etc.
} 