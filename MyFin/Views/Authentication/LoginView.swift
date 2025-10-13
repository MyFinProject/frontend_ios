import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: AppRouter
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack {
            Image("blur1")
            VStack(spacing: 54) {
                VStack(spacing: 40) {
                    Text("ВХОД")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundStyle(.fontApp)
                        .frame(width: 342, height: 57)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.fontApp, lineWidth: 2)
                        )
                    
                    VStack {
                        TextField("Почта", text: $email)
                            .padding(.horizontal, 19)
                            .padding(.vertical, 11)
                            .frame(width: 342, height: 44)
                            .background(.fontApp)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.fontApp, lineWidth: 2)
                            )
                        
                        SecureField("Пароль", text: $password)
                            .padding(.horizontal, 19)
                            .padding(.vertical, 11)
                            .frame(width: 342, height: 44)
                            .background(.fontApp)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        router.performLogin()
                    } label: {
                        Text("ВОЙТИ")
                            .frame(width: 215, height: 35)
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.fontApp, lineWidth: 2)
                            )
                    }
                }
                
                HStack(spacing: 20) {
                    Text("Нет аккаунт? →")
                        .foregroundStyle(.fontApp)
                    
                    Button {
                        router.showRegistration()
                    } label: {
                        Text("Зарегистрироваться")
                            .foregroundStyle(.fontApp)
                            .frame(width: 201, height: 32)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.fontApp, lineWidth: 2)
                            )
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)  // ← Убирает back-стрелку
        .toolbar(.hidden, for: .tabBar)  // ← Убирает таб-бар снизу, если он есть
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.showMain()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.fontApp)
                }
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppRouter())
}
