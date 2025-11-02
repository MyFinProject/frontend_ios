import Foundation

protocol CategoryServiceProtocol: AnyObject {
    func fetchCategories(userId: String) async throws -> [Category]
    func createCategory(name: String, icon: String?, userId: String) async throws -> Category
}

final class MockCategoryService: CategoryServiceProtocol {

    private func delay() async { try? await Task.sleep(nanoseconds: 250_000_000) }

    private var categoriesByUser: [String: [Category]] = [:]

    init() {
        seed(userId: "u_demo_1")
        seed(userId: "u_demo_2")
    }

    private func seed(userId: String) {
        let cats: [Category] = [
            Category(id: "c_\(userId)_food",     name: "Еда",      icon: "fork.knife"),
            Category(id: "c_\(userId)_transport",name: "Транспорт",icon: "car.fill"),
            Category(id: "c_\(userId)_fun",      name: "Развлеч.", icon: "gamecontroller.fill"),
            Category(id: "c_\(userId)_other",    name: "Другое",   icon: "ellipsis.circle"),
        ]
        categoriesByUser[userId] = cats
    }

    func fetchCategories(userId: String) async throws -> [Category] {
        await delay()
        return categoriesByUser[userId] ?? []
    }

    func createCategory(name: String, icon: String?, userId: String) async throws -> Category {
        await delay()
        let new = Category(id: UUID().uuidString, name: name, icon: icon)
        categoriesByUser[userId, default: []].append(new)
        return new
    }
}
