//
//  AppLogger.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "App"

    static let app = Logger(subsystem: subsystem, category: "App")
    static let network = Logger(subsystem: subsystem, category: "Network")
}
