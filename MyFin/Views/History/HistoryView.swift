import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var historyVM: HistoryViewModel

    @State private var showLogoutConfirm = false

    var body: some View {
        ZStack {
            Image(.blur1)
            VStack(spacing: 60) {
                // Header
                HStack(spacing: 95) {
                    Text("MyFin")
                        .foregroundStyle(.fontApp)
                        .font(.system(size: 36, weight: .medium))

                    HStack(spacing: 18) {
                        Button { router.showHome() } label: {
                            Text("ЛК")
                        }
                        .foregroundStyle(.fontApp)
                        .frame(width: 37, height: 32)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.fontApp, lineWidth: 2))

                        Button { showLogoutConfirm = true } label: {
                            Text("Выйти")
                        }
                        .foregroundStyle(.fontApp)
                        .frame(width: 87, height: 32)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.fontApp, lineWidth: 2))
                    }
                }

                // Card с балансом выбранного кошелька (пока статично)
                VStack(spacing: 10) {
                    VStack(alignment: .center, spacing: 32) {
                        Text("Сбербанк").font(.system(size: 36, weight: .bold))
                        HStack(spacing: 69) {
                            Text("Баланс:").font(.system(size: 24, weight: .bold))
                            HStack(spacing: 1){
                                Text("—")
                                Image(systemName: "rublesign")
                            }
                            .font(.system(size: 24, weight: .bold))
                        }
                        HStack(spacing: 7) {
                            Button { /* фильтр доходов */ } label: { Text("+ доходы") }
                                .padding(.horizontal, 32).padding(.vertical, 7)
                                .background(._1111).cornerRadius(10)
                                .font(.system(size: 20)).foregroundStyle(.black)

                            Button { /* фильтр расходов */ } label: { Text("- расходы") }
                                .padding(.horizontal, 32).padding(.vertical, 7)
                                .background(._1111).cornerRadius(10)
                                .font(.system(size: 20)).foregroundStyle(.black)
                        }
                    }
                    .padding(.horizontal, 22).padding(.vertical, 42)
                    .background(.fontApp).cornerRadius(25)

                    Text("История")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.fontApp)

                    // Список транзакций
                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(historyVM.transactions, id: \.id) { tx in
                                HStack {
                                    Text(tx.description ?? "")
                                        .font(.system(size: 18))
                                    Spacer()
                                    Text("\(tx.typeOperation == 3 ? "+" : "-")\(Int(tx.amount))")
                                        .font(.system(size: 18, weight: .semibold))
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.08))
                                .cornerRadius(12)
                            }
                            if historyVM.transactions.isEmpty {
                                Text("Нет транзакций")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                    }
                    .frame(width: 386, height: 319)
                    .background(.fontApp)
                    .cornerRadius(25)

                    Button { /* удалить кошелёк */ } label: {
                        Text("Удалить кошелек")
                            .font(.system(size: 36, weight: .medium))
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(.fontApp, lineWidth: 2))
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { historyVM.onAppear() }
        .alert("Выйти из аккаунта?", isPresented: $showLogoutConfirm) {
            Button("Выйти", role: .destructive) { authVM.logout() }
            Button("Отмена", role: .cancel) { }
        }
    }
}
