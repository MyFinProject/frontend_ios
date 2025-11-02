import Foundation

enum AuthError: LocalizedError, Equatable {
    case invalidCredentials
    case emailAlreadyTaken
    case weakPassword
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidCredentials: return "Неверная почта или пароль."
        case .emailAlreadyTaken:  return "Такой email уже зарегистрирован."
        case .weakPassword:       return "Слишком простой пароль."
        case .unknown:            return "Неизвестная ошибка."
        }
    }
}

protocol AuthServiceProtocol: AnyObject {
    var currentUser: User? { get }
    var isAuthenticated: Bool { get }
    func login(email: String, password: String) async throws -> User
    func register(_ request: RegisterRequest) async throws -> User
    func logout() async
}


final class MockAuthService: AuthServiceProtocol {
    private var users: [String: (user: User, password: String)] = [

        "demo@myfin.app": (User(username: "Demo1", email: "demo@myfin.app", userId: "u_demo_1"), "123456"),
        "mihpolozov@gmail.com": (User(username: "Demo2", email: "mihpolozov@gmail.com", userId: "u_demo_2"), "12345678")
    ]

    private(set) var currentUser: User?

    var isAuthenticated: Bool { currentUser != nil }

    private func simulateDelay() async {
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
    }

    func login(email: String, password: String) async throws -> User {
        await simulateDelay()
        guard let record = users[email.lowercased()],
              record.password == password else {
            throw AuthError.invalidCredentials
        }
        currentUser = record.user
        return record.user
    }

    func register(_ request: RegisterRequest) async throws -> User {
        await simulateDelay()

        let email = request.email.lowercased()
        guard users[email] == nil else { throw AuthError.emailAlreadyTaken }
        guard request.password.count >= 6 else { throw AuthError.weakPassword }

        let newUser = User(username: request.username,
                           email: email,
                           userId: UUID().uuidString)
        users[email] = (newUser, request.password)
        currentUser = newUser
        return newUser
    }

    func logout() async {
        await simulateDelay()
        currentUser = nil
    }
}
