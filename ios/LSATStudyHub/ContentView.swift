import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }

            StudyGuideView()
                .tabItem { Label("Workout", systemImage: "book.fill") }

            PracticeView()
                .tabItem { Label("Train", systemImage: "dumbbell.fill") }

            ProgressDashboardView()
                .tabItem { Label("Gains", systemImage: "chart.bar.fill") }
        }
        .tint(.primary)
    }
}
