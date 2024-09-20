
import SwiftUI

@main
struct ios_ac_remote_controlApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(HomeViewModel.viewModel)
        }
    }
}
