import Foundation
import SwiftUI

// MARK: - Question

struct Question: Identifiable, Codable {
    let id: String
    let section: SectionType
    let type: String
    let stimulus: String
    let stem: String
    let choices: [String]
    let correct: Int
    let explanation: String

    enum SectionType: String, Codable, CaseIterable {
        case lr, lg, rc

        var displayName: String {
            switch self {
            case .lr: return "Logical Reasoning"
            case .lg: return "Logic Games"
            case .rc: return "Reading Comp"
            }
        }

        var shortName: String { rawValue.uppercased() }

        var color: Color {
            switch self {
            case .lr: return .indigo
            case .lg: return .green
            case .rc: return .orange
            }
        }

        var lightColor: Color {
            switch self {
            case .lr: return Color.indigo.opacity(0.12)
            case .lg: return Color.green.opacity(0.12)
            case .rc: return Color.orange.opacity(0.12)
            }
        }

        var perQuestionSeconds: Int {
            switch self {
            case .lr: return 85
            case .lg: return 135
            case .rc: return 75
            }
        }
    }
}

// MARK: - Completed Session

struct CompletedSession: Codable, Identifiable {
    let id: UUID
    let date: Date
    let section: String
    let correct: Int
    let attempted: Int   // excludes skipped
    let total: Int
    let skipped: Int

    var accuracy: Double {
        attempted > 0 ? Double(correct) / Double(attempted) : 0
    }

    var accuracyPct: Int { Int(accuracy * 100) }
}

// MARK: - Practice Mode

enum PracticeTimerMode: String, CaseIterable {
    case timed, untimed
    var displayName: String { rawValue.capitalized }
}

enum PracticeCountMode: String, CaseIterable {
    case five = "5", ten = "10", all = "All"
    var displayName: String {
        switch self {
        case .five: return "5 Questions"
        case .ten: return "10 Questions"
        case .all: return "All Available"
        }
    }
    var intValue: Int? {
        switch self {
        case .five: return 5
        case .ten: return 10
        case .all: return nil
        }
    }
}
