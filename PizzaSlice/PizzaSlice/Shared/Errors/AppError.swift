//
//  AppError.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import Foundation

enum AppError: Error {
    enum API: LocalizedError {
        case noInternet
        case network(Error)
        case decoding(Error)
        case serverStatusCode(Int)
        case invalidURL
        case notFound
        case unknown

        var errorDescription: String? {
            switch self {
                case .noInternet:
                    return "No internet connection"

                case .network(let error):
                    return "Network error: \(error.localizedDescription)"

                case .decoding(let error):
                    return "Decoding error: \(error.localizedDescription)"

                case .serverStatusCode(let code):
                    return "Server error (code: \(code))"

                case .invalidURL:
                    return "Invalid URL"

                case .notFound:
                    return "Requested resource not found"

                case .unknown:
                    return "Unknown error"
            }
        }

        static func from(_ error: Error) -> API {
            if let apiError = error as? API {
                return apiError
            }

            if let decodingError = error as? DecodingError {
                return .decoding(decodingError)
            }

            if let urlError = error as? URLError {
                return self.mapURLError(urlError)
            }

            return .network(error)
        }

        private static func mapURLError(_ error: URLError) -> API {
            switch error.code {
                case .notConnectedToInternet,
                        .cannotConnectToHost,
                        .networkConnectionLost,
                        .timedOut:
                    return .noInternet

                case .cannotFindHost,
                        .dnsLookupFailed,
                        .badURL,
                        .unsupportedURL:
                    return .invalidURL

                default:
                    return .network(error)
            }
        }
    }
}
