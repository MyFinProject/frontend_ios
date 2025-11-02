import Foundation

protocol BudgetServiceProtocol: AnyObject {
    func fetchBudgets(userId: String) async throws -> [Budget]
    func createBudget(_ request: CreateBudgetRequest) async throws -> Budget
    func deleteBudget(budgetId: String, userId: String) async throws
}


final class MockBudgetService: BudgetServiceProtocol {

    private func delay() async { try? await Task.sleep(nanoseconds: 300_000_000) }


    private var budgetsByUser: [String: [Budget]] = [:]

    init() {
        seed(userId: "u_demo_1")
        seed(userId: "u_demo_2")
    }

    private func seed(userId: String) {
        budgetsByUser[userId] = [
            Budget(budgetId: "b_\(userId)_1", name: "Еда",        amount: 15_000, currencyId: 840, categoryId: "c_\(userId)_food",     userId: userId),
            Budget(budgetId: "b_\(userId)_2", name: "Транспорт",  amount: 5_000,  currencyId: 840, categoryId: "c_\(userId)_transport", userId: userId),
            Budget(budgetId: "b_\(userId)_3", name: "Развлечения",amount: 7_500,  currencyId: 840, categoryId: "c_\(userId)_fun",       userId: userId),
        ]
    }

    func fetchBudgets(userId: String) async throws -> [Budget] {
        await delay()
        return budgetsByUser[userId] ?? []
    }

    func createBudget(_ request: CreateBudgetRequest) async throws -> Budget {
        await delay()
        let new = Budget(budgetId: UUID().uuidString,
                         name: request.name,
                         amount: request.amount,
                         currencyId: request.currencyId,
                         categoryId: request.categoryId,
                         userId: request.userId)
        budgetsByUser[request.userId, default: []].append(new)
        return new
    }

    func deleteBudget(budgetId: String, userId: String) async throws {
        await delay()
        guard var arr = budgetsByUser[userId] else { return }
        arr.removeAll { $0.budgetId == budgetId }
        budgetsByUser[userId] = arr
    }
}
