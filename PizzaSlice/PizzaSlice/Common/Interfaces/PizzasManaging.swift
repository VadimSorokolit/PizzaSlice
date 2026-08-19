//
//  PizzasManaging.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

@MainActor
protocol PizzasManaging: AnyObject {
    var pizzas: [Pizza] { get }
    var selectedPizza: Pizza? { get }
    var selectedPizzaID: String? { get }
    var selectedSize: PizzaSize { get }
    var quantity: Int { get }
    var canDecreaseQuantity: Bool { get }
    var totalPrice: Double { get }
    var isLoading: Bool { get }
    var error: String? { get }

    func fetchPizzas() async
    func handlePizzaSize(_ size: PizzaSize)
    func handleSelectPizza(at index: Int)
    func handleIncreaseQuantity()
    func handleDecreaseQuantity()
    func isSelected(_ size: PizzaSize) -> Bool
}
