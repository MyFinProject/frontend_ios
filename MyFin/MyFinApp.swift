import SwiftUI

@main
struct MyFinApp: App {
    @StateObject private var router = AppRouter()  // @StateObject для ObservableObject

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                if router.isOnboarding {
                    OnBoardingView()
                        .environmentObject(router)  // .environmentObject для ObservableObject
                } else {
                    RootView()
                        .navigationDestination(for: Route.self) { route in
                            destination(for: route)
                        }
                }
            }
            .navigationBarBackButtonHidden(true)
            .environmentObject(router)  // Глобально
            .sheet(item: $router.presentedSheet) { route in
                if route == .logoutConfirm {
                    LogoutConfirmView()
                        .environmentObject(router)
                }
            }
        }
    }

    @ViewBuilder
    private func RootView() -> some View {
        if router.path.isEmpty {
            WelcomeView()
                .environmentObject(router)
        }
    }

    @ViewBuilder
    private func destination(for route: Route) -> some View {
        switch route {
        case .main: WelcomeView().environmentObject(router)
        case .login: LoginView().environmentObject(router)
        case .register: RegisterView().environmentObject(router)
        case .home: HomeView().environmentObject(router)
        case .history: HistoryView().environmentObject(router)
        //case .walletCreate: WalletCreateView().environmentObject(router)
        default: EmptyView()
        }
    }
}

//#Preview {
//    MyFinApp()
//}
