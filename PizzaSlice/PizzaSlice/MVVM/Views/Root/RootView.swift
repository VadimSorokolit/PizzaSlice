//
//  RootView.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

struct RootView: View {

    // MARK: - Main Body

    var body: some View {
        ZStack {
            if splashViewModel.isCatalogRevealed {
                PizzaView()
                    .transition(.opacity)
            }

            if splashViewModel.isSplashVisible {
                SplashView()
                    .transition(.opacity)
            }
        }
        .animation(
            GlobalConstants.Motion.splashToCover,
            value: splashViewModel.isSplashVisible
        )
        .animation(
            GlobalConstants.Motion.coverToCatalog,
            value: splashViewModel.isCatalogRevealed
        )
        .task {
            await presentCatalog()
        }
    }

    // MARK: - Properties. Private

    @Environment(PizzasViewModel.self) private var pizzaViewModel
    @Environment(SplashViewModel.self) private var splashViewModel

    // MARK: - Methods. Private

    private func presentCatalog() async {
        async let fetch: Void = pizzaViewModel.fetchPizzas()
        async let assembly: Void = splashViewModel.assemblePizza()

        _ = await fetch
        _ = await assembly

        await splashViewModel.revealCatalog()
    }
}

#Preview {
    RootView()
        .environment(PizzasViewModel(networkService: NetworkService()))
        .environment(SplashViewModel())
}
