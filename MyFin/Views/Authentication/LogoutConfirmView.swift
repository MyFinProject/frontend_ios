import SwiftUI

struct LogoutConfirmView: View {
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Image("blur1")
            VStack(spacing: 40) {
                Text("""
                Вы уверены, что 
                хотите выйти?
                """)
                .foregroundStyle(.fontApp)
                .font(.system(size: 36, weight: .bold))
                
                HStack(spacing: 63) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Нет")
                            .frame(width: 99, height: 34)
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.fontApp, lineWidth: 2)
                            )
                    }
                    
                    Button {
                        router.performLogout()
                        dismiss()
                    } label: {
                        Text("Да")
                            .frame(width: 99, height: 34)
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.fontApp, lineWidth: 2)
                            )
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    LogoutConfirmView()
        .environmentObject(AppRouter())
}
