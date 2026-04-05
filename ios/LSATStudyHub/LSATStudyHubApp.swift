import SwiftUI

@main
struct LSATStudyHubApp: App {
    @StateObject private var progress = StudyProgress()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(progress)
        }
    }
}
