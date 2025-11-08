import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var historyVM: HistoryViewModel
    @EnvironmentObject var budgetVM: BudgetViewModel
    
    @State private var showAddCategory = false
    @State private var showAddWallet = false



    @State private var showLogoutConfirm = false

    var body: some View {
        ZStack {
            Image(.blur1)
            VStack {
                HStack(spacing: 50) {
                    Text("MyFin")
                        .foregroundStyle(.fontApp)
                        .font(.system(size: 36, weight: .medium))

                    HStack(spacing: 18) {
                        Button {
                            router.showHistory()
                        } label: {
                            Text("История")
                                .foregroundStyle(.fontApp)
                                .font(.system(size: 20, weight: .regular))
                        }
                        .frame(width: 112, height: 32)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.fontApp, lineWidth: 2))

                        Button {
                            showLogoutConfirm = true
                        } label: {
                            Text("Выйти")
                                .foregroundStyle(.fontApp)
                                .font(.system(size: 20, weight: .regular))
                        }
                        .frame(width: 87, height: 32)
                        .cornerRadius(10)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(.fontApp, lineWidth: 2))
                    }
                }

                VStack(spacing: 17) {
                    ZStack {
                        VStack {
                            HStack(alignment: .top){
                                VStack(alignment: .leading) {
                                    Text("Баланс")
                                        .font(.system(size: 16, weight: .bold))

                                    HStack {
                                        Text("$").font(.system(size: 18, weight: .medium))
                                        Text("\(Int(homeVM.totalBalance))")
                                            .font(.system(size: 60, weight: .bold))
                                    }
                                }
                                Image(.image8)
                            }
                            HStack(spacing: 50){
                                VStack {
                                    HStack {
                                        Text("$").font(.system(size: 16, weight: .semibold))
                                        Text("\(Int(homeVM.incomeTotal))")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    Text("Income").font(.system(size: 14, weight: .regular))
                                }

                                VStack {
                                    HStack {
                                        Text("$").font(.system(size: 16, weight: .semibold))
                                        Text("\(Int(homeVM.expenseTotal))")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    Text("Expand").font(.system(size: 14, weight: .regular))
                                }

                                VStack {
                                    HStack {
                                        Text("$").font(.system(size: 16, weight: .semibold))
                                        Text("0").font(.system(size: 16, weight: .semibold))
                                    }
                                    Text("Investment").font(.system(size: 14, weight: .regular))
                                }
                            }
                        }
                    }
                    .frame(width: 384, height: 184)
                    .background(.fonWindow)
                    .cornerRadius(12)

                    ZStack {
                        VStack {
                            Text("Кошельки и счета")
                                .foregroundStyle(.fontApp)
                                .font(.system(size: 24, weight: .semibold))

                            HStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(homeVM.wallets, id: \.walletId) { wallet in
                                            Button {
                                                historyVM.selectedWalletId = wallet.walletId
                                                router.showHistory()
                                            } label: {
                                                WalletCardView(wallet: wallet)
                                            }
                                            .buttonStyle(.plain)
                                        }
                                    }
                                    .padding(36)
                                }

                                Button { showAddWallet = true }
                                label: {
                                    ZStack {
                                        Circle().foregroundStyle(.fontApp).frame(width: 44, height: 44)
                                        Image(systemName: "plus").foregroundStyle(.black)
                                    }
                                }
                                .padding()
                                .foregroundStyle(.fontApp)
                            }
                        }
                    }
                    .frame(width: 384, height: 200)
                    .background(.fonWindow2)
                    .cornerRadius(12)

                    ZStack {
                        VStack {
                            Text("Бюджет")
                                .padding()
                                .font(Font.system(size: 36, weight: .bold))

                            if let err = budgetVM.errorMessage {
                                Text(err).foregroundColor(.red)
                            }

                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 8) {
                                    ForEach(Array(budgetVM.budgets.enumerated()), id: \.element.id) { (idx, budget) in
                                        CategoryCardView(number: idx,
                                                         name: budget.name,
                                                         limitation: Int(budget.amount))
                                    }
                                }
                            }
                            .frame(width: 370)

                            Button {
                                showAddCategory = true
                            } label: {
                                Text("Добавить категорию")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.fontApp)
                                    .padding()
                            }
                            .sheet(isPresented: $showAddCategory) {
                                AddCategoryView { name, amount in
                                    budgetVM.createBudgetWithNewCategory(name: name, amount: amount)
                                }
                            }

                        }
                    }
                    .frame(width: 384, height: 300)
                    .background(.fonWindow2)
                    .cornerRadius(12)

                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { homeVM.onAppear() }

        .alert("Выйти из аккаунта?", isPresented: $showLogoutConfirm) {
            Button("Выйти", role: .destructive) { authVM.logout() }
            Button("Отмена", role: .cancel) { }
        }


        .sheet(isPresented: $showAddWallet) {
            AddWalletView { name, balance, currencyId, icon in
                homeVM.createWallet(name: name, balance: balance, currencyId: currencyId, icon: icon)
            }
        }

    }
}
