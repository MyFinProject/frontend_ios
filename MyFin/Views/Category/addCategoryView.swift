
import SwiftUI

struct AddCategoryView: View {
    @Environment(\.dismiss) private var dismiss

    var onSubmit: (_ name: String, _ amount: Double) -> Void

    @State private var name: String = ""
    @State private var amountText: String = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Меню")
                .font(.system(size: 28, weight: .semibold))

            VStack(alignment: .leading, spacing: 12) {
                Text("Редактировать название:")
                    .font(.system(size: 18, weight: .semibold))

                TextField("Введите название", text: $name)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Редактировать ограничение:")
                    .font(.system(size: 18, weight: .semibold))

                TextField("Введите ограничение", text: $amountText)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
            }

            Button {
                let cleaned = amountText.replacingOccurrences(of: " ", with: "")
                let amount = Double(cleaned) ?? 0
                onSubmit(name, amount)
                dismiss()
            } label: {
                Text("Добавить")
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.borderedProminent)

            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.systemYellow).opacity(0.35))
        .presentationDetents([.height(360)])
    }
}
