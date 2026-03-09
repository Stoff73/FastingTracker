import Foundation

struct MoodEntry: Codable, Identifiable, Hashable {
    let id = UUID()
    let emoji: String
    let timestamp: Date
    
    init(emoji: String, timestamp: Date = Date()) {
        self.emoji = emoji
        self.timestamp = timestamp
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: timestamp)
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: timestamp)
    }
}