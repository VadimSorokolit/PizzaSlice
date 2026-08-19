//
//  PizzaCell.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI
import SDWebImageSwiftUI

struct PizzaCell: View {

    // MARK: - Properties. Public

    let pizza: Pizza
    let size: CGFloat
    let showsExpandControl: Bool
    let onExpand: () -> Void

    // MARK: - Main Body

    var body: some View {
        pizzaImage
            .frame(size: size)
            .clipShape(Circle())
            .shadow(
                color: Color(hex: 0x000000).opacity(0.5),
                radius: 4,
                x: 0,
                y: 2
            )
            .overlay {
                if showsExpandControl {
                    Button(action: onExpand) {
                        ZStack {
                            Circle()
                                .fill(.black.opacity(0.2))
                                .frame(size: 88)
                                .blur(radius: 48)
                                .mask {
                                    Circle()
                                        .frame(size: 88)
                                }

                            Image(.ellipse)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25.95, height: 38.18)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
    }

    // MARK: - Properties. Private

    @ViewBuilder
    private var pizzaImage: some View {
        if let url = URL(string: pizza.imageURLString) {
            WebImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                placeholder
            }
        } else {
            placeholder
        }
    }

    private var placeholder: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .padding(16)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
    }
}

#Preview("Sizes") {
    let pizza = Pizza(
        id: "pepperoni-blast",
        name: "Pepperoni Blast",
        description: "Preview",
        imageURLString: "https://oursongapp.com/images/pizzas/pizza_pepperoni_blast.png",
        variants: [],
        defaultSize: "M"
    )

    VStack(spacing: 24) {
        PizzaCell(
            pizza: pizza,
            size: PizzaSize.small.cellSize,
            showsExpandControl: true,
            onExpand: {}
        )

        PizzaCell(
            pizza: pizza,
            size: PizzaSize.medium.cellSize,
            showsExpandControl: true,
            onExpand: {}
        )

        PizzaCell(
            pizza: pizza,
            size: PizzaSize.large.cellSize,
            showsExpandControl: true,
            onExpand: {}
        )
    }
}
