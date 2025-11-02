import Foundation

// MARK: - Protocol

protocol WalletServiceProtocol: AnyObject {
    func fetchWallets(for userId: String) async throws -> [Wallet]
    func createWallet(_ request: CreateWalletRequest, userId: String) async throws -> Wallet

    /// Если walletId == nil — вернём все транзакции пользователя
    func fetchTransactions(for walletId: String?, userId: String) async throws -> [Transaction]
    func addTransaction(_ tx: Transaction, userId: String) async throws -> Transaction
}

// MARK: - Mock

final class MockWalletService: WalletServiceProtocol {

    private func simulateDelay() async { try? await Task.sleep(nanoseconds: 300_000_000) }

    private var walletsByUser: [String: [Wallet]] = [:]
    private var transactionsByUser: [String: [Transaction]] = [:]

    init() {
        seed(userId: "u_demo_1")
        seed(userId: "u_demo_2")
    }

    private func seed(userId: String) {
        let w1 = Wallet(walletId: "w_\(userId)_1", name: "Кошелёк", balance: 8500, currencieId: 840, icon: "wallet.pass")
        let w2 = Wallet(walletId: "w_\(userId)_2", name: "Карта", balance: 120_000, currencieId: 840, icon: "creditcard")
        walletsByUser[userId] = [w1, w2]

        let txs: [Transaction] = [
            Transaction(id: "t_\(userId)_1", amount: 5_000, description: "Зарплата", date: "2025-10-01", typeOperation: 3, walletId: w2.walletId),
            Transaction(id: "t_\(userId)_2", amount: 1_200, description: "Продукты", date: "2025-10-02", typeOperation: 1, walletId: w2.walletId),
            Transaction(id: "t_\(userId)_3", amount: 900, description: "Такси", date: "2025-10-03", typeOperation: 1, walletId: w1.walletId),
            Transaction(id: "t_\(userId)_4", amount: 2_000, description: "Фриланс", date: "2025-10-04", typeOperation: 3, walletId: w1.walletId),
        ]
        transactionsByUser[userId] = txs
    }

    func fetchWallets(for userId: String) async throws -> [Wallet] {
        await simulateDelay()
        return walletsByUser[userId] ?? []
    }

    func createWallet(_ request: CreateWalletRequest, userId: String) async throws -> Wallet {
        await simulateDelay()
        let wallet = Wallet(walletId: UUID().uuidString,
                            name: request.name,
                            balance: request.balance,
                            currencieId: request.currencieId,
                            icon: request.icon)
        walletsByUser[userId, default: []].append(wallet)
        return wallet
    }

    func fetchTransactions(for walletId: String?, userId: String) async throws -> [Transaction] {
        await simulateDelay()
        let all = transactionsByUser[userId] ?? []
        guard let walletId else { return all }
        return all.filter { $0.walletId == walletId }
    }

    func addTransaction(_ tx: Transaction, userId: String) async throws -> Transaction {
        await simulateDelay()
        transactionsByUser[userId, default: []].append(tx)
        // Обновим баланс кошелька «на лету»
        if var arr = walletsByUser[userId],
           let idx = arr.firstIndex(where: { $0.walletId == tx.walletId }) {
            var w = arr[idx]
            let delta = (tx.typeOperation == 3 ? +tx.amount : -tx.amount)
            let new = Wallet(walletId: w.walletId, name: w.name,
                             balance: w.balance + delta,
                             currencieId: w.currencieId, icon: w.icon)
            arr[idx] = new
            walletsByUser[userId] = arr
        }
        return tx
    }
}
