import Foundation

enum Route: Hashable, Identifiable {
    case main
    case login
    case register
    case home
    case history
    case walletCreate
    case logoutConfirm

    var id: Self { self } 
}
