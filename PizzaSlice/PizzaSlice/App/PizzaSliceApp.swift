//
//  PizzaSliceApp.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

@main
struct PizzaSliceApp: App {

    // Main Body

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(pizzaViewModel)
                .environment(splashViewModel)
        }
    }

    // MARK: - Properties. Private

    @State private var pizzaViewModel = PizzasViewModel(networkService: NetworkService())
    @State private var splashViewModel = SplashViewModel()
}
