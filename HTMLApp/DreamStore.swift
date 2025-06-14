import Foundation

class DreamStore {
    static let shared = DreamStore()
    private let dreamsKey = "dreams"
    
    @Published private(set) var dreams: [Dream] = []
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadDreams()
    }
    
    private func loadDreams() {
        if let data = userDefaults.data(forKey: dreamsKey),
           let decodedDreams = try? JSONDecoder().decode([Dream].self, from: data) {
            dreams = decodedDreams.sorted { $0.date > $1.date }
        }
    }
    
    private func saveDreams() {
        if let encodedDreams = try? JSONEncoder().encode(dreams) {
            userDefaults.set(encodedDreams, forKey: dreamsKey)
        }
    }
    
    func addDream(_ dream: Dream) {
        dreams.insert(dream, at: 0)
        saveDreams()
    }
    
    func updateDream(_ dream: Dream) {
        if let index = dreams.firstIndex(where: { $0.id == dream.id }) {
            dreams[index] = dream
            saveDreams()
        }
    }
    
    func deleteDream(_ dream: Dream) {
        dreams.removeAll { $0.id == dream.id }
        saveDreams()
    }
    
    func searchDreams(query: String) -> [Dream] {
        guard !query.isEmpty else { return dreams }
        
        let lowercasedQuery = query.lowercased()
        return dreams.filter { dream in
            dream.title.lowercased().contains(lowercasedQuery) ||
            dream.description.lowercased().contains(lowercasedQuery) ||
            dream.tags.contains { $0.lowercased().contains(lowercasedQuery) }
        }
    }
    
    func filterDreams(mood: Dream.Mood? = nil, isLucid: Bool? = nil, tag: String? = nil) -> [Dream] {
        return dreams.filter { dream in
            let matchesMood = mood == nil || dream.mood == mood
            let matchesLucid = isLucid == nil || dream.isLucid == isLucid
            let matchesTag = tag == nil || dream.tags.contains(tag!)
            return matchesMood && matchesLucid && matchesTag
        }
    }
    
    var statistics: Dream.Statistics {
        return Dream.Statistics(dreams: dreams)
    }
} 