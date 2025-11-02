import Foundation
import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

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
                transactions = try await walletService.fetchTransactions(for: selectedWalletId, userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
