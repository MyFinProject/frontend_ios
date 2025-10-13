//
//  OnBoardingView.swift
//  проект
//
//  Created by Михаил Полозов on 30.09.2025.
//
import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject var router: AppRouter
    var body: some View {
        ZStack {
            Image(.blur1)
            
            Text("MyFin")
                .font(.system(size: 100, weight: .black))
                .foregroundStyle(.fontApp)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                router.completeOnboarding()
            }
        }
    }
}


#Preview {
    OnBoardingView()
}
