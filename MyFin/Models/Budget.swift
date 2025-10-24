
struct Budget: Codable, Identifiable {
    let budgetId: String
    let name: String
    let amount: Double
    let currencyId: Int
    let categoryId: String
    let userId: String
    
    var id: String { budgetId }
}

struct CreateBudgetRequest: Codable {
    let userId: String
    let categoryId: String
    let amount: Double
    let currencyId: Int
    let name: String
}
