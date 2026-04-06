import SwiftUI

struct ReadingCompView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Format notice
                HStack(spacing: 10) {
                    Image(systemName: "info.circle.fill").foregroundStyle(.blue)
                    Text("Aug 2024+ Format: RC is now ~35% of your score (1 scored section, ~27 questions). Logic Games was removed — RC is the second most important section after LR.")
                        .font(.caption)
                }
                .padding(10)
                .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)

                rcSection(title: "The RC Method: Active Passage Mapping") {
                    VStack(alignment: .leading, spacing: 8) {
                        StepRow(n: 1, text: "Read for structure, not details. Understand the author's argument, not every fact.")
                        StepRow(n: 2, text: "Mark each paragraph's function in 3–5 words before moving on.")
                        StepRow(n: 3, text: "Track viewpoints: tag the author's view vs. views being described or critiqued.")
                        StepRow(n: 4, text: "Note tone words — 'however,' 'unfortunately,' 'mistakenly' reveal the author's stance.")
                        StepRow(n: 5, text: "Identify the main point before answering any questions.")
                        StepRow(n: 6, text: "Return to the passage for detail questions — never answer from memory alone.")
                    }
                }

                rcSection(title: "Passage Subject Areas") {
                    VStack(spacing: 8) {
                        ForEach(passageTypes) { pt in PassageTypeRow(type: pt) }
                    }
                }

                rcSection(title: "Time Management") {
                    VStack(alignment: .leading, spacing: 6) {
                        BulletRow(text: "Target ~8 min per passage (3–4 min reading, 4–5 min questions).")
                        BulletRow(text: "Comparative reading (2 short passages) may go faster — fewer questions.")
                        BulletRow(text: "On very dense passages, answer global questions first.")
                        BulletRow(text: "Never spend >90 seconds on a single question. Skip and return.")
                    }
                }

                rcSection(title: "Viewpoint Tracking System") {
                    VStack(alignment: .leading, spacing: 6) {
                        AnnotationRow(tag: "A", desc: "Author's own view or conclusion")
                        AnnotationRow(tag: "V1/V2", desc: "Other views the author is describing")
                        AnnotationRow(tag: "C", desc: "Critic or opposing view")
                        Text("Note explicitly when the author agrees or disagrees with a presented view.")
                            .font(.caption).foregroundStyle(.secondary).padding(.top, 4)
                    }
                }

                rcSection(title: "Question Type Reference") {
                    VStack(spacing: 8) {
                        ForEach(rcQuestionTypes) { qt in RCQuestionRow(type: qt) }
                    }
                }

                rcSection(title: "Wrong Answer Patterns") {
                    VStack(spacing: 6) {
                        ForEach(wrongAnswerTypes) { wa in WrongAnswerRow(type: wa) }
                    }
                }

                rcSection(title: "How to Improve RC") {
                    VStack(spacing: 8) {
                        ForEach(improvementTips) { tip in TipRow(tip: tip) }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Reading Comp")
        .navigationBarTitleDisplayMode(.large)
    }

    @ViewBuilder
    private func rcSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline)
            content()
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.orange.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Data

private struct PassageType: Identifiable {
    let id = UUID(); let name: String; let description: String
}
private struct RCQuestionType: Identifiable {
    let id = UUID(); let name: String; let stem: String; let strategy: String
}
private struct WrongAnswerType: Identifiable {
    let id = UUID(); let name: String; let description: String
}
private struct ImprovementTip: Identifiable {
    let id = UUID(); let title: String; let body: String
}

private let passageTypes: [PassageType] = [
    PassageType(name: "Law / Legal Theory", description: "Appellate rulings, constitutional history, jurisprudence. Focus on what the ruling held and why."),
    PassageType(name: "Natural Science", description: "Biology, physics, geology. Usually descriptive with a research finding or theory debate. Note what is known vs. hypothesized."),
    PassageType(name: "Social Science", description: "Economics, psychology, sociology. Often presents a theory and an opposing view. Track who believes what."),
    PassageType(name: "Humanities", description: "History, literary criticism, art. Strongly opinion-driven — the author has a clear point of view. Author's tone is critical."),
    PassageType(name: "Comparative Reading", description: "Two shorter passages on related topics. Questions ask about relationship, agreement, disagreement, or structure between the two."),
]

private let rcQuestionTypes: [RCQuestionType] = [
    RCQuestionType(name: "Main Point / Primary Purpose", stem: "The main point of the passage is...", strategy: "Must encompass the ENTIRE passage. Too narrow = single paragraph. Too broad = beyond the passage. Match tone exactly."),
    RCQuestionType(name: "Author's Attitude / Tone", stem: "The author's attitude toward X can best be described as...", strategy: "Find tone words in the passage. Extreme answers (contempt, enthusiastic praise) are usually wrong. Match degree of positivity/negativity."),
    RCQuestionType(name: "Detail / Specific Information", stem: "According to the passage...", strategy: "Return to the passage — never answer from memory. Answer must be directly stated or paraphrased, not inferred."),
    RCQuestionType(name: "Inference", stem: "The passage most strongly suggests...", strategy: "One logical step beyond what's written. Correct answer is proven by the passage but not explicitly stated. No outside knowledge."),
    RCQuestionType(name: "Organization / Structure", stem: "Which best describes the organization of the passage?", strategy: "Use your passage map. Answers describe the passage at the paragraph level. Match the logical flow."),
    RCQuestionType(name: "Function of Paragraph / Phrase", stem: "The second paragraph serves primarily to...", strategy: "Ask: 'Why did the author include this?' — to provide evidence, introduce counterargument, illustrate, qualify, etc."),
    RCQuestionType(name: "Analogy / Parallel Structure", stem: "Which situation is most analogous to lines X–Y?", strategy: "Abstract the key relationship, then find the answer with the same relationship — not just the same topic."),
    RCQuestionType(name: "Comparative (Passage A vs. B)", stem: "Both passages agree that... / Unlike Passage A, Passage B...", strategy: "Commitment Test: both passages must have taken a clear position on the topic to count as agreement or disagreement."),
]

private let wrongAnswerTypes: [WrongAnswerType] = [
    WrongAnswerType(name: "Out of Scope", description: "Introduces information or concepts not mentioned in the passage. Very common on inference questions."),
    WrongAnswerType(name: "Too Extreme", description: "Uses absolute language (always, never, all, only) when the passage was more moderate. Check for hedging."),
    WrongAnswerType(name: "Opposite / Reversal", description: "States the exact opposite of what the passage says. Common on tone and author-agrees questions."),
    WrongAnswerType(name: "Too Narrow", description: "Describes only a single paragraph or detail rather than the whole passage. Common trap on main point questions."),
    WrongAnswerType(name: "Distortion", description: "Takes a real element from the passage but misrepresents it — overstates or twists the author's meaning."),
    WrongAnswerType(name: "True but Irrelevant", description: "Accurate according to the passage but doesn't answer the specific question asked. A common lure."),
]

private let improvementTips: [ImprovementTip] = [
    ImprovementTip(title: "Daily Active Reading", body: "Read The Economist, law review summaries, or scientific journals. Practice mapping structure while reading."),
    ImprovementTip(title: "Blind Review", body: "After a timed section, revisit every question you weren't 100% certain about with unlimited time. This reveals systematic errors."),
    ImprovementTip(title: "Low-Res Summary Drill", body: "After each paragraph, write a 5-word summary. After the passage, write a one-sentence main point. Verify against the correct answer."),
    ImprovementTip(title: "Wrong Answer Analysis", body: "For every wrong answer, categorize why it was wrong (out of scope, too extreme, etc.). Tracking patterns reveals your weaknesses."),
]

// MARK: - Sub-views

private struct StepRow: View {
    let n: Int; let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Text("\(n)").font(.caption).bold().foregroundStyle(.white)
                .frame(width: 22, height: 22).background(Color.orange, in: Circle())
            Text(text).font(.subheadline).fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct PassageTypeRow: View {
    let type: PassageType
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(type.name).font(.caption).bold().foregroundStyle(.orange)
            Text(type.description).font(.caption).foregroundStyle(.secondary)
        }
        .padding(8).background(Color.orange.opacity(0.06), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct BulletRow: View {
    let text: String
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•").foregroundStyle(.orange)
            Text(text).font(.subheadline)
        }
    }
}

private struct AnnotationRow: View {
    let tag: String; let desc: String
    var body: some View {
        HStack(spacing: 12) {
            Text(tag).font(.system(.caption, design: .monospaced)).bold()
                .frame(minWidth: 36).padding(.vertical, 4).padding(.horizontal, 6)
                .background(Color.orange.opacity(0.12), in: RoundedRectangle(cornerRadius: 6))
                .foregroundStyle(.orange)
            Text(desc).font(.caption).foregroundStyle(.secondary)
        }
    }
}

private struct RCQuestionRow: View {
    let type: RCQuestionType
    @EnvironmentObject var progress: StudyProgress
    @State private var expanded = false

    var body: some View {
        let typeResult = progress.typeStats[type.name]

        VStack(alignment: .leading, spacing: 4) {
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() }}) {
                HStack {
                    HStack(spacing: 6) {
                        Text(type.name).font(.caption).bold()
                        if let r = typeResult, r.total > 0 {
                            TypeScorePill(result: r)
                        }
                    }
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").font(.caption).foregroundStyle(.secondary)
                }
            }
            .buttonStyle(.plain)
            if expanded {
                VStack(alignment: .leading, spacing: 4) {
                    Text(type.stem).font(.caption).italic().foregroundStyle(.secondary)
                    Text(type.strategy).font(.caption)
                        .padding(6).background(Color.orange.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(8).background(.quaternary.opacity(0.3), in: RoundedRectangle(cornerRadius: 8))
    }
}

private struct WrongAnswerRow: View {
    let type: WrongAnswerType
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "xmark.circle.fill").foregroundStyle(.red).font(.caption)
            VStack(alignment: .leading, spacing: 1) {
                Text(type.name).font(.caption).bold()
                Text(type.description).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}

private struct TipRow: View {
    let tip: ImprovementTip
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "arrow.up.circle.fill").foregroundStyle(.orange).font(.subheadline)
            VStack(alignment: .leading, spacing: 2) {
                Text(tip.title).font(.caption).bold()
                Text(tip.body).font(.caption).foregroundStyle(.secondary)
            }
        }
    }
}
