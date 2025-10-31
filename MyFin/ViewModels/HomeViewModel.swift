import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var wallets: [Wallet] = []
    @Published var totalBalance: Double = 0
    @Published var incomeTotal: Double = 0
    @Published var expenseTotal: Double = 0
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let walletService: WalletServiceProtocol
    private let authService: AuthServiceProtocol
    private let router: AppRouter

    init(walletService: WalletServiceProtocol,
         authService: AuthServiceProtocol,
         router: AppRouter) {
        self.walletService = walletService
        self.authService = authService
        self.router = router
    }

    func onAppear() { load() }

    func load() {
        let userId = authService.currentUser?.userId ?? "u_demo_1"
        isLoading = true
        errorMessage = nil

        Task {
            defer { isLoading = false }
            do {
                let wallets = try await walletService.fetchWallets(for: userId)
                self.wallets = wallets
                await recomputeTotals(userId: userId) // ⬅︎ без throws
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }

    /// Пересчитываем суммы. Ошибки ловим внутри, чтобы не плодить `throws`.
    private func recomputeTotals(userId: String) async {
        do {
            let txs = try await walletService.fetchTransactions(for: nil, userId: userId)
            // В твоей модели есть вычисляемые флаги isIncome / isExpense
            incomeTotal  = txs.filter { $0.isIncome  }.map(\.amount).reduce(0, +)
            expenseTotal = txs.filter { $0.isExpense }.map(\.amount).reduce(0, +)
            totalBalance = wallets.map(\.balance).reduce(0, +)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // Навигация
    func openHistory() { router.showHistory() }

    // Логаут
    func logout() {
        Task {
            await authService.logout()
            router.performLogout()
        }
    }
}
