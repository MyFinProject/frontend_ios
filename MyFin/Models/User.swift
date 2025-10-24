
struct User: Codable {
    let username: String
    let email: String
    let userId: String
}

struct RegisterRequest: Codable {
    let username: String
    let email: String
    let password: String
}

struct AuthResponse: Codable {
    //
}

