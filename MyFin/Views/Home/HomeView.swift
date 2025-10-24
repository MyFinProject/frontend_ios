import SwiftUI

struct HomeView:    View {
    @EnvironmentObject var router: AppRouter
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
                        .cornerRadius(10) // Скругление углов
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.fontApp, lineWidth: 2)
                        )
                        
                        
                        Button {
                            router.showLogoutConfirm()
                        } label: {
                            Text("Выйти")
                                .foregroundStyle(.fontApp)
                                .font(.system(size: 20, weight: .regular))
                        }
                        .frame(width: 87, height: 32)
                        .cornerRadius(10) // Скругление углов
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.fontApp, lineWidth: 2)
                        )
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
                                        Text("$")
                                            .font(.system(size: 18, weight: .medium))
                                        Text("198576")
                                            .font(.system(size: 60, weight: .bold))
                                    }
                                }
                                
                                Image(.image8)
                                
                            }
                            HStack(spacing: 50){
                                VStack {
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        Text("231231")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    
                                    Text("Income")
                                        .font(.system(size: 14, weight: .regular))
                                }
                                
                                VStack {
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        Text("31231231")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    
                                    Text("Expand")
                                        .font(.system(size: 14, weight: .regular))
                                }
                                
                                VStack {
                                    HStack {
                                        Text("$")
                                            .font(.system(size: 16, weight: .semibold))
                                        
                                        Text("2412414")
                                            .font(.system(size: 16, weight: .semibold))
                                    }
                                    Text("Investment")
                                        .font(.system(size: 14, weight: .regular))
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
                                //.padding(29)
                            HStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 20) {
                                        ForEach(0..<10, id: \.self) { num in
                                            WalletCardView()
                                        }

                                    }
                                    .padding(36)
                                }
                                Button {
                                    //
                                } label: {
                                    ZStack {
                                        Circle()
                                            .foregroundStyle(.fontApp)
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: "plus")
                                            .foregroundStyle(.black)
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
                            ScrollView(showsIndicators: false) {
                                
                                
                                ForEach(0..<10, id: \.self) { num in
                                    CategoryCardView(number: num, name: "dddd", limitation: 5000)
                                }
                            }
                            .frame(width: 370)
                            
                            Button {
                                //
                            } label: {
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
        .sheet(isPresented: $showLogoutConfirm) {
            LogoutConfirmView()
                        .environmentObject(router)
                }
        
    }
}
