import Foundation

struct Dream: Identifiable, Codable {
    let id: String
    let title: String
    let preview: String
    let tags: [String]
    let emotion: EmotionType
    let isInterpreted: Bool
    let interpretation: String?
    let guidance: String?
    let date: String // Formatted date for display
    let dateCreated: Date // Actual date for sorting
    let symbols: [DreamSymbol]
    
    init(from localDream: LocalDream) {
        self.id = localDream.id
        self.title = localDream.title
        self.preview = localDream.content
        self.tags = localDream.tags
        self.emotion = EmotionType(rawValue: localDream.emotion) ?? .neutral
        self.isInterpreted = localDream.isInterpreted
        self.interpretation = localDream.interpretation
        self.guidance = localDream.guidance
        self.symbols = localDream.symbols
        self.dateCreated = localDream.createdAt
        
        // Format the date for display
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        self.date = formatter.string(from: localDream.createdAt)
    }
} 