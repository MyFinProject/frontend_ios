import SwiftUI

@main
struct MyFinApp: App {
    @StateObject private var router: AppRouter
    @StateObject private var authVM: AuthViewModel
    @StateObject private var homeVM: HomeViewModel
    @StateObject private var historyVM: HistoryViewModel

    init() {
        // создаём всё локально, чтобы не захватывать self
        let router = AppRouter()
        let authService: AuthServiceProtocol = MockAuthService()
        let walletService: WalletServiceProtocol = MockWalletService()

        _router = StateObject(wrappedValue: router)
        _authVM = StateObject(wrappedValue: AuthViewModel(auth: authService, router: router))
        _homeVM = StateObject(wrappedValue: HomeViewModel(walletService: walletService, authService: authService, router: router))
        _historyVM = StateObject(wrappedValue: HistoryViewModel(walletService: walletService, authService: authService))
            
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
        case .main:
            WelcomeView()
                .environmentObject(router)
                .environmentObject(authVM)

        case .login:
            LoginView()
                .environmentObject(router)
                .environmentObject(authVM)

        case .register:
            RegisterView()
                .environmentObject(router)
                .environmentObject(authVM)

        case .home:
            HomeView()
                .environmentObject(router)
                .environmentObject(authVM)
                .environmentObject(homeVM)
                .environmentObject(historyVM)   // ← важно
                .onAppear { homeVM.onAppear() }

        case .history:
            HistoryView()
                .environmentObject(router)
                .environmentObject(authVM)
                .environmentObject(historyVM)     // ← важно
                .onAppear { historyVM.onAppear() }

        default:
            EmptyView()
        }
    }

}
