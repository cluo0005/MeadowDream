import Foundation

struct Dream: Codable, Identifiable {
    let id: UUID
    var date: Date
    var title: String
    var description: String
    var mood: Mood
    var isLucid: Bool
    var tags: [String]
    
    enum Mood: String, Codable, CaseIterable {
        case happy = "Happy"
        case excited = "Excited"
        case peaceful = "Peaceful"
        case neutral = "Neutral"
        case confused = "Confused"
        case anxious = "Anxious"
        case sad = "Sad"
        case scared = "Scared"
        case angry = "Angry"
        
        var emoji: String {
            switch self {
            case .happy: return "😊"
            case .excited: return "🤩"
            case .peaceful: return "😌"
            case .neutral: return "😐"
            case .confused: return "😕"
            case .anxious: return "😰"
            case .sad: return "😢"
            case .scared: return "😱"
            case .angry: return "😠"
            }
        }
    }
    
    init(id: UUID = UUID(), date: Date = Date(), title: String, description: String, mood: Mood, isLucid: Bool, tags: [String]) {
        self.id = id
        self.date = date
        self.title = title
        self.description = description
        self.mood = mood
        self.isLucid = isLucid
        self.tags = tags
    }
}

// MARK: - Statistics
extension Dream {
    struct Statistics {
        let totalDreams: Int
        let lucidDreams: Int
        let moodDistribution: [Mood: Int]
        let mostCommonTags: [(tag: String, count: Int)]
        let averageDreamsPerWeek: Double
        
        init(dreams: [Dream]) {
            totalDreams = dreams.count
            lucidDreams = dreams.filter { $0.isLucid }.count
            
            // Calculate mood distribution
            var moodCounts: [Mood: Int] = [:]
            for mood in Mood.allCases {
                moodCounts[mood] = dreams.filter { $0.mood == mood }.count
            }
            moodDistribution = moodCounts
            
            // Calculate most common tags
            var tagCounts: [String: Int] = [:]
            dreams.forEach { dream in
                dream.tags.forEach { tag in
                    tagCounts[tag, default: 0] += 1
                }
            }
            mostCommonTags = tagCounts.sorted { $0.value > $1.value }
                .prefix(10)
                .map { (tag: $0.key, count: $0.value) }
            
            // Calculate average dreams per week
            if let firstDream = dreams.min(by: { $0.date < $1.date }) {
                let weeks = Calendar.current.dateComponents([.weekOfYear], 
                    from: firstDream.date, 
                    to: Date()).weekOfYear ?? 1
                averageDreamsPerWeek = Double(totalDreams) / Double(max(1, weeks))
            } else {
                averageDreamsPerWeek = 0
            }
        }
    }
} 