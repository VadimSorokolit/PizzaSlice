//
//  SplashViewModel.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import DeveloperToolsSupport
import Foundation
import Observation

@MainActor
@Observable
final class SplashViewModel: SplashManaging {

    // MARK: - Properties. Public

    private(set) var visibleSliceCount = 0
    private(set) var isHandingOver = false
    private(set) var areSlicesHidden = false
    private(set) var isCatalogRevealed = false
    private(set) var isSplashVisible = true

    @ObservationIgnored
    let sliceImages: [ImageResource] = [
        .slice1, .slice2, .slice3, .slice4,
        .slice5, .slice6, .slice7, .slice8
    ]

    var sliceCount: Int {
        self.sliceImages.count
    }

    // MARK: - Methods. Public

    func assemblePizza() async {
        for index in 0 ..< self.sliceCount {
            self.visibleSliceCount = index + 1

            try? await Task.sleep(for: self.sliceInterval)
        }

        try? await Task.sleep(for: self.assemblyHold)
    }

    func revealCatalog() async {
        self.isHandingOver = true
        self.areSlicesHidden = true

        try? await Task.sleep(for: self.coverHold)

        self.isSplashVisible = false
        self.isCatalogRevealed = true
    }

    // MARK: - Initializer

    init(
        sliceInterval: Duration = .milliseconds(110),
        assemblyHold: Duration = .milliseconds(450),
        handoverHold: Duration = .milliseconds(0),
        coverHold: Duration = .milliseconds(300)
    ) {
        self.sliceInterval = sliceInterval
        self.assemblyHold = assemblyHold
        self.handoverHold = handoverHold
        self.coverHold = coverHold
    }

    // MARK: - Properties. Private

    @ObservationIgnored
    private let sliceInterval: Duration

    @ObservationIgnored
    private let assemblyHold: Duration

    @ObservationIgnored
    private let handoverHold: Duration

    @ObservationIgnored
    private let coverHold: Duration
}
