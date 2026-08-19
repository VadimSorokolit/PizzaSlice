//
//  SplashView.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

struct SplashView: View {

    // MARK: - Main Body

    var body: some View {
        ZStack {
            background

            pizza
                .scaleEffect(splashViewModel.areSlicesHidden ? 0.74 : 1)
                .opacity(splashViewModel.areSlicesHidden ? 0 : 1)
        }
        .animation(.easeInOut(duration: 0.30), value: splashViewModel.isHandingOver)
        .animation(
            .easeInOut(duration: 0.30),
            value: splashViewModel.areSlicesHidden
        )
    }

    // MARK: - Properties. Private

    @Environment(SplashViewModel.self) private var splashViewModel

    private let pizzaSize: CGFloat = 270

    private var background: some View {
        ZStack {
            GlobalConstants.AppColor.surface

            GlobalConstants.AppColor.background
                .opacity(splashViewModel.isHandingOver ? 1 : 0)
        }
        .ignoresSafeArea()
    }

    private var pizza: some View {
        ZStack {
            ForEach(Array(splashViewModel.sliceImages.indices), id: \.self) { index in
                Image(splashViewModel.sliceImages[index])
                    .resizable()
                    .scaledToFit()
                    .opacity(index < splashViewModel.visibleSliceCount ? 1 : 0)
            }
        }
        .frame(width: pizzaSize, height: pizzaSize)
        .animation(
            GlobalConstants.Motion.sliceReveal,
            value: splashViewModel.visibleSliceCount
        )
        .accessibilityHidden(true)
    }
}

#Preview {
    SplashView()
        .environment(SplashViewModel())
}
