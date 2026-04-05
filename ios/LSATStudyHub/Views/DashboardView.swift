import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var progress: StudyProgress

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerCard
                    statsRow
                    sectionCards
                    studyPlan
                    resourcesList
                }
                .padding()
            }
            .navigationTitle("LSAT Study Hub")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: Header
    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Welcome, Eddie")
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
            .background(Color.indigo, in: RoundedRectangle(cornerRadius: 12))
        }
    }

    // MARK: Stats Row
    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(label: "LR", value: progress.accuracyString(for: .lr), color: .indigo)
            StatCard(label: "RC", value: progress.accuracyString(for: .rc), color: .orange)
            StatCard(label: "Done", value: "\(progress.totalAttempted)", color: .gray)
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
                    subtitle: "~65% of exam · 2 scored sections",
                    description: "The dominant section — two LR sections of 24–26 questions each. Master argument analysis, flaw identification, assumptions, and inferences.",
                    chips: ["Flaw", "Assumption", "Strengthen", "Inference"],
                    color: .indigo
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: ReadingCompView()) {
                SectionCard(
                    title: "Reading Comprehension",
                    subtitle: "~35% of exam · 1 scored section",
                    description: "Active reading, passage mapping, and question-type strategies for dense academic texts.",
                    chips: ["Main Point", "Inference", "Author's Tone", "Comparative"],
                    color: .orange
                )
            }
            .buttonStyle(.plain)

            NavigationLink(destination: LogicGamesView()) {
                SectionCard(
                    title: "Logic Games — Archive",
                    subtitle: "Removed August 2024",
                    description: "Analytical Reasoning was permanently eliminated from the LSAT. This guide is for historical reference only.",
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
            Text("Study Strategy").font(.headline)
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
                ResourceRow(name: "LSAC LawHub", detail: "Official PrepTests — the only real LSAT questions.", badge: "Official", badgeColor: .orange)
                ResourceRow(name: "The LSAT Trainer", detail: "Mike Kim's book. Best third-party prep resource.", badge: "Top Pick", badgeColor: .indigo)
                ResourceRow(name: "PowerScore Bibles", detail: "LR, LG, RC Bibles for comprehensive theory coverage.", badge: "Recommended", badgeColor: .indigo)
                ResourceRow(name: "7Sage LSAT", detail: "Best-in-class Logic Games video curriculum.", badge: "Recommended", badgeColor: .indigo)
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
        switch self { case .foundation: return "Foundation"; case .building: return "Skill Building"; case .simulation: return "Test Sim" }
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
            Image(systemName: phase.icon).foregroundStyle(.indigo).font(.title3)
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
