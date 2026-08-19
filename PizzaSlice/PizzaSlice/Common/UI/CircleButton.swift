//
//  CircleButton.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

struct CircleButton: View {

    // MARK: - Properties. Public

    let circleSize: CGFloat
    let circleColor: Color
    let image: Image?
    let imageSize: CGFloat
    let imageColor: Color
    let text: String?
    let textColor: Color
    let textFont: Font
    let isSelected: Bool
    let selectedBorderColor: Color
    let selectedBorderWidth: CGFloat
    let action: () -> Void

    // MARK: - Initializer

    init(
        circleSize: CGFloat = 48,
        color: Color = GlobalConstants.AppColor.surface,
        image: Image? = nil,
        imageSize: CGFloat = 24,
        imageColor: Color = Color(hex: 0x000000),
        text: String? = nil,
        textColor: Color = Color(hex: 0x000000),
        textFont: Font = .figtree.semiBold.size(18),
        isSelected: Bool = false,
        selectedBorderColor: Color = GlobalConstants.AppColor.surface,
        selectedBorderWidth: CGFloat = 2,
        action: @escaping () -> Void
    ) {
        self.circleSize = circleSize
        self.circleColor = color
        self.image = image
        self.imageSize = imageSize
        self.imageColor = imageColor
        self.text = text
        self.textColor = textColor
        self.textFont = textFont
        self.action = action
        self.isSelected = isSelected
        self.selectedBorderColor = selectedBorderColor
        self.selectedBorderWidth = selectedBorderWidth
    }

    // MARK: - Main Body

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(size: imageSize)
                        .foregroundStyle(imageColor)
                }

                if let text {
                    Text(text)
                        .foregroundStyle(
                            isSelected
                            ? selectedBorderColor
                            : textColor
                        )
                        .font(textFont)
                }
            }
            .frame(minWidth: circleSize, minHeight: circleSize)
            .background {
                Capsule()
                    .fill(isSelected
                          ? Color(hex: 0x000000)
                          : circleColor
                    )
            }
            .overlay {
                if isSelected {
                    Capsule()
                        .stroke(
                            selectedBorderColor,
                            lineWidth: selectedBorderWidth
                        )
                }
            }
            .shadow(
                color: isSelected
                ? .clear
                : .black.opacity(0.15),
                radius: isSelected ? 0 : 8,
                x: 0,
                y: isSelected ? 0 : 2
            )
        }
        .buttonStyle(.plain)
        .frame(size: circleSize)
    }
}

#Preview {
    ZStack {
        Color.gray
            .ignoresSafeArea()

        CircleButton(
            color: GlobalConstants.AppColor.background,
            image: Image(.minus),
        ) {
            print("Tapped")
        }
    }
}
