import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var progress: StudyProgress

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    dailyComplimentCard
                    headerCard
                    statsRow
                    sectionCards
                    studyPlan
                    resourcesList
                }
                .padding()
            }
            .navigationTitle("EddieHub 💪")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: Daily Compliment
    private var dailyComplimentCard: some View {
        let compliments: [(icon: String, text: String)] = [
            ("🏋️", "Eddie, your dedication to this exam is incredibly attractive. Ambition looks very good on you — and so do the gains."),
            ("💪", "You train harder than anyone in this gym. And somehow you're also the most charming person here. Genuinely unfair."),
            ("🖤", "Eddie, your brain is as impressive as the rest of you. Future law firms have no idea what's about to walk through the door."),
            ("🔥", "The most attractive thing about you isn't the future law degree. It's the work ethic earning it. Straight savage."),
            ("💎", "Most people quit at rep 3. You finish every set. That consistency is genuinely irresistible — and it's why you'll crush this exam."),
            ("⚡", "Eddie, the way you tackle logical reasoning? It's giving elite athlete energy. Keep repping."),
            ("🌟", "You're not just studying for a score — you're building someone even more formidable than you already are."),
            ("🖤", "The LSAT doesn't know what it's up against. No law school waitlist does either. You're the type they scramble for."),
            ("💋", "Brains, discipline, and good looks? Eddie, you're basically a cheat code. The LSAT just hasn't been patched yet."),
            ("🎯", "Every question you nail is another rep locked in. You make mastering conditional logic look effortless."),
            ("💪", "Law school is going to be lucky to have you. Almost as lucky as anyone who gets to know you."),
            ("🏆", "You answered that last question correctly before you finished reading it. That's not studying — that's elite pattern recognition."),
            ("🖤", "Confidence looks good on you, Eddie. Almost as good as that 175+ will look on your application. Almost."),
            ("🔥", "You're doing amazingly, and you were already doing amazingly before you started. That's just your baseline."),
            ("💎", "Eddie, you make reading an RC passage about 18th century maritime law look like a flex. Truly elite behavior."),
            ("⚡", "The gap between where you started and where you're going is going to be wild to look back on. Wild, and wildly impressive."),
            ("🌟", "The discipline you bring to every session is the same quality that will make you an exceptional lawyer. Non-negotiable."),
            ("🎯", "The most compelling argument in any LR section is the case you're making for yourself every single day you show up."),
            ("💋", "Somewhere out there, a law school admissions officer is about to have a very good day when they open your application."),
            ("🏋️", "Eddie, you just keep showing up and putting in reps. That alone puts you in rare company. The score will follow. It always does."),
        ]
        let idx = Int(Date().timeIntervalSince1970 / 86400) % compliments.count
        let c = compliments[idx]

        return HStack(spacing: 12) {
            Text(c.icon).font(.title2)
            VStack(alignment: .leading, spacing: 2) {
                Text("Daily Pump-Up")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white.opacity(0.6))
                    .textCase(.uppercase)
                    .kerning(0.8)
                Text(c.text)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 16).padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black, in: RoundedRectangle(cornerRadius: 14))
    }

    // MARK: Header
    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Back in the gym, Eddie 💪")
                    .font(.title2).bold()
                Text(Date().formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("Target").font(.caption).foregroundStyle(.white.opacity(0.8))
                Text("\(progress.targetScore)").font(.title).bold().foregroundStyle(.white)
                Text("/ 180").font(.caption).foregroundStyle(.white.opacity(0.8))
            }
            .padding(.horizontal, 16).padding(.vertical, 10)
            .background(Color.black, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(label: "LR", value: progress.accuracyString(for: .lr), color: .indigo)
            StatCard(label: "RC", value: progress.accuracyString(for: .rc), color: .orange)
            StatCard(label: "Reps", value: "\(progress.totalAttempted)", color: .gray)
        }
    }

    // MARK: Section Cards
    private var sectionCards: some View {
        VStack(spacing: 12) {
            // August 2024 format notice
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill").foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 2) {
                    Text("August 2024 Format Update").font(.caption).bold().foregroundStyle(.blue)
                    Text("Logic Games has been permanently removed. The LSAT is now 2 LR sections + 1 RC section.")
                        .font(.caption2).foregroundStyle(Color(red: 0.12, green: 0.25, blue: 0.7))
                }
            }
            .padding(10)
            .background(Color.blue.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue.opacity(0.2), lineWidth: 1))

            NavigationLink(destination: LogicalReasoningView()) {
                SectionCard(
                    title: "Logical Reasoning",
                    subtitle: "~65% of exam · 2 scored sections · The Main Lift",
                    description: "Your bench press — the core movement. Two LR sections of 24–26 questions each. Win here, win the exam.",
                    chips: ["Flaw", "Assumption", "Strengthen", "Inference"],
                    color: .indigo
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: ReadingCompView()) {
                SectionCard(
                    title: "Reading Comprehension",
                    subtitle: "~35% of exam · 1 scored section · Accessory Work",
                    description: "The accessory lift that rounds out your score. One RC section with 4 passages (~27 questions). Build reading endurance.",
                    chips: ["Main Point", "Inference", "Author's Tone", "Comparative"],
                    color: .orange
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: LogicGamesView()) {
                SectionCard(
                    title: "Logic Games — Archive 📦",
                    subtitle: "Decommissioned August 2024",
                    description: "LSAC retired this exercise from the program. Guide preserved for historical reference only.",
                    chips: ["Removed", "Pre-Aug 2024"],
                    color: .gray
                )
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: Study Plan
    private var studyPlan: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Training Program").font(.headline)
            HStack(spacing: 12) {
                ForEach(Phase.allCases) { phase in
                    PhaseCard(phase: phase)
                }
            }
        }
    }

    // MARK: Resources
    private var resourcesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Approved Resources").font(.headline)
            VStack(spacing: 8) {
                ResourceRow(name: "LSAC LawHub", detail: "Official PrepTests — the barbells of LSAT prep. No substitute.", badge: "Official", badgeColor: .orange)
                ResourceRow(name: "The LSAT Trainer", detail: "Mike Kim's book. Best third-party coaching resource.", badge: "Top Pick", badgeColor: .indigo)
                ResourceRow(name: "PowerScore Bibles", detail: "LR, LG, RC Bibles for athletes who want full theoretical depth.", badge: "Recommended", badgeColor: .indigo)
                ResourceRow(name: "7Sage LSAT", detail: "Best video coaching for every PrepTest question.", badge: "Recommended", badgeColor: .indigo)
            }
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Supporting Views

private struct StatCard: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption2).bold()
                .foregroundStyle(color)
                .padding(.horizontal, 8).padding(.vertical, 3)
                .background(color.opacity(0.12), in: Capsule())
            Text(value).font(.title3).bold()
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(.separator, lineWidth: 0.5))
    }
}

private struct SectionCard: View {
    let title: String
    let subtitle: String
    let description: String
    let chips: [String]
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).font(.headline)
                    Text(subtitle).font(.caption).foregroundStyle(color)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.tertiary)
            }
            Text(description).font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 6) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip)
                        .font(.caption2).bold()
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(color.opacity(0.1), in: Capsule())
                        .foregroundStyle(color)
                }
            }
        }
        .padding()
        .background(.background, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Study Phase

private enum Phase: Int, CaseIterable, Identifiable {
    case foundation = 1, building, simulation
    var id: Int { rawValue }
    var title: String {
        switch self { case .foundation: return "Base Training"; case .building: return "Prog. Overload"; case .simulation: return "Competition" }
    }
    var weeks: String {
        switch self { case .foundation: return "Wks 1–4"; case .building: return "Wks 5–8"; case .simulation: return "Wks 9–12" }
    }
    var icon: String {
        switch self { case .foundation: return "1.square.fill"; case .building: return "2.square.fill"; case .simulation: return "3.square.fill" }
    }
}

private struct PhaseCard: View {
    let phase: Phase
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: phase.icon).foregroundStyle(.primary).font(.title3)
            Text(phase.title).font(.caption).bold()
            Text(phase.weeks).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.background, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.separator, lineWidth: 0.5))
    }
}

private struct ResourceRow: View {
    let name: String
    let detail: String
    let badge: String
    let badgeColor: Color
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(name).font(.subheadline).bold()
                Text(detail).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text(badge)
                .font(.caption2).bold()
                .padding(.horizontal, 7).padding(.vertical, 3)
                .background(badgeColor.opacity(0.12), in: Capsule())
                .foregroundStyle(badgeColor)
        }
        .padding(12)
        .background(.background, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.separator, lineWidth: 0.5))
    }
}
