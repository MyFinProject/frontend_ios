import Foundation
import Combine

enum TransactionFilter { case all, income, expense }

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published private(set) var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var selectedWalletId: String?

    @Published var selectedWalletName: String = ""
    @Published var selectedWalletBalance: Double = 0

    @Published var filter: TransactionFilter = .all
    var visibleTransactions: [Transaction] {
        switch filter {
        case .all:     return transactions
        case .income:  return transactions.filter { $0.typeOperation == 3 }
        case .expense: return transactions.filter { $0.typeOperation == 1 }
        }
    }

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
                try await updateSelectedWalletHeader(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func updateSelectedWalletHeader(userId: String) async throws {
        let wallets = try await walletService.fetchWallets(for: userId)
        if let id = selectedWalletId,
           let w = wallets.first(where: { $0.walletId == id }) {
            selectedWalletName = w.name
            selectedWalletBalance = w.balance
        } else {
            selectedWalletName = ""
            selectedWalletBalance = 0
        }
    }

    func addTransaction(amount: Double, description: String, isIncome: Bool) {
        let userId = authService.currentUser?.userId ?? "u_demo_1"
        guard let walletId = selectedWalletId else { return }
        Task {
            do {
                let tx = Transaction(
                    id: UUID().uuidString,
                    amount: amount,
                    description: description,
                    date: ISO8601DateFormatter().string(from: Date()),
                    typeOperation: isIncome ? 3 : 1,
                    walletId: walletId
                )
                _ = try await walletService.addTransaction(tx, userId: userId)
                transactions = try await walletService.fetchTransactions(for: selectedWalletId, userId: userId)
                try await updateSelectedWalletHeader(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func toggleFilter(_ newFilter: TransactionFilter) {
        filter = (filter == newFilter) ? .all : newFilter
    }
    func clearFilter() { filter = .all }
}
