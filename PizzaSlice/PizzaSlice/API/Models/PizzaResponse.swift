//
//  PizzaResponse.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 17.08.2026.
//

import Foundation

typealias Pizza = PizzaResponse.Pizza

struct PizzaResponse: Decodable {
    let pizzas: [Pizza]

    struct Pizza: Decodable, Hashable {
        let id: String
        let name: String
        let description: String
        let imageURLString: String
        let variants: [PizzaVariant]
        let defaultSize: String

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case description
            case variants
            case imageURLString = "image_url"
            case defaultSize = "default_size"
        }
    }

    struct PizzaVariant: Decodable, Hashable {
        let size: String
        let price: Double
    }
}
