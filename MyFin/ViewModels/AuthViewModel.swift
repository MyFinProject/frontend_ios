import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var username: String = "" 

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let auth: AuthServiceProtocol
    private let router: AppRouter

    init(auth: AuthServiceProtocol, router: AppRouter) {
        self.auth = auth
        self.router = router
    }


    func login() {
        errorMessage = nil
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                _ = try await auth.login(email: email, password: password)
                router.performLogin()
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    func register() {
        errorMessage = nil
        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let req = RegisterRequest(username: username, email: email, password: password)
                _ = try await auth.register(req)
                router.performRegister()
            } catch {
                errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
            }
        }
    }

    func logout() {
        Task {
            await auth.logout()
            router.performLogout()
        }
    }
}
