//
//  SplashManaging.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import DeveloperToolsSupport

@MainActor
protocol SplashManaging: AnyObject {
    var sliceImages: [ImageResource] { get }
    var sliceCount: Int { get }
    var visibleSliceCount: Int { get }
    var isHandingOver: Bool { get }
    var areSlicesHidden: Bool { get }
    var isSplashVisible: Bool { get }
    var isCatalogRevealed: Bool { get }

    func assemblePizza() async
    func revealCatalog() async
}
