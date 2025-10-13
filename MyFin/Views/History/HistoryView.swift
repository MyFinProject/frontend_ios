//
//  ContentView7.swift
//  проект
//
//  Created by Михаил Полозов on 03.10.2025.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var router: AppRouter
    @State private var showLogoutConfirm = false
    var body: some View {
        ZStack {
            Image(.blur1)
            VStack(spacing: 60) {
                HStack(spacing: 95) {
                    Text("MyFin")
                        .foregroundStyle(.fontApp)
                        .font(.system(size: 36, weight: .medium))
                    
                    
                    HStack(spacing: 18) {
                        Button {
                            router.showHome()
                        } label: {
                            Text("ЛК")
                        }
                        .foregroundStyle(.fontApp)
                        .frame(width: 37, height: 32)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.fontApp, lineWidth: 2)
                        )
                        
                        Button {
                            showLogoutConfirm = true
                        } label: {
                            Text("Выйти")
                        }
                        .foregroundStyle(.fontApp)
                        .frame(width: 87, height: 32)
                        .font(.system(size: 20, weight: .regular))
                        .cornerRadius(10) // Скругление углов
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.fontApp, lineWidth: 2) // Синяя обводка, толщина 2
                        )
                    }


                }
                VStack(spacing: 10) {
                    VStack(alignment: .center, spacing: 32) {
                        Text("Сбербанк")
                            .font(.system(size: 36, weight: .bold))
                        
                        HStack(spacing: 69) {
                            Text("Баланс:")
                                .font(.system(size: 24, weight: .bold))
                            
                            
                            HStack (spacing: 1){
                                
                                Text("23000")
                                
                                Image(systemName: "rublesign")
                            }
                            .font(.system(size: 24, weight: .bold))
                        }
                        
                        HStack(spacing: 7) {
                            Button {
                                //
                            } label: {
                                Text("+ доходы")
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 7)
                            .background(._1111)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            
                            
                            Button {
                                //
                            } label: {
                                Text("- доходы")
                            }
                            .padding(.horizontal, 32)
                            .padding(.vertical, 7)
                            .background(._1111)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                            .foregroundStyle(.black)
                            
                        }
                    }
                    //.frame(maxWidth: .infinity)
                    .padding(.horizontal, 22)
                    .padding(.vertical, 42)
                    
                    //.frame(width: 379, height: 218)
                    .background(.fontApp)
                    .cornerRadius(25)
                    
                    Text("История")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.fontApp)
                    
                    VStack {
                        
                    }
                    .frame(width: 386, height: 319)
                    .background(.fontApp)
                    .cornerRadius(25)
                    
                    Button {
                        //
                    } label: {
                        Text("Удалить кошелек")
                            .font(.system(size: 36, weight: .medium))
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
        .sheet(isPresented: $showLogoutConfirm) {  // <-- Добавьте: модальное окно
            LogoutConfirmView()
                        .environmentObject(router)  // Передача модели
                }
    }
}

#Preview {
    HistoryView()
}
