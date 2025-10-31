import SwiftUI

struct HomeView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var authVM: AuthViewModel
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var historyVM: HistoryViewModel


    @State private var showLogoutConfirm = false

    var body: some View {
        ZStack {
            Image(.blur1)
            VStack {
                // Header
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

                // Content
                VStack(spacing: 17) {
                    // Баланс
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

                    // Кошельки
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
                                                // запоминаем выбранный кошелёк и переходим в Историю
                                                historyVM.selectedWalletId = wallet.walletId
                                                router.showHistory()
                                            } label: {
                                                WalletCardView(wallet: wallet)
                                            }
                                            .buttonStyle(.plain) // чтобы не менять внешний вид
                                        }
                                    }
                                    .padding(36)
                                }

                                Button { /* добавить кошелёк */ } label: {
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

                    // Бюджет (пока мок, как у тебя)
                    ZStack {
                        VStack {
                            Text("Бюджет")
                                .padding()
                                .font(Font.system(size: 36, weight: .bold))

                            ScrollView(showsIndicators: false) {
                                ForEach(0..<10, id: \.self) { num in
                                    CategoryCardView(number: num, name: "dddd", limitation: 5000)
                                }
                            }
                            .frame(width: 370)

                            Button { /* добавить категорию */ } label: {
                                Text("Добавить категорию")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.fontApp)
                                    .padding()
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
    }
}
