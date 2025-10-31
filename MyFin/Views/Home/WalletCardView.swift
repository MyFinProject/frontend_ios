import SwiftUI

struct WalletCardView: View {
    let wallet: Wallet

    var body: some View {
        VStack {
            Circle()
                .fill(Color.IMG)
                .frame(width: 50, height: 50)
            Text(wallet.name)
                .font(.system(size: 11, weight: .medium))
        }
    }
}
