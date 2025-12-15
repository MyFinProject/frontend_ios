struct Transaction: Codable, Identifiable {
    let id: String
    let amount: Double
    let description: String
    let date: String
    let typeOperation: Int
    let walletId: String

    var isIncome: Bool {
        return typeOperation == 3
    }

    var isExpense: Bool {
        return typeOperation == 1
    }
}
