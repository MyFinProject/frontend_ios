import SwiftUI

struct WalletCardView: View {
    var body: some View {
        VStack {
            Circle()
                .fill(Color.IMG)
                .frame(width: 50, height: 50)
            Text("название")
                .font(.system(size: 11, weight: .medium))
        }
    }
}

#Preview {
    WalletCardView()
}
