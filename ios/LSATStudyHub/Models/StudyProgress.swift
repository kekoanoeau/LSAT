import Foundation
import Combine

// MARK: - StudyProgress (global app state)

final class StudyProgress: ObservableObject {

    // MARK: Published state
    @Published var sessions: [CompletedSession] = []
    @Published var targetScore: Int = 175

    // MARK: Accuracy per section (computed from sessions)
    var sectionStats: [String: (correct: Int, total: Int)] {
        var stats: [String: (Int, Int)] = [:]
        for s in sessions {
            let sec = s.section
            var cur = stats[sec] ?? (0, 0)
            cur.0 += s.correct
            cur.1 += s.attempted
            stats[sec] = cur
        }
        return stats
    }

    func accuracy(for section: Question.SectionType) -> Double? {
        let s = sectionStats[section.rawValue]
        guard let s, s.1 > 0 else { return nil }
        return Double(s.0) / Double(s.1)
    }

    func accuracyString(for section: Question.SectionType) -> String {
        guard let a = accuracy(for: section) else { return "—" }
        return "\(Int(a * 100))%"
    }

    var totalAttempted: Int {
        sessions.reduce(0) { $0 + $1.attempted }
    }

    // MARK: Estimated score (simplified mapping)
    var estimatedScore: Int? {
        let lr = accuracy(for: .lr).map { $0 * 100 } ?? -1
        let lg = accuracy(for: .lg).map { $0 * 100 } ?? -1
        let rc = accuracy(for: .rc).map { $0 * 100 } ?? -1

        // Need at least some data
        guard lr >= 0 || lg >= 0 || rc >= 0 else { return nil }

        let lrPct = lr >= 0 ? lr : 65
        let lgPct = lg >= 0 ? lg : 65
        let rcPct = rc >= 0 ? rc : 65

        let raw = (lrPct / 100) * 50 + (lgPct / 100) * 23 + (rcPct / 100) * 27
        let scaled = Int(120 + (raw / 100) * 60)
        return min(180, max(120, scaled))
    }

    var estimatedScoreRange: ClosedRange<Int>? {
        guard let s = estimatedScore else { return nil }
        return max(120, s - 3)...min(180, s + 3)
    }

    // MARK: Persistence (UserDefaults)
    private let sessionsKey = "lsat_sessions_v2"
    private let targetKey   = "lsat_target"

    init() { load() }

    func recordSession(_ session: CompletedSession) {
        sessions.insert(session, at: 0)
        if sessions.count > 200 { sessions.removeLast() }
        save()
    }

    func clearHistory() {
        sessions = []
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(sessions) {
            UserDefaults.standard.set(data, forKey: sessionsKey)
        }
        UserDefaults.standard.set(targetScore, forKey: targetKey)
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: sessionsKey),
           let decoded = try? JSONDecoder().decode([CompletedSession].self, from: data) {
            sessions = decoded
        }
        targetScore = UserDefaults.standard.integer(forKey: targetKey)
        if targetScore == 0 { targetScore = 175 }
    }
}

// MARK: - Score context strings
extension Int {
    var lsatPercentileDescription: String {
        switch self {
        case 178...180: return "Perfect range — 99.9th percentile. Competitive for any law school."
        case 174...177: return "99th percentile. Extremely competitive for T14 schools."
        case 170...173: return "97th–98th percentile. Very strong for any law school."
        case 165...169: return "92nd–96th percentile. Competitive for top-14 programs."
        case 160...164: return "80th–91st percentile. Competitive for top-50 programs."
        case 155...159: return "66th–79th percentile. Median for many law schools."
        case 150...154: return "44th–65th percentile. Above average nationally."
        case 145...149: return "26th–43rd percentile. Below median for most programs."
        case 140...144: return "13th–25th percentile. Significant improvement needed."
        default: return "Keep building your foundation — every point counts."
        }
    }
}
