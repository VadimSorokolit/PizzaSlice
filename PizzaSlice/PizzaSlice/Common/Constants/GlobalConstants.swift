//
//  GlobalConstants.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

enum GlobalConstants {
    enum AppColor {
        static let background = Color(hex: 0xF3E3DA)
        static let surface = Color(hex: 0xFFFFFF)
    }

    enum Screen {
        static let iPhoneSEHeight: CGFloat = 667
    }

    enum Motion {
        static let carousel: SwiftUI.Animation = .interpolatingSpring(
            mass: 1,
            stiffness: 400,
            damping: 30
        )

        static let sizeChange: SwiftUI.Animation = .interpolatingSpring(
            mass: 1,
            stiffness: 400,
            damping: 22
        )

        static let fullScreenZoom: SwiftUI.Animation = .interpolatingSpring(
            mass: 1,
            stiffness: 400,
            damping: 40
        )

        static let sliceReveal: SwiftUI.Animation = .easeOut(duration: 0.22)
        static let splashToCover: SwiftUI.Animation = .easeInOut(duration: 0.35)
        static let coverToCatalog: SwiftUI.Animation = .easeInOut(duration: 0.55)
    }
}
