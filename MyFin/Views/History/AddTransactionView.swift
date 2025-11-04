import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss

    let onSubmit: (_ amount: Double, _ description: String, _ isIncome: Bool) -> Void

    @State private var amountText = ""
    @State private var descriptionText = ""
    @State private var isIncome = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Новая транзакция").font(.title2.bold())

            TextField("Сумма", text: $amountText)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)

            TextField("Описание", text: $descriptionText)
                .textFieldStyle(.roundedBorder)

            Toggle("Это доход", isOn: $isIncome)

            Button {
                let cleaned = amountText.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ",", with: ".")
                let amount = Double(cleaned) ?? 0
                onSubmit(amount, descriptionText, isIncome)
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
