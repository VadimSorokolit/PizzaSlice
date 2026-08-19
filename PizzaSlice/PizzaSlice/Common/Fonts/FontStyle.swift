//
//  FontStyle.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

struct FontStyle {
    let name: String

    func size(_ size: CGFloat) -> Font {
        .custom(name, size: size)
    }
}

struct FigtreeFontFamily {
    let black = FontStyle(name: "Figtree-Black")
    let extraBold = FontStyle(name: "Figtree-ExtraBold")
    let bold = FontStyle(name: "Figtree-Bold")
    let semiBold = FontStyle(name: "Figtree-SemiBold")
    let medium = FontStyle(name: "Figtree-Medium")
    let regular = FontStyle(name: "Figtree-Regular")
    let light = FontStyle(name: "Figtree-Light")
}
