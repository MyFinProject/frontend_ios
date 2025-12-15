import Foundation

enum WalletServiceError: LocalizedError {
    case walletNotFound

    var errorDescription: String? {
        switch self {
        case .walletNotFound:
            return "Кошелёк не найден"
        }
    }
}

// MARK: - Protocol

protocol WalletServiceProtocol: AnyObject {
    func fetchWallets(for userId: String) async throws -> [Wallet]
    func createWallet(_ request: CreateWalletRequest, userId: String) async throws -> Wallet
    func fetchTransactions(for walletId: String?, userId: String) async throws -> [Transaction]
    func addTransaction(_ tx: Transaction, userId: String) async throws -> Transaction
    func deleteWallet(walletId: String, userId: String) async throws
}


final class MockWalletService: WalletServiceProtocol {

    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 300_000_000)
    }

    private var walletsByUser: [String: [Wallet]] = [:]
    private var transactionsByUser: [String: [Transaction]] = [:]

    init() {
        seed(userId: "u_demo_1")
    }

    private func seed(userId: String) {
        let w1 = Wallet(walletId: "wallet_1",
                        name: "Кошелёк",
                        balance: 9_000,
                        currencieId: 0,
                        icon: nil)

        walletsByUser[userId] = [w1]

        let txs: [Transaction] = [
            Transaction(id: "tx_1",
                        amount: 1_000,
                        description: "Еда",
                        date: "2025-10-01",
                        typeOperation: 1,
                        walletId: w1.walletId)
        ]
        transactionsByUser[userId] = txs
    }


    func fetchWallets(for userId: String) async throws -> [Wallet] {
        await simulateDelay()
        return walletsByUser[userId] ?? []
    }

    func createWallet(_ request: CreateWalletRequest, userId: String) async throws -> Wallet {
        await simulateDelay()

        let wallet = Wallet(
            walletId: UUID().uuidString,
            name: request.name,
            balance: request.balance,
            currencieId: request.currencieId,
            icon: request.icon
        )

        walletsByUser[userId, default: []].append(wallet)
        return wallet
    }

    func deleteWallet(walletId: String, userId: String) async throws {
        await simulateDelay()

        guard var wallets = walletsByUser[userId],
              let index = wallets.firstIndex(where: { $0.walletId == walletId }) else {
            throw WalletServiceError.walletNotFound
        }

        wallets.remove(at: index)
        walletsByUser[userId] = wallets

        if var txs = transactionsByUser[userId] {
            txs.removeAll { $0.walletId == walletId }
            transactionsByUser[userId] = txs
        }
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

        if var arr = walletsByUser[userId],
           let idx = arr.firstIndex(where: { $0.walletId == tx.walletId }) {

            let w = arr[idx]
            let delta = (tx.typeOperation == 3 ? +tx.amount : -tx.amount)

            let newWallet = Wallet(
                walletId: w.walletId,
                name: w.name,
                balance: w.balance + delta,
                currencieId: w.currencieId,
                icon: w.icon
            )

            arr[idx] = newWallet
            walletsByUser[userId] = arr
        }

        return tx
    }
}
