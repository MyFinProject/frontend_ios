import SwiftUI

struct EditCategoryView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var amountText: String
    @State private var showValidationError = false

    let onSave: (String, Double) -> Void

    init(budget: Budget, onSave: @escaping (String, Double) -> Void) {
        _name = State(initialValue: budget.name)
        _amountText = State(initialValue: String(Int(budget.amount)))
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                TextField("Название категории", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                TextField("Лимит, ₽", text: $amountText)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                if showValidationError {
                    Text("Введите корректную сумму")
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Редактировать")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let clean = amountText.replacingOccurrences(of: " ", with: "")
                        if let value = Double(clean) {
                            onSave(name, value)
                            dismiss()
                        } else {
                            showValidationError = true
                        }
                    }
                }
            }
        }
    }
}

