import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Dashboard", systemImage: "house.fill") }

            StudyGuideView()
                .tabItem { Label("Study", systemImage: "book.fill") }

            PracticeView()
                .tabItem { Label("Practice", systemImage: "pencil.circle.fill") }

            ProgressDashboardView()
                .tabItem { Label("Progress", systemImage: "chart.bar.fill") }
        }
        .tint(.primary)
    }
}
