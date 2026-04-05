import SwiftUI

struct StudyGuideView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: LogicalReasoningView()) {
                        StudyRow(title: "Logical Reasoning", subtitle: "12 question types · Flaws · Conditional logic", icon: "brain.head.profile", color: .indigo)
                    }
                    NavigationLink(destination: LogicGamesView()) {
                        StudyRow(title: "Logic Games", subtitle: "6 game types · Rule symbolization · Strategies", icon: "square.grid.3x3.fill", color: .green)
                    }
                    NavigationLink(destination: ReadingCompView()) {
                        StudyRow(title: "Reading Comprehension", subtitle: "Passage mapping · 9 question types · Wrong answer traps", icon: "doc.text.fill", color: .orange)
                    }
                } header: {
                    Text("Section Guides")
                }

                Section {
                    InfoRow(label: "Exam Format", value: "2 LR · 1 LG · 1 RC (scored)")
                    InfoRow(label: "Total Questions", value: "~101 scored")
                    InfoRow(label: "Time per Section", value: "35 minutes")
                    InfoRow(label: "Score Range", value: "120–180")
                    InfoRow(label: "Writing Sample", value: "Unscored, sent to schools")
                } header: {
                    Text("LSAT At a Glance")
                }

                Section {
                    InfoRow(label: "Logical Reasoning", value: "~50% (2 sections)")
                    InfoRow(label: "Analytical Reasoning", value: "~23% (1 section)")
                    InfoRow(label: "Reading Comprehension", value: "~27% (1 section)")
                } header: {
                    Text("Score Weighting")
                }
            }
            .navigationTitle("Study Guide")
        }
    }
}

private struct StudyRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    var body: some View {
        HStack {
            Text(label).foregroundStyle(.primary)
            Spacer()
            Text(value).foregroundStyle(.secondary)
        }
    }
}
