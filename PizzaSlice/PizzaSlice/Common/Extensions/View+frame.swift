//
//  View+frame.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

extension View {

    func frame(size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }

}
