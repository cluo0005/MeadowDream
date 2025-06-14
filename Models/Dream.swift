import Foundation

struct Dream: Identifiable, Codable {
    let id: UUID
    var title: String
    var text: String
    var date: Date
    var emotion: String
    var tags: [String]
    var interpretation: String?
    
    init(id: UUID = UUID(), title: String, text: String, date: Date = Date(), emotion: String, tags: [String] = [], interpretation: String? = nil) {
        self.id = id
        self.title = title
        self.text = text
        self.date = date
        self.emotion = emotion
        self.tags = tags
        self.interpretation = interpretation
    }
} 