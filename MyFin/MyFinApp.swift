import SwiftUI

@main
struct MyFinApp: App {
    @StateObject private var router: AppRouter
    @StateObject private var authVM: AuthViewModel

    init() {
        // создаём всё локально, чтобы не захватывать self
        let router = AppRouter()
        let service: AuthServiceProtocol = MockAuthService()

        _router = StateObject(wrappedValue: router)
        _authVM = StateObject(wrappedValue: AuthViewModel(auth: service, router: router))
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                if router.isOnboarding {
                    OnBoardingView()
                } else {
                    WelcomeView()
                        .navigationDestination(for: Route.self, destination: destination(for:))
                }
            }
            .environmentObject(router)
            .environmentObject(authVM)
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .main:       WelcomeView()
        case .login:      LoginView()
        case .register:   RegisterView()
        case .home:       HomeView()
        case .history:    HistoryView()
        default:          EmptyView()
        }
    }
}
