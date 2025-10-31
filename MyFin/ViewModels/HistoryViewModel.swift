import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // ⬇️ сюда будем записывать выбранный кошелёк
    @Published var selectedWalletId: String?

    private let walletService: WalletServiceProtocol
    private let authService: AuthServiceProtocol

    init(walletService: WalletServiceProtocol,
         authService: AuthServiceProtocol) {
        self.walletService = walletService
        self.authService = authService
    }

    func onAppear() { load() }

    func load() {
        let userId = authService.currentUser?.userId ?? "u_demo_1"
        isLoading = true
        errorMessage = nil
        Task {
            defer { isLoading = false }
            do {
                // ⬇️ если selectedWalletId == nil — загрузим все, иначе фильтр по кошельку
                transactions = try await walletService.fetchTransactions(for: selectedWalletId, userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
