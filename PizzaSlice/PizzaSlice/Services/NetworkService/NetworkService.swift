//
//  NetworkService.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import Foundation

final class NetworkService: NetworkServicing {

    // MARK: - Methods. Public

    func fetchPizzas() async throws -> [Pizza] {
        do {
            guard let url = URL(string: Constants.pizzasURL) else {
                throw AppError.API.invalidURL
            }

            let (data, response) = try await URLSession.shared.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.API.unknown
            }

            switch httpResponse.statusCode {
                case 200 ... 299:
                    break

                case 404:
                    throw AppError.API.notFound

                default:
                    throw AppError.API.serverStatusCode(httpResponse.statusCode)
            }

            let decoded = try JSONDecoder().decode(PizzaResponse.self, from: data)
            return decoded.pizzas
        } catch {
            throw AppError.API.from(error)
        }
    }

    // MARK: - Properties. Private

    private enum Constants {
        static let pizzasURL = "https://oursongapp.com/api/pizzas"
    }
}
