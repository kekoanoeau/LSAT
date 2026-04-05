import SwiftUI

struct LogicGamesView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Method
                lgInfoSection(title: "The Universal LG Process") {
                    VStack(alignment: .leading, spacing: 8) {
                        StepRow(n: 1, text: "Read the scenario — identify game type, players, and slots.", color: .green)
                        StepRow(n: 2, text: "Set up your master diagram before touching any rules.", color: .green)
                        StepRow(n: 3, text: "Symbolize every rule and write contrapositives where applicable.", color: .green)
                        StepRow(n: 4, text: "Make inferences by combining rules before answering any questions.", color: .green)
                        StepRow(n: 5, text: "Answer 'If' questions in a fresh diagram, not the master.", color: .green)
                        StepRow(n: 6, text: "Use elimination — work with answer choices rather than building from scratch.", color: .green)
                    }
                }

                // Game Types
                lgInfoSection(title: "Game Type Reference") {
                    VStack(spacing: 10) {
                        ForEach(gameTypes) { g in GameTypeCard(game: g) }
                    }
                }

                // Rule Symbolization
                lgInfoSection(title: "Rule Symbolization") {
                    VStack(spacing: 0) {
                        ForEach(ruleSymbols) { r in RuleRow(rule: r) }
                    }
                }

                // Question Types
                lgInfoSection(title: "Question Type Strategies") {
                    VStack(spacing: 8) {
                        ForEach(lgQuestionTypes) { qt in LGQuestionRow(type: qt) }
                    }
                }

                // Tips
                lgInfoSection(title: "High-Value Tips") {
                    VStack(spacing: 8) {
                        ForEach(lgTips) { tip in TipRow(tip: tip) }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Logic Games")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func lgInfoSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.green.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Data

private struct GameType: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let example: String
    let approach: [String]
}

private struct RuleSymbol: Identifiable {
    let id = UUID()
    let wording: String
    let symbol: String
    let note: String
}

private struct LGQuestionType: Identifiable {
    let id = UUID()
    let name: String
    let stem: String
    let strategy: String
}

private struct LGTip: Identifiable {
    let id = UUID()
    let title: String
    let body: String
}

private let gameTypes: [GameType] = [
    GameType(name: "Linear / Sequencing", description: "Place variables into ordered slots (positions 1–7, Mon–Fri). Most common game type.", example: "Seven houses A–G, each at a unique position 1–7.", approach: ["Draw numbered slots in a row", "List variables to the side", "A < B means A before B", "[AB] block = immediately consecutive"]),
    GameType(name: "Grouping", description: "Assign variables into two or more distinct groups.", example: "Six employees split into Team 1 and Team 2 (3 each).", approach: ["Draw columns with labeled headers", "Note group sizes and fixed assignments", "A ≠ B = different groups", "A = B = same group"]),
    GameType(name: "In / Out (Selection)", description: "Select a subset to be 'in' while the rest are 'out.' Conditional rules dominate.", example: "Committee selects ≥3 of 7 candidates.", approach: ["Draw IN | OUT columns", "Convert all rules to conditional form", "Always write contrapositive next to each rule", "Chain conditionals to find forced outcomes"]),
    GameType(name: "Matching", description: "Assign attributes to variables. Variables can receive multiple attributes.", example: "Five students, each taking one or more of three subjects.", approach: ["Draw grid: variables as rows, attributes as columns", "Fill cells as Yes / No / Unknown", "Look for forced placements from rules"]),
    GameType(name: "Hybrid", description: "Combines two game types — usually sequencing + grouping or selection + sequencing.", example: "6 people in 3 ranked positions with 2 per position.", approach: ["Identify both components of the hybrid", "Build a diagram capturing both dimensions", "Apply each component's rules methodically"]),
    GameType(name: "Advanced Linear (Multi-Tier)", description: "Two rows of ordered slots matched to each other (days × morning/afternoon).", example: "Four people visit Mon–Thu, each in morning or afternoon.", approach: ["Stack two rows with shared column headers", "Row 1 = one attribute; Row 2 = another", "Rules often link values across rows"]),
]

private let ruleSymbols: [RuleSymbol] = [
    RuleSymbol(wording: "A is before B", symbol: "A < B", note: "B cannot be in slot 1"),
    RuleSymbol(wording: "A immediately before B", symbol: "[AB]", note: "A ≠ last slot; B ≠ first slot"),
    RuleSymbol(wording: "A not adjacent to B", symbol: "A ≁ B", note: "|pos(A)−pos(B)| ≠ 1"),
    RuleSymbol(wording: "If A selected → B selected", symbol: "A → B", note: "Contra: ¬B → ¬A"),
    RuleSymbol(wording: "A and B cannot both be in", symbol: "¬(A∧B)", note: "A→¬B  and  B→¬A"),
    RuleSymbol(wording: "At least one of A or B is in", symbol: "A ∨ B", note: "¬A→B  and  ¬B→A"),
    RuleSymbol(wording: "A in same group as B", symbol: "A ↔ B", note: "Both move together"),
]

private let lgQuestionTypes: [LGQuestionType] = [
    LGQuestionType(name: "Complete & Accurate List", stem: "Which could be a complete and accurate list of...", strategy: "Use each rule to eliminate one answer choice. Fastest when done rule by rule."),
    LGQuestionType(name: "Could Be True", stem: "Which of the following could be true?", strategy: "Find the answer that doesn't violate any rule. Eliminate 4 answers that must be false."),
    LGQuestionType(name: "Must Be True", stem: "Which of the following must be true?", strategy: "Eliminate answers that are only sometimes true. Correct answer holds in ALL valid scenarios."),
    LGQuestionType(name: "Cannot Be True", stem: "Which of the following cannot be true?", strategy: "Find the answer that violates at least one rule in every scenario."),
    LGQuestionType(name: "Conditional 'If' Question", stem: "If A is in position 3, which...", strategy: "Draw a FRESH diagram, add the new condition, make all inferences, then answer."),
    LGQuestionType(name: "Rule Substitution", stem: "Which rule could replace [rule X] with the same effect?", strategy: "Re-derive what the original rule accomplishes. Find the answer producing the same net constraint."),
]

private let lgTips: [LGTip] = [
    LGTip(title: "Budget ~8 min per game", body: "35 minutes ÷ 4 games = ~8.75 min. Skip hard games and return — they're often 2nd or 3rd."),
    LGTip(title: "Do 'If' questions first", body: "Conditional questions give free information. The work builds toward global questions too."),
    LGTip(title: "Identify 'floaters'", body: "Variables with no rules can often go anywhere. Track them to avoid overlooking them."),
    LGTip(title: "Build limited scenarios upfront", body: "If a game has only 2–3 valid configurations, sketch all of them first and answer by checking templates."),
    LGTip(title: "Combine rules sharing a variable", body: "Every pair of rules sharing a variable produces an inference. This is where speed comes from."),
    LGTip(title: "Watch variable vs. slot count", body: "7 variables + 7 slots = 1:1 placement. 8 variables + 5 slots = some must be out (selection component implied)."),
]

// MARK: - Sub-views

private struct StepRow: View {
    let n: Int; let text: String; let color: Color
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(n)").font(.caption).bold().foregroundStyle(.white)
                .frame(width: 22, height: 22).background(color, in: Circle())
            Text(text).font(.subheadline).fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct GameTypeCard: View {
    let game: GameType
    @State private var expanded = false
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }}) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(game.name).font(.subheadline).bold()
                        Text(game.description).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").font(.caption).foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Example: \(game.example)").font(.caption).italic().foregroundStyle(.secondary)
                        .padding(8).background(Color.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
                    VStack(alignment: .leading, spacing: 3) {
                        ForEach(game.approach.indices, id: \.self) { i in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•").foregroundStyle(.green)
                                Text(game.approach[i]).font(.caption)
                            }
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(10).background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct RuleRow: View {
    let rule: RuleSymbol
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text(rule.wording).font(.caption).frame(maxWidth: .infinity, alignment: .leading)
                Text(rule.symbol).font(.system(.caption, design: .monospaced)).bold().foregroundStyle(.green).frame(width: 90)
                Text(rule.note).font(.caption2).foregroundStyle(.secondary).frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 6)
            Divider()
        }
    }
}

private struct LGQuestionRow: View {
    let type: LGQuestionType
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(type.name).font(.caption).bold()
            Text(type.stem).font(.caption).italic().foregroundStyle(.secondary)
            Text(type.strategy).font(.caption).foregroundStyle(.primary)
                .padding(6).background(Color.green.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
        }
        .padding(8).background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct TipRow: View {
    let tip: LGTip
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill").foregroundStyle(.green).font(.subheadline)
            VStack(alignment: .leading, spacing: 2) {
                Text(tip.title).font(.caption).bold()
                Text(tip.body).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
