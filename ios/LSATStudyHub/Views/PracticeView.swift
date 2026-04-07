import SwiftUI

// MARK: - Practice View (root)

struct PracticeView: View {
    @EnvironmentObject var progress: StudyProgress
    @StateObject private var session = PracticeSession()

    var body: some View {
        NavigationStack {
            Group {
                switch session.phase {
                case .selection:
                    SelectionScreen(session: session)
                case .active:
                    ActiveScreen(session: session)
                case .results:
                    ResultsScreen(session: session, progress: progress)
                }
            }
            .navigationTitle(session.phase == .selection ? "Training Session 🏋️" : "")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Phase Enum

enum PracticePhase { case selection, active, results }

// MARK: - Practice Session (ObservableObject)

final class PracticeSession: ObservableObject {
    // Config
    @Published var selectedSection: Question.SectionType? = nil
    @Published var selectedCount: PracticeCountMode = .ten
    @Published var timerMode: PracticeTimerMode = .timed

    // Active state
    @Published var phase: PracticePhase = .selection
    @Published var questions: [Question] = []
    @Published var currentIndex: Int = 0
    @Published var answers: [String: Int] = [:]       // questionId → choiceIndex
    @Published var revealed: Set<String> = []
    @Published var secondsLeft: Int = 0

    private var timer: Timer?

    var currentQuestion: Question? { questions.indices.contains(currentIndex) ? questions[currentIndex] : nil }
    var isLastQuestion: Bool { currentIndex == questions.count - 1 }

    func startSession() {
        var pool = selectedSection == nil
            ? questionBank
            : questionBank.filtered(by: selectedSection)
        pool = pool.shuffled()
        if let limit = selectedCount.intValue { pool = Array(pool.prefix(limit)) }
        guard !pool.isEmpty else { return }

        questions = pool
        currentIndex = 0
        answers = [:]
        revealed = []
        phase = .active

        if timerMode == .timed {
            let perQ = selectedSection?.perQuestionSeconds ?? 90
            secondsLeft = perQ * pool.count
            startTimer()
        }
    }

    func selectAnswer(_ choiceIndex: Int) {
        guard let q = currentQuestion, !revealed.contains(q.id) else { return }
        answers[q.id] = choiceIndex
    }

    func submitAnswer() {
        guard let q = currentQuestion, answers[q.id] != nil else { return }
        revealed.insert(q.id)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    func goNext() {
        if isLastQuestion { finishSession() }
        else { currentIndex += 1 }
    }

    func goPrev() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func skipQuestion() {
        if isLastQuestion { finishSession() }
        else { currentIndex += 1 }
    }

    func finishSession() {
        stopTimer()
        phase = .results
    }

    func reset() {
        stopTimer()
        questions = []
        answers = [:]
        revealed = []
        currentIndex = 0
        secondsLeft = 0
        phase = .selection
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.secondsLeft > 0 {
                self.secondsLeft -= 1
            } else {
                self.finishSession()
            }
        }
    }

    private func stopTimer() { timer?.invalidate(); timer = nil }

    // Results
    var correct: Int { questions.filter { revealed.contains($0.id) && answers[$0.id] == $0.correct }.count }
    var skipped: Int { questions.filter { answers[$0.id] == nil }.count }
    var attempted: Int { questions.count - skipped }
    var accuracy: Double { attempted > 0 ? Double(correct) / Double(attempted) : 0 }
}

// MARK: - Selection Screen

private struct SelectionScreen: View {
    @ObservedObject var session: PracticeSession

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Choose your drill").font(.title2).bold().padding(.horizontal)

                // Section
                VStack(alignment: .leading, spacing: 10) {
                    Label("Section", systemImage: "list.bullet").font(.headline).padding(.horizontal)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            OptionChip(label: "All", color: .gray, isSelected: session.selectedSection == nil) {
                                session.selectedSection = nil
                            }
                            ForEach(Question.SectionType.allCases, id: \.rawValue) { s in
                                OptionChip(label: s.shortName, color: s.color, isSelected: session.selectedSection == s) {
                                    session.selectedSection = s
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // Count
                VStack(alignment: .leading, spacing: 10) {
                    Label("Questions", systemImage: "number").font(.headline).padding(.horizontal)
                    HStack(spacing: 12) {
                        ForEach(PracticeCountMode.allCases, id: \.rawValue) { m in
                            OptionChip(label: m.displayName, color: .indigo, isSelected: session.selectedCount == m) {
                                session.selectedCount = m
                            }
                        }
                    }.padding(.horizontal)
                }

                // Timer
                VStack(alignment: .leading, spacing: 10) {
                    Label("Timer", systemImage: "timer").font(.headline).padding(.horizontal)
                    HStack(spacing: 12) {
                        ForEach(PracticeTimerMode.allCases, id: \.rawValue) { m in
                            OptionChip(label: m.displayName, color: .indigo, isSelected: session.timerMode == m) {
                                session.timerMode = m
                            }
                        }
                    }.padding(.horizontal)
                }

                Button(action: { session.startSession() }) {
                    Label("Start Practice", systemImage: "play.fill")
                        .font(.headline).frame(maxWidth: .infinity)
                        .padding().background(Color.black, in: RoundedRectangle(cornerRadius: 14))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Active Screen

private struct ActiveScreen: View {
    @ObservedObject var session: PracticeSession

    var body: some View {
        VStack(spacing: 0) {
            // Progress + Timer bar
            VStack(spacing: 8) {
                HStack {
                    Text("\(session.currentIndex + 1) / \(session.questions.count)")
                        .font(.caption).foregroundStyle(.secondary)
                    Spacer()
                    if session.timerMode == .timed {
                        TimerBadge(seconds: session.secondsLeft)
                    }
                }
                ProgressView(value: Double(session.currentIndex + 1), total: Double(session.questions.count))
                    .tint(.primary)
            }
            .padding()

            // Question card
            if let q = session.currentQuestion {
                ScrollView {
                    VStack(spacing: 16) {
                        QuestionCard(
                            question: q,
                            selectedAnswer: session.answers[q.id],
                            isRevealed: session.revealed.contains(q.id),
                            onSelect: { session.selectAnswer($0) }
                        )

                        // Controls
                        HStack(spacing: 12) {
                            if session.currentIndex > 0 {
                                Button(action: { session.goPrev() }) {
                                    Image(systemName: "chevron.left").bold()
                                }
                                .buttonStyle(.bordered).tint(.secondary)
                            }

                            if session.revealed.contains(q.id) {
                                Button(action: { session.goNext() }) {
                                    Label(session.isLastQuestion ? "Finish" : "Next", systemImage: session.isLastQuestion ? "flag.checkered" : "chevron.right")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent).tint(.primary)
                            } else {
                                Button(action: { session.skipQuestion() }) {
                                    Text("Skip")
                                }
                                .buttonStyle(.bordered).tint(.secondary)

                                Button(action: { session.submitAnswer() }) {
                                    Text("Submit")
                                        .frame(maxWidth: .infinity)
                                }
                                .buttonStyle(.borderedProminent).tint(.primary)
                                .disabled(session.answers[q.id] == nil)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
        }
    }
}

// MARK: - Question Card

private struct QuestionCard: View {
    let question: Question
    let selectedAnswer: Int?
    let isRevealed: Bool
    let onSelect: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Meta
            HStack(spacing: 8) {
                Text(question.section.shortName)
                    .font(.caption2).bold()
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(question.section.color.opacity(0.12), in: Capsule())
                    .foregroundStyle(question.section.color)
                Text(question.type)
                    .font(.caption2)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .background(.quaternary, in: Capsule())
                    .foregroundStyle(.secondary)
            }

            // Stimulus
            Text(question.stimulus)
                .font(.subheadline).lineSpacing(3)
                .padding(12)
                .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 10))

            // Stem
            Text(question.stem).font(.subheadline).bold()

            // Choices
            VStack(spacing: 8) {
                ForEach(question.choices.indices, id: \.self) { i in
                    ChoiceRow(
                        letter: String(UnicodeScalar(65 + i)!),
                        text: question.choices[i],
                        state: choiceState(for: i),
                        onTap: { if !isRevealed { onSelect(i) } }
                    )
                }
            }

            // Explanation
            if isRevealed {
                let correct = selectedAnswer == question.correct
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundStyle(correct ? .green : .red)
                        Text(correct ? "Correct!" : "Incorrect — Answer was \(String(UnicodeScalar(65 + question.correct)!))")
                            .font(.subheadline).bold()
                            .foregroundStyle(correct ? .green : .red)
                    }
                    Text(question.explanation).font(.caption).lineSpacing(2)
                }
                .padding(12)
                .background(Color(.systemGroupedBackground), in: RoundedRectangle(cornerRadius: 10))
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(.separator), lineWidth: 0.5))
        .padding(.horizontal)
        .animation(.easeInOut(duration: 0.25), value: isRevealed)
    }

    private func choiceState(for i: Int) -> ChoiceState {
        guard isRevealed else {
            return selectedAnswer == i ? .selected : .normal
        }
        if i == question.correct { return .correct }
        if i == selectedAnswer { return .wrong }
        return .normal
    }
}

enum ChoiceState { case normal, selected, correct, wrong }

private struct ChoiceRow: View {
    let letter: String
    let text: String
    let state: ChoiceState
    let onTap: () -> Void

    var borderColor: Color {
        switch state {
        case .normal:   return Color(.separator)
        case .selected: return .indigo
        case .correct:  return .green
        case .wrong:    return .red
        }
    }
    var bgColor: Color {
        switch state {
        case .normal:   return .background
        case .selected: return .indigo.opacity(0.08)
        case .correct:  return .green.opacity(0.1)
        case .wrong:    return .red.opacity(0.08)
        }
    }
    var letterColor: Color {
        switch state {
        case .normal:   return .secondary
        case .selected: return .indigo
        case .correct:  return .green
        case .wrong:    return .red
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 10) {
                Text(letter).font(.subheadline).bold().foregroundStyle(letterColor).frame(width: 20)
                Text(text).font(.subheadline).foregroundStyle(.primary).fixedSize(horizontal: false, vertical: true)
                Spacer()
                if state == .correct { Image(systemName: "checkmark").foregroundStyle(.green).font(.caption).bold() }
                if state == .wrong   { Image(systemName: "xmark").foregroundStyle(.red).font(.caption).bold() }
            }
            .padding(12)
            .background(bgColor, in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(borderColor, lineWidth: state == .normal ? 0.5 : 1.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Timer Badge

private struct TimerBadge: View {
    let seconds: Int
    var isWarning: Bool { seconds <= 180 && seconds > 60 }
    var isDanger: Bool  { seconds <= 60 }

    var color: Color { isDanger ? .red : isWarning ? .orange : .primary }

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "timer").font(.caption)
            Text(timeString).font(.system(.caption, design: .monospaced)).bold()
        }
        .foregroundStyle(color)
        .padding(.horizontal, 10).padding(.vertical, 4)
        .background(color.opacity(0.1), in: Capsule())
    }

    private var timeString: String {
        let m = seconds / 60; let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

// MARK: - Results Screen

private struct ResultsScreen: View {
    @ObservedObject var session: PracticeSession
    let progress: StudyProgress

    private var emoji: String {
        let pct = session.accuracy
        if pct >= 0.85 { return "🎉" }
        if pct >= 0.65 { return "💪" }
        return "📚"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Score
                VStack(spacing: 6) {
                    Text(emoji).font(.system(size: 56))
                    Text("\(session.correct)/\(session.attempted)")
                        .font(.system(size: 52, weight: .black, design: .rounded))
                        .foregroundStyle(.indigo)
                    Text("\(Int(session.accuracy * 100))% Accuracy")
                        .font(.headline).foregroundStyle(.secondary)
                }
                .padding(.top)

                // Breakdown
                HStack(spacing: 24) {
                    ResultStat(value: "\(session.correct)", label: "Correct", color: .green)
                    ResultStat(value: "\(session.attempted - session.correct)", label: "Wrong", color: .red)
                    ResultStat(value: "\(session.skipped)", label: "Skipped", color: .gray)
                }

                // Actions
                VStack(spacing: 12) {
                    Button(action: { save(); session.reset() }) {
                        Label("Practice Again", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity).padding()
                            .background(Color.black, in: RoundedRectangle(cornerRadius: 14))
                            .foregroundStyle(.white).font(.headline)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .onAppear { save() }
    }

    private func save() {
        guard !session.questions.isEmpty else { return }

        // Build per-type breakdown
        var typeBreakdown: [String: TypeResult] = [:]
        for q in session.questions {
            guard let ans = session.answers[q.id], session.revealed.contains(q.id) else { continue }
            var entry = typeBreakdown[q.type] ?? TypeResult(correct: 0, total: 0)
            entry.total += 1
            if ans == q.correct { entry.correct += 1 }
            typeBreakdown[q.type] = entry
        }

        let s = CompletedSession(
            id: UUID(),
            date: Date(),
            section: session.selectedSection?.rawValue ?? "mixed",
            correct: session.correct,
            attempted: session.attempted,
            total: session.questions.count,
            skipped: session.skipped,
            typeBreakdown: typeBreakdown
        )
        progress.recordSession(s)
    }
}

private struct ResultStat: View {
    let value: String; let label: String; let color: Color
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(size: 28, weight: .bold, design: .rounded)).foregroundStyle(color)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
    }
}

private struct OptionChip: View {
    let label: String; let color: Color; let isSelected: Bool; let action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(label).font(.subheadline).bold()
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(isSelected ? color : color.opacity(0.1), in: Capsule())
                .foregroundStyle(isSelected ? .white : color)
        }
        .buttonStyle(.plain)
    }
}
