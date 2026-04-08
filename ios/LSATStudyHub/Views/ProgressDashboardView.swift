import SwiftUI
import Charts

struct ProgressDashboardView: View {
    @EnvironmentObject var progress: StudyProgress
    @State private var targetInput: Double = 175
    @State private var showTargetSaved = false
    @State private var showClearConfirm = false

    var body: some View {
        NavigationStack {
            List {
                // Overview stats
                Section {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ProgressStatCard(label: "LR Accuracy", value: progress.accuracyString(for: .lr), color: .primary)
                        ProgressStatCard(label: "RC Accuracy", value: progress.accuracyString(for: .rc), color: .orange)
                        ProgressStatCard(label: "Total Reps", value: "\(progress.totalAttempted)", color: .purple)
                    }
                    .padding(.vertical, 4)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                } header: { Text("Overview") }

                // Accuracy chart
                Section {
                    AccuracyBarsView(progress: progress)
                } header: { Text("Accuracy by Section") }

                // Score estimate
                Section {
                    ScoreEstimateView(progress: progress)
                } header: { Text("Estimated Score") }

                // Target score
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Target Score").font(.subheadline)
                            Spacer()
                            Text("\(Int(targetInput))").font(.title3).bold().foregroundStyle(.indigo)
                        }
                        Slider(value: $targetInput, in: 120...180, step: 1)
                            .tint(.primary)
                        Text(Int(targetInput).lsatPercentileDescription)
                            .font(.caption).foregroundStyle(.secondary)
                        Button("Save Target") {
                            progress.targetScore = Int(targetInput)
                            withAnimation { showTargetSaved = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { showTargetSaved = false }
                        }
                        .buttonStyle(.borderedProminent).tint(.primary)
                        if showTargetSaved {
                            Label("Saved!", systemImage: "checkmark.circle.fill")
                                .font(.caption).foregroundStyle(.green)
                                .transition(.opacity)
                        }
                    }
                } header: { Text("Target Score") }

                // Per-type accuracy
                Section {
                    TypeAccuracyView(progress: progress)
                } header: { Text("Accuracy by Question Type") }
                  footer: { Text("⭐ = 90%+  ·  ⚠ = below 50%. Sorted by accuracy — weakest first.").font(.caption2) }

                // Tips
                if !progress.sessions.isEmpty {
                    Section {
                        PersonalizedTipsView(progress: progress)
                    } header: { Text("Coach's Corner 🎯") }
                }

                // History
                Section {
                    if progress.sessions.isEmpty {
                        Text("No sessions logged yet. Hit the gym — your training history will appear here.")
                            .font(.subheadline).foregroundStyle(.secondary).padding(.vertical, 8)
                    } else {
                        ForEach(progress.sessions.prefix(20)) { s in
                            SessionRow(session: s)
                        }
                    }
                } header: { Text("Training Log") }
                  footer: {
                    if !progress.sessions.isEmpty {
                        Button("Clear History", role: .destructive) { showClearConfirm = true }
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Your Gains 📈")
            .onAppear { targetInput = Double(progress.targetScore) }
            .confirmationDialog("Clear all practice history?", isPresented: $showClearConfirm, titleVisibility: .visible) {
                Button("Clear History", role: .destructive) { progress.clearHistory() }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

// MARK: - Accuracy Bars

private struct AccuracyBarsView: View {
    let progress: StudyProgress

    // Aug 2024+: LG removed from LSAT
    private let sections: [Question.SectionType] = [.lr, .rc]

    var body: some View {
        VStack(spacing: 10) {
            if sections.allSatisfy({ progress.accuracy(for: $0) == nil }) {
                Text("Complete practice sessions to see accuracy data here.")
                    .font(.caption).foregroundStyle(.secondary)
            } else {
                ForEach(sections, id: \.rawValue) { s in
                    if let pct = progress.accuracy(for: s) {
                        HStack(spacing: 10) {
                            Text(s.displayName).font(.caption).frame(width: 110, alignment: .leading)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule().fill(Color(.systemGroupedBackground)).frame(height: 16)
                                    Capsule().fill(s.color).frame(width: geo.size.width * pct, height: 16)
                                }
                            }
                            .frame(height: 16)
                            Text("\(Int(pct * 100))%").font(.caption).bold().frame(width: 36, alignment: .trailing)
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Score Estimate

private struct ScoreEstimateView: View {
    let progress: StudyProgress

    var body: some View {
        if let score = progress.estimatedScore, let range = progress.estimatedScoreRange {
            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(score)")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(.indigo)
                    Text("Range: \(range.lowerBound)–\(range.upperBound)")
                        .font(.caption).foregroundStyle(.secondary)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Based on practice accuracy").font(.caption2).foregroundStyle(.tertiary)
                    Text(score.lsatPercentileDescription).font(.caption).fixedSize(horizontal: false, vertical: true)
                }
            }
        } else {
            Text("Practice in all three sections to see a score estimate.")
                .font(.caption).foregroundStyle(.secondary).padding(.vertical, 4)
        }
    }
}

// MARK: - Personalized Tips

private struct PersonalizedTipsView: View {
    let progress: StudyProgress
    var body: some View {
        VStack(spacing: 8) {
            ForEach(tips, id: \.section) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Circle().fill(tip.color).frame(width: 8, height: 8).padding(.top, 5)
                    Text(tip.message).font(.caption).fixedSize(horizontal: false, vertical: true)
                }
            }
        }
    }

    private struct TipItem { let section: String; let color: Color; let message: String }

    private var tips: [TipItem] {
        var result: [TipItem] = []
        for s in Question.SectionType.allCases {
            guard let pct = progress.accuracy(for: s) else { continue }
            let msg: String
            let color: Color
            if pct < 0.60 {
                msg = "\(s.displayName) (\(Int(pct*100))%): Deload and rebuild. Slow down, drill untimed fundamentals, and don't add weight until you're hitting 70%+ consistently."; color = .red
            } else if pct < 0.75 {
                msg = "\(s.displayName) (\(Int(pct*100))%): You're in the building phase. Debrief every miss — understand exactly WHY each wrong answer is wrong. That's your progressive overload."; color = .orange
            } else if pct < 0.88 {
                msg = "\(s.displayName) (\(Int(pct*100))%): Solid work. Now add the clock — same reps, less rest. Time yourself per-question and refuse to let speed break your form."; color = .indigo
            } else {
                msg = "\(s.displayName) (\(Int(pct*100))%): Elite performance. Maintain this under timed, test-day conditions. Your engine is built — shift energy to weaker sections."; color = .green
            }
            result.append(TipItem(section: s.rawValue, color: color, message: msg))
        }
        return result
    }
}

// MARK: - Session Row

private struct SessionRow: View {
    let session: CompletedSession
    var color: Color {
        session.accuracyPct >= 80 ? .green : session.accuracyPct >= 60 ? .orange : .red
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(sectionName).font(.subheadline).bold()
                Text(session.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            HStack(spacing: 12) {
                Text("\(session.correct)/\(session.attempted)").font(.caption).foregroundStyle(.secondary)
                Text("\(session.accuracyPct)%")
                    .font(.subheadline).bold().foregroundStyle(color)
                    .frame(width: 44, alignment: .trailing)
            }
        }
    }
    private var sectionName: String {
        Question.SectionType(rawValue: session.section)?.displayName ?? session.section.uppercased()
    }
}

// MARK: - Type Accuracy View

private struct TypeAccuracyView: View {
    let progress: StudyProgress

    var body: some View {
        let sorted = progress.typeStatsSorted
        if sorted.isEmpty {
            Text("Answer some practice questions to see per-type accuracy here.")
                .font(.caption).foregroundStyle(.secondary).padding(.vertical, 4)
        } else {
            VStack(spacing: 10) {
                ForEach(sorted, id: \.type) { item in
                    TypeAccuracyRow(type: item.type, result: item.result)
                }
            }
        }
    }
}

private struct TypeAccuracyRow: View {
    let type: String
    let result: TypeResult

    private var barColor: Color {
        switch result.accuracyPct {
        case 80...: return .green
        case 60..<80: return .orange
        default: return .red
        }
    }

    private var indicator: String {
        result.accuracyPct >= 90 ? " ⭐" : result.accuracyPct < 50 ? " ⚠" : ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(type)\(indicator)").font(.caption).fontWeight(.medium)
                Spacer()
                Text("\(result.accuracyPct)%")
                    .font(.caption).bold().foregroundStyle(barColor)
                Text("(\(result.correct)/\(result.total))")
                    .font(.caption2).foregroundStyle(.secondary)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(Color(.systemGroupedBackground)).frame(height: 8)
                    Capsule().fill(barColor)
                        .frame(width: geo.size.width * CGFloat(result.accuracy), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Stat Card

private struct ProgressStatCard: View {
    let label: String; let value: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2).bold().foregroundStyle(color)
            Text(label).font(.caption2).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(color.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
    }
}
