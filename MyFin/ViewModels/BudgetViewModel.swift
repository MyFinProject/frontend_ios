import Foundation
import Combine

@MainActor
final class BudgetViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let budgetsService: BudgetServiceProtocol
    private let categoriesService: CategoryServiceProtocol
    private let authService: AuthServiceProtocol

    init(budgetsService: BudgetServiceProtocol,
         categoriesService: CategoryServiceProtocol,
         authService: AuthServiceProtocol) {
        self.budgetsService = budgetsService
        self.categoriesService = categoriesService
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
                _ = try await categoriesService.fetchCategories(userId: userId)
                budgets = try await budgetsService.fetchBudgets(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func createBudget(name: String, amount: Double, categoryId: String, currencyId: Int = 840) {
        guard let userId = authService.currentUser?.userId ?? Optional("u_demo_1") else { return }
        Task {
            do {
                let req = CreateBudgetRequest(userId: userId, categoryId: categoryId, amount: amount, currencyId: currencyId, name: name)
                let _ = try await budgetsService.createBudget(req)
                budgets = try await budgetsService.fetchBudgets(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteBudget(_ budget: Budget) {
        let userId = authService.currentUser?.userId ?? "u_demo_1"
        Task {
            do {
                try await budgetsService.deleteBudget(budgetId: budget.budgetId, userId: userId)
                budgets = try await budgetsService.fetchBudgets(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    func createBudgetWithNewCategory(name: String, amount: Double) {
        let userId = authService.currentUser?.userId ?? "u_demo_1"
        Task {
            do {
                let category = try await categoriesService.createCategory(name: name, icon: "circle", userId: userId)
                let req = CreateBudgetRequest(userId: userId,
                                              categoryId: category.id ?? UUID().uuidString,
                                              amount: amount,
                                              currencyId: 840,
                                              name: name)
                _ = try await budgetsService.createBudget(req)
                budgets = try await budgetsService.fetchBudgets(userId: userId)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

}
