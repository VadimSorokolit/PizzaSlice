//
//  NetworkServicing.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

protocol NetworkServicing: AnyObject {
    func fetchPizzas() async throws -> [Pizza]
}
