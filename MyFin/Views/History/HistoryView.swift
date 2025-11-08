import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var historyVM: HistoryViewModel

    @State private var showLogoutConfirm = false
    @State private var showAddTx = false
    @State private var showPickWalletAlert = false

    private func chip(_ title: String, active: Bool) -> some View {
        Text(title)
            //.padding(.horizontal, 32)
            //.padding(.vertical, 7)
            .background(active ? Color._1111.opacity(0.9) : Color._1111.opacity(0.5))
            .cornerRadius(10)
            .font(.system(size: 20))
            .foregroundStyle(.black)
    }

    
    var body: some View {
        ZStack {
            Image(.blur1)
            VStack(spacing: 60) {
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

                        Button {
                            if historyVM.selectedWalletId == nil {
                                showPickWalletAlert = true
                            } else {
                                showAddTx = true
                            }
                        } label: {
                            Image(systemName: "plus")
                            .frame(width: 37, height: 32)
                        }
                        .foregroundStyle(.fontApp)
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

                VStack(spacing: 10) {
                    VStack(alignment: .center, spacing: 32) {
                        Text(historyVM.selectedWalletName.isEmpty ? "Кошелёк" : historyVM.selectedWalletName)
                                .font(.system(size: 36, weight: .bold))
                        HStack(spacing: 69) {
                            Text("Баланс:").font(.system(size: 24, weight: .bold))
                            HStack(spacing: 1){
                                Text("\(Int(historyVM.selectedWalletBalance))")    // ← сумма
                                Image(systemName: "rublesign")
                            }
                            .font(.system(size: 24, weight: .bold))
                        }
                        HStack(spacing: 7) {
                            HStack(spacing: 7) {
                                Button {
                                    historyVM.toggleFilter(.income)
                                } label: {
                                    chip("+ доходы", active: historyVM.filter == .income)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    historyVM.toggleFilter(.expense)
                                } label: {
                                    chip("- расходы", active: historyVM.filter == .expense)
                                }
                                .buttonStyle(.plain)

                                Button {
                                    historyVM.clearFilter()
                                } label: {
                                    chip("Все", active: historyVM.filter == .all)
                                }
                                .buttonStyle(.plain)
                            }


                        }
                    }
                    .padding(.horizontal, 22).padding(.vertical, 42)
                    .background(.fontApp).cornerRadius(25)

                    Text("История")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.fontApp)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(historyVM.visibleTransactions, id: \.id) { tx in
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
                            if historyVM.visibleTransactions.isEmpty {
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
        .onAppear { historyVM.onAppear() }
        .sheet(isPresented: $showAddTx) {
            AddTransactionView { amount, desc, isIncome in
                historyVM.addTransaction(amount: amount, description: desc, isIncome: isIncome)
            }
        }
        .alert("Выберите кошелёк на главном экране, чтобы добавить транзакцию",
               isPresented: $showPickWalletAlert) {
            Button("Ок", role: .cancel) { }
        }
        .alert("Выйти из аккаунта?", isPresented: $showLogoutConfirm) {
            Button("Выйти", role: .destructive) { authVM.logout() }
            Button("Отмена", role: .cancel) { }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
    }
}

