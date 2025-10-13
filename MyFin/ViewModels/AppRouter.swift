import SwiftUI
import Combine

@MainActor
class AppRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Route? = nil
    @Published var isOnboarding = true

    func push(_ route: Route) {
        path.append(route)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func showLogin() {
        popToRoot()
        push(.login)
    }

    func showRegistration() {
        popToRoot()
        push(.register)
    }

    func showMain() {
        popToRoot()
        push(.main)
    }

    func showHome() {
        popToRoot()
        push(.home)
    }

    func showHistory() {
        push(.history)
    }

    func showWalletCreate() {
        push(.walletCreate)
    }

    func showLogoutConfirm() {
        presentedSheet = .logoutConfirm
    }

    func performLogin() {
        showHome()
    }

    func performRegister() {
        showHome()
    }

    func performLogout() {
        popToRoot()
        showMain()
    }

    func completeOnboarding() {
        isOnboarding = false
        showMain()
    }
}
