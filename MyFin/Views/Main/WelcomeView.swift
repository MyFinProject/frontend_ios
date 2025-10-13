//
//  ContentView.swift
//  MyFin
//
//  Created by Михаил Полозов on 24.09.2025.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        ZStack {
            Image(.blur1)
            
            VStack(spacing: 40) {
                Text("MyFin")
                    .font(.system(size: 96, weight: .black))
                    .foregroundStyle(.fontApp)
                    
                
                VStack(spacing: 25) {
                    Button {
                        router.showLogin()
                    } label: {
                        Text("Войти")
                            .font(.system(size: 20))
                            .frame(width: 240, height: 50)
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10) // Скругление углов
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.fontApp, lineWidth: 2) // Синяя обводка, толщина 2
                                            )
//                            .clipShape(.rect(cornerRadius: 30))
//                            .border(Color.black, width: 2)
                    }
                    
                    Button {
                        router.showRegistration()
                    } label: {
                        Text("Зарегистрироваться")
                            .font(.system(size: 20))
                            .frame(width: 240, height: 50)
                            .foregroundStyle(.fontApp)
                            .cornerRadius(10) // Скругление углов
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .stroke(.fontApp, lineWidth: 2) // Синяя обводка, толщина 2
                                            )
                    }


                }
            }
            
        }
        .navigationBarBackButtonHidden(true)  // ← Убирает back-стрелку
        .toolbar(.hidden, for: .tabBar)  // ← Убирает таб-бар снизу, если он есть
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}
