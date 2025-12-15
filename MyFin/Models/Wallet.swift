struct Wallet: Codable, Identifiable {
    let walletId: String
    let name: String
    let balance: Double
    let currencieId: Int
    let icon: String?

    var id: String { walletId }
}

struct CreateWalletRequest: Codable {
    let name: String
    let balance: Double
    let currencieId: Int
    let icon: String?
}
