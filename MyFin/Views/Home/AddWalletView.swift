import SwiftUI

struct AddWalletView: View {
    @Environment(\.dismiss) private var dismiss

    var onSubmit: (_ name: String, _ balance: Double, _ currencyId: Int, _ icon: String) -> Void

    @State private var name: String = ""
    @State private var balanceText: String = ""
    @State private var icon: String = "creditcard"
    @State private var currencyId: Int = 840       

    var body: some View {
        VStack(spacing: 16) {
            Text("Новый кошелёк").font(.title2.bold())

            TextField("Название", text: $name)
                .textFieldStyle(.roundedBorder)

            TextField("Начальный баланс", text: $balanceText)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            TextField("SF Symbol (иконка)", text: $icon)
                .textFieldStyle(.roundedBorder)

            Button {
                let cleaned = balanceText
                    .replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: ",", with: ".")
                let balance = Double(cleaned) ?? 0
                onSubmit(name, balance, currencyId, icon)
                dismiss()
            } label: {
                Text("Добавить").frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Spacer(minLength: 0)
        }
        .padding()
        .presentationDetents([.height(320)])
    }
}
