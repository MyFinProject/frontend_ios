import SwiftUI

@main
struct MyFinApp: App {
    @StateObject private var router: AppRouter
    @StateObject private var authVM: AuthViewModel
    @StateObject private var homeVM: HomeViewModel
    @StateObject private var historyVM: HistoryViewModel
    @StateObject private var budgetVM: BudgetViewModel

    init() {
        let router = AppRouter()
        let authService: AuthServiceProtocol = MockAuthService()
        let walletService: WalletServiceProtocol = MockWalletService()
        let categoryService: CategoryServiceProtocol = MockCategoryService()
        let budgetService: BudgetServiceProtocol = MockBudgetService()

        _router = StateObject(wrappedValue: router)
        _authVM = StateObject(wrappedValue: AuthViewModel(auth: authService,
                                                          router: router))
        _homeVM = StateObject(wrappedValue: HomeViewModel(walletService: walletService,
                                                          authService: authService,
                                                          router: router))
        _historyVM = StateObject(wrappedValue: HistoryViewModel(walletService: walletService, authService: authService))


        _budgetVM = StateObject(wrappedValue: BudgetViewModel(budgetsService: budgetService,
                                                              categoriesService: categoryService,
                                                              authService: authService))

            
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
            .environmentObject(budgetVM)

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
                .environmentObject(historyVM)
                .environmentObject(budgetVM)
                .onAppear {
                    homeVM.onAppear()
                    budgetVM.onAppear()
                }


        case .history:
            HistoryView()
                .environmentObject(router)
                .environmentObject(authVM)
                .environmentObject(historyVM)
                .onAppear { historyVM.onAppear() }

        default:
            EmptyView()
        }
    }

}
