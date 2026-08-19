//
//  PizzasViewModel.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import Foundation
import Observation
import os

@MainActor
@Observable
final class PizzasViewModel: PizzasManaging {

    // MARK: - Properties. Public

    private(set) var pizzas: [Pizza] = []
    private(set) var selectedIndex = 0
    private(set) var selectedSize: PizzaSize = .medium
    private(set) var priceSize: PizzaSize = .medium
    private(set) var quantity = 1
    private(set) var isLoading = false
    private(set) var error: String?

    var selectedPizzaID: String? {
        get {
            self.selectedPizza?.id
        }

        set {
            guard let newValue,
                  let index = self.pizzas.firstIndex(where: { $0.id == newValue })
            else {
                return
            }

            self.handleSelectPizza(at: index)
        }
    }

    var initialPizza: Pizza? {
        guard self.pizzas.isNotEmpty else {
            return nil

        }

        return self.pizzas[self.pizzas.count / 2]
    }

    var selectedPizza: Pizza? {
        guard self.pizzas.indices.contains(selectedIndex) else { return nil }
        return self.pizzas[selectedIndex]
    }

    var canDecreaseQuantity: Bool {
        self.quantity > 1
    }

    var totalPrice: Double {
        let price = self.selectedPizza?
            .variants
            .first { $0.size == self.priceSize.rawValue }?
            .price ?? 0

        return price * Double(self.quantity)
    }

    // MARK: - Methods. Public

    func fetchPizzas() async {
        self.isLoading = true
        self.error = nil

        defer {
            self.isLoading = false
        }

        do {
            self.pizzas = try await self.networkService.fetchPizzas()
            self.handleSelectPizza(at: self.pizzas.count / 2)
        } catch {
            self.error = AppError.API.from(error).errorDescription
            AppLogger.network.error("\(self.error ?? "Unknown error")")
        }
    }

    func handleSelectPizza(at index: Int) {
        guard self.pizzas.indices.contains(index) else { return }
        guard self.selectedIndex != index else { return }

        self.selectedIndex = index
        self.quantity = 1

        if let size = self.selectedPizza.flatMap({ PizzaSize(rawValue: $0.defaultSize) }) {
            self.selectedSize = size
            self.priceSize = size
        }
    }

    func handlePizzaSize(_ size: PizzaSize) {
        self.selectedSize = size

        self.priceSizeTask?.cancel()
        self.priceSizeTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))

            guard !Task.isCancelled else { return }

            self.priceSize = size
        }
    }

    func handleIncreaseQuantity() {
        self.quantity += 1
    }

    func handleDecreaseQuantity() {
        guard self.quantity > 1 else { return }
        self.quantity -= 1
    }

    func isSelected(_ size: PizzaSize) -> Bool {
        self.selectedSize == size
    }

    // MARK: - Initializer

    init(networkService: NetworkServicing) {
        self.networkService = networkService
    }

    // MARK: - Properties. Private

    @ObservationIgnored
    private let networkService: NetworkServicing

    private var priceSizeTask: Task<Void, Never>?
}
