import Foundation

class LocalDataManager {
    static let shared = LocalDataManager()
    
    private init() {}
    
    // MARK: - File URLs
    private var usersFileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("users.json")
    }
    
    var dreamsFileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("dreams.json")
    }
    
    // MARK: - User Data Management
    
    func saveUser(_ user: UserProfile) {
        guard let url = usersFileURL else { return }
        
        do {
            var users = fetchAllUsers()
            // Remove existing user with same ID if exists
            users.removeAll { $0.uid == user.uid }
            users.append(user)
            
            let data = try JSONEncoder().encode(users)
            try data.write(to: url)
            print("User saved successfully")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    func fetchAllUsers() -> [UserProfile] {
        guard let url = usersFileURL else { return [] }
        
        // Check if file exists first
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Users file doesn't exist yet, returning empty array")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let users = try JSONDecoder().decode([UserProfile].self, from: data)
            return users
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
    
    func fetchUser(byID id: String) -> UserProfile? {
        let users = fetchAllUsers()
        return users.first { $0.uid == id }
    }
    
    // MARK: - Dream Data Management
    
    func saveDream(_ dream: LocalDream) {
        guard let url = dreamsFileURL else { return }
        
        do {
            var dreams = fetchAllDreams()
            dreams.append(dream)
            
            let data = try JSONEncoder().encode(dreams)
            try data.write(to: url)
            print("Dream saved successfully. Total dreams: \(dreams.count)")
            print("Dream saved with userID: \(dream.userID), title: \(dream.title)")
        } catch {
            print("Failed to save dream: \(error)")
        }
    }
    
    func fetchAllDreams() -> [LocalDream] {
        guard let url = dreamsFileURL else { return [] }
        
        // Check if file exists first
        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Dreams file doesn't exist yet, returning empty array")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let dreams = try JSONDecoder().decode([LocalDream].self, from: data)
            print("Successfully loaded \(dreams.count) dreams from file")
            return dreams
        } catch {
            print("Failed to fetch dreams: \(error)")
            return []
        }
    }
    
    func fetchDreams(forUserID userID: String) -> [LocalDream] {
        let allDreams = fetchAllDreams()
        let userDreams = allDreams.filter { $0.userID == userID }
        print("Filtered dreams for user \(userID): \(userDreams.count) out of \(allDreams.count) total dreams")
        return userDreams
    }
    
    func deleteDream(withID dreamID: String) {
        guard let url = dreamsFileURL else { return }
        
        do {
            var dreams = fetchAllDreams()
            let initialCount = dreams.count
            dreams.removeAll { $0.id == dreamID }
            let finalCount = dreams.count
            
            let data = try JSONEncoder().encode(dreams)
            try data.write(to: url)
            print("Dream deleted successfully. Dreams count: \(initialCount) -> \(finalCount)")
        } catch {
            print("Failed to delete dream: \(error)")
        }
    }
    
    // MARK: - Clear Data
    
    func clearAllData() {
        if let usersURL = usersFileURL {
            try? FileManager.default.removeItem(at: usersURL)
        }
        if let dreamsURL = dreamsFileURL {
            try? FileManager.default.removeItem(at: dreamsURL)
        }
        print("All local data cleared")
    }
}

// MARK: - Data Models

struct UserProfile: Codable {
    let uid: String
    let email: String
    let username: String
    let createdAt: Date
    var dreamCount: Int
    var interpretedDreams: Int
    
    init(uid: String, email: String, username: String) {
        self.uid = uid
        self.email = email
        self.username = username
        self.createdAt = Date()
        self.dreamCount = 0
        self.interpretedDreams = 0
    }
}

struct LocalDream: Codable, Identifiable {
    let id: String
    let userID: String
    let title: String
    let content: String
    let tags: [String]
    let emotion: String
    let createdAt: Date
    let isInterpreted: Bool
    let interpretation: String?
    let guidance: String?
    let symbols: [DreamSymbol]
    
    // Initializer for new dreams
    init(userID: String, title: String, content: String, tags: [String], emotion: String, isInterpreted: Bool = false, interpretation: String? = nil, guidance: String? = nil, symbols: [DreamSymbol] = []) {
        self.id = UUID().uuidString
        self.userID = userID
        self.title = title
        self.content = content
        self.tags = tags
        self.emotion = emotion
        self.createdAt = Date()
        self.isInterpreted = isInterpreted
        self.interpretation = interpretation
        self.guidance = guidance
        self.symbols = symbols
    }
    
    // Initializer for updating existing dreams (preserves ID and createdAt)
    init(id: String, userID: String, title: String, content: String, tags: [String], emotion: String, createdAt: Date, isInterpreted: Bool, interpretation: String? = nil, guidance: String? = nil, symbols: [DreamSymbol] = []) {
        self.id = id
        self.userID = userID
        self.title = title
        self.content = content
        self.tags = tags
        self.emotion = emotion
        self.createdAt = createdAt
        self.isInterpreted = isInterpreted
        self.interpretation = interpretation
        self.guidance = guidance
        self.symbols = symbols
    }
} 