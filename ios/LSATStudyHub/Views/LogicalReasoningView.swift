import SwiftUI

struct LogicalReasoningView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Format notice
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill").foregroundStyle(.blue)
                    Text("Aug 2024+ Format: LR is now ~65% of your score across 2 scored sections (~50 questions). Logic Games was removed — LR is the single most impactful section.")
                        .font(.caption)
                }
                .padding(10)
                .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

                // Method
                InfoSection(title: "The LR Method", color: .indigo) {
                    VStack(alignment: .leading, spacing: 8) {
                        StepRow(n: 1, text: "Identify the question type from the stem before reading the stimulus.")
                        StepRow(n: 2, text: "Read actively — tag conclusion (C), premises (P), and any assumptions.")
                        StepRow(n: 3, text: "Pre-phrase an answer before looking at the choices.")
                        StepRow(n: 4, text: "Eliminate aggressively — 4 answers are wrong for specific reasons.")
                        StepRow(n: 5, text: "Pick the best answer, not a perfect one.")
                    }
                }

                // Argument Anatomy
                InfoSection(title: "Anatomy of an LSAT Argument", color: .indigo) {
                    VStack(spacing: 8) {
                        TermRow(term: "Conclusion", detail: "Main point author tries to prove. Keywords: therefore, thus, hence, so, clearly.")
                        TermRow(term: "Premise", detail: "Evidence supporting the conclusion. Keywords: because, since, given that, for, as.")
                        TermRow(term: "Assumption", detail: "Unstated premise the argument requires. The gap between premises and conclusion.")
                        TermRow(term: "Flaw", detail: "The logical error in the argument. The LSAT uses a finite, learnable set of recurring flaws.")
                    }
                }

                // Question Types
                InfoSection(title: "Question Type Reference", color: .indigo) {
                    VStack(spacing: 10) {
                        ForEach(lrQuestionTypes) { qt in
                            QuestionTypeRow(type: qt)
                        }
                    }
                }

                // Flaw Reference
                InfoSection(title: "Common Logical Flaws", color: .indigo) {
                    VStack(spacing: 8) {
                        ForEach(commonFlaws) { flaw in
                            FlawRow(flaw: flaw)
                        }
                    }
                }

                // Conditional Logic
                InfoSection(title: "Conditional Logic Quick Reference", color: .indigo) {
                    VStack(spacing: 8) {
                        ForEach(conditionalRules) { rule in
                            ConditionalRow(rule: rule)
                        }
                        Text("Invalid: Affirming the consequent (A→B; B; ∴A — WRONG) and Denying the antecedent (A→B; ¬A; ∴¬B — WRONG).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, 4)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Logical Reasoning")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Data Models

private struct LRQuestionType: Identifiable {
    let id = UUID()
    let name: String
    let frequency: String
    let description: String
    let strategy: String
    let keywords: [String]
}

private struct Flaw: Identifiable {
    let id = UUID()
    let name: String
    let description: String
}

private struct ConditionalRule: Identifiable {
    let id = UUID()
    let form: String
    let meaning: String
    let contrapositive: String
}

// MARK: - Data

private let lrQuestionTypes: [LRQuestionType] = [
    LRQuestionType(name: "Assumption", frequency: "~12%", description: "Find the unstated premise the argument depends on.", strategy: "Negation Test: negate each answer. If it destroys the argument, that's the necessary assumption.", keywords: ["assumes", "relies on", "required assumption"]),
    LRQuestionType(name: "Weaken", frequency: "~12%", description: "Find the answer that most undermines the conclusion.", strategy: "Attack the Assumption: identify the gap and find an answer that shows the assumption is false or provides an alternative cause.", keywords: ["weakens", "undermines", "most seriously challenges"]),
    LRQuestionType(name: "Strengthen", frequency: "~10%", description: "Find the answer that most supports the argument.", strategy: "Fill the Gap: find an assumption, then look for an answer that confirms or supports it. New information is allowed.", keywords: ["strengthens", "most supports", "most helps justify"]),
    LRQuestionType(name: "Flaw", frequency: "~13%", description: "Identify the logical error in the argument's reasoning.", strategy: "Memorize the finite list of LSAT flaws. Pre-phrase the flaw before reading answer choices.", keywords: ["flawed because", "vulnerable to criticism", "error in reasoning"]),
    LRQuestionType(name: "Inference / Must Be True", frequency: "~11%", description: "Find what must be true based only on the stimulus.", strategy: "Stay in the Box: only use information given. Low-claim answers are safer. The correct answer is proven by the stimulus.", keywords: ["can be inferred", "most strongly supported", "must be true"]),
    LRQuestionType(name: "Main Conclusion", frequency: "~6%", description: "Identify the author's central claim.", strategy: "Why Test: ask 'Does the argument give reasons FOR this?' If yes, it could be the conclusion. The conclusion is never supported by another answer choice.", keywords: ["main point", "main conclusion", "best expresses the conclusion"]),
    LRQuestionType(name: "Parallel Reasoning", frequency: "~6%", description: "Find the answer with argument structure most similar to the stimulus.", strategy: "Abstract the Structure: convert the argument to abstract form (All A are B; X is A; X is B). Match logical form, not topic.", keywords: ["most similar in reasoning", "parallel in structure"]),
    LRQuestionType(name: "Principle (Apply/Identify)", frequency: "~8%", description: "Apply a stated principle or find a principle that justifies the reasoning.", strategy: "Treat 'justify' questions like Strengthen. Find the rule that bridges the premises and conclusion.", keywords: ["principle", "conforms to", "most helps justify"]),
    LRQuestionType(name: "Point at Issue / Agree", frequency: "~5%", description: "In a dialogue, find what the two speakers disagree (or agree) about.", strategy: "Commitment Test: both speakers must have taken a clear position. Eliminate any answer where one speaker is silent.", keywords: ["disagree about", "point at issue", "committed to disagreeing"]),
    LRQuestionType(name: "Role of Statement", frequency: "~4%", description: "Identify what function a boldfaced or specified portion plays.", strategy: "Label each boldfaced portion first: main conclusion, sub-conclusion, premise, counter-premise, or background.", keywords: ["boldface", "role", "function serves"]),
    LRQuestionType(name: "Sufficient Assumption", frequency: "~5%", description: "Find the assumption that guarantees the conclusion follows.", strategy: "Often uses formal logic. Find the conditional statement that bridges the conclusion to the premises. Contrapositive is key.", keywords: ["conclusion follows logically if", "properly drawn if", "allows the conclusion"]),
    LRQuestionType(name: "Resolve the Paradox", frequency: "~4%", description: "Explain an apparent discrepancy or paradox.", strategy: "Embrace Both Facts: the correct answer must make BOTH surprising facts true simultaneously. One-sided answers are wrong.", keywords: ["resolve", "explain the discrepancy", "reconcile"]),
]

private let commonFlaws: [Flaw] = [
    Flaw(name: "Causal Flaw", description: "Concludes A causes B merely because A correlates with B. Fix: offer alternative cause, reversed causation, or coincidence."),
    Flaw(name: "Hasty Generalization", description: "Draws a broad conclusion from an unrepresentative or too-small sample."),
    Flaw(name: "False Dichotomy", description: "Presents only two options as if no others exist. 'Either X or Y; not X; therefore Y' — ignores Z."),
    Flaw(name: "Ad Hominem", description: "Attacks the person making a claim rather than the claim itself. Doesn't make the claim false."),
    Flaw(name: "Circular Reasoning", description: "Uses the conclusion as a premise. The 'support' just restates the conclusion in different words."),
    Flaw(name: "Equivocation", description: "Uses the same word in two different senses in the same argument (e.g., 'right' as moral vs. correct)."),
    Flaw(name: "Composition", description: "What's true of a part is assumed true of the whole. 'Each player is excellent, so the team is excellent.'"),
    Flaw(name: "Division", description: "What's true of the whole is assumed true of each part. 'The company is profitable, so every department is.'"),
    Flaw(name: "Scope Shift", description: "Conclusion uses different terms than the premises establish (some → all; possible → actual)."),
    Flaw(name: "Appeal to Authority", description: "Accepts a claim solely because of who said it, without evaluating the claim itself."),
]

private let conditionalRules: [ConditionalRule] = [
    ConditionalRule(form: "If A → B", meaning: "All A are B / Whenever A, then B", contrapositive: "If ¬B → ¬A"),
    ConditionalRule(form: "A only if B", meaning: "If A → B", contrapositive: "If ¬B → ¬A"),
    ConditionalRule(form: "All A are B", meaning: "If A → B", contrapositive: "If ¬B → ¬A"),
    ConditionalRule(form: "No A are B", meaning: "If A → ¬B", contrapositive: "If B → ¬A"),
    ConditionalRule(form: "Unless B, not A", meaning: "If A → B", contrapositive: "If ¬B → ¬A"),
    ConditionalRule(form: "A unless B", meaning: "If ¬B → A", contrapositive: "If ¬A → B"),
]

// MARK: - Sub-views

private struct InfoSection<Content: View>: View {
    let title: String
    let color: Color
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(color.opacity(0.2), lineWidth: 1))
    }
}

private struct StepRow: View {
    let n: Int; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(n)").font(.caption).bold().foregroundStyle(.white)
                .frame(width: 22, height: 22)
                .background(Color.indigo, in: Circle())
            Text(text).font(.subheadline).fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct TermRow: View {
    let term: String; let detail: String
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(term).font(.subheadline).bold().foregroundStyle(.indigo)
            Text(detail).font(.caption).foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.indigo.opacity(0.05), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct QuestionTypeRow: View {
    let type: LRQuestionType
    @EnvironmentObject var progress: StudyProgress
    @State private var expanded = false

    var body: some View {
        let typeResult = progress.typeStats[type.name]

        VStack(alignment: .leading, spacing: 6) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }}) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text(type.name).font(.subheadline).bold()
                            Text(type.frequency).font(.caption).padding(.horizontal, 7).padding(.vertical, 2)
                                .background(Color.indigo.opacity(0.12), in: Capsule())
                                .foregroundStyle(.indigo)
                            if let r = typeResult, r.total > 0 {
                                TypeScorePill(result: r)
                            }
                        }
                        Text(type.description).font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down")
                        .font(.caption).foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)

            if expanded {
                VStack(alignment: .leading, spacing: 6) {
                    Label(type.strategy, systemImage: "lightbulb.fill")
                        .font(.caption).foregroundStyle(.indigo)
                        .padding(8)
                        .background(Color.indigo.opacity(0.07), in: RoundedRectangle(cornerRadius: 8))
                    HStack(spacing: 4) {
                        ForEach(type.keywords, id: \.self) { kw in
                            Text(kw).font(.caption2).italic().padding(.horizontal, 6).padding(.vertical, 2)
                                .background(.quaternary, in: Capsule())
                        }
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(10)
        .background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 10))
    }
}

private struct FlawRow: View {
    let flaw: Flaw
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(flaw.name).font(.caption).bold()
            Text(flaw.description).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.4), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct ConditionalRow: View {
    let rule: ConditionalRule
    var body: some View {
        HStack(spacing: 0) {
            Text(rule.form).font(.system(.caption, design: .monospaced)).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(rule.meaning).font(.caption).foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(rule.contrapositive).font(.system(.caption, design: .monospaced))
                .foregroundStyle(.indigo).frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
        Divider()
    }
}

// MARK: - Shared type score pill (used in LR and RC views)

struct TypeScorePill: View {
    let result: TypeResult

    private var color: Color {
        switch result.accuracyPct {
        case 80...: return .green
        case 60..<80: return .orange
        default: return .red
        }
    }

    private var indicator: String {
        result.accuracyPct >= 90 ? "⭐" : result.accuracyPct < 50 ? "⚠" : ""
    }

    var body: some View {
        HStack(spacing: 3) {
            if !indicator.isEmpty { Text(indicator).font(.system(size: 9)) }
            Text("\(result.accuracyPct)%").font(.system(size: 10, weight: .bold))
            Text("\(result.correct)/\(result.total)")
                .font(.system(size: 9)).opacity(0.75)
        }
        .padding(.horizontal, 7).padding(.vertical, 3)
        .background(color.opacity(0.13), in: Capsule())
        .foregroundStyle(color)
    }
}
