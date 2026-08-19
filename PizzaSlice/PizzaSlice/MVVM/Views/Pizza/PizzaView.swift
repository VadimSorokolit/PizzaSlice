//
//  PizzaView.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI
import os

enum PizzaSize: String {
    case small = "S"
    case medium = "M"
    case large = "L"

    var cellSize: CGFloat {
        switch self {
            case .small:
                196

            case .medium:
                244

            case .large:
                274
        }
    }

    static let sideCellSize: CGFloat = 80
}

struct PizzaView: View {

    // MARK: - Main Body

    var body: some View {
        GeometryReader { geometry in
            let sideInset = (geometry.size.width - pizzaViewModel.selectedSize.cellSize) / 2
            let sidePeek = PizzaSize.sideCellSize / 2
            let carouselSpacing = max(sideInset - sidePeek, 0)

            VStack(spacing: 0) {
                HeaderView(isZoomed: isZoomed, isVisible: isVisible)

                Spacer()

                BottomView(isVisible: $isVisible,
                           screenHeight: geometry.size.height
                )
                .offset(y: isZoomed ? bottomSlideDistance : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: .bottom)
            .background(alignment: .top) {
                ZStack(alignment: .bottom) {
                    Circle()
                        .fill(GlobalConstants.AppColor.background)
                        .frame(size: circleSize)
                        .opacity(isZoomed ? 0 : 1)

                    HStack(spacing: carouselSpacing) {
                        ForEach(Array(pizzaViewModel.pizzas.indices), id: \.self) { index in
                            let pizza = pizzaViewModel.pizzas[index]
                            let isSelected = index == pizzaViewModel.selectedIndex

                            PizzaCell(
                                pizza: pizza,
                                size: isSelected
                                    ? pizzaViewModel.selectedSize.cellSize
                                    : PizzaSize.sideCellSize,
                                showsExpandControl: isSelected && !isZoomed,
                                onExpand: {
                                    withAnimation(GlobalConstants.Motion.fullScreenZoom) {
                                        isZoomed = true
                                    }
                                }
                            )
                            .scaleEffect(isSelected && isZoomed ? zoomScale(screen: geometry.size) * pinchAmount : 1)
                            .shadow(
                                color: .black.opacity(isSelected && isZoomed ? zoomShadowOpacity : 0),
                                radius: zoomShadowBlur / 2,
                                x: 0,
                                y: zoomShadowOffsetY
                            )
                            .opacity(isSelected || !isZoomed ? 1 : 0)
                            .offset(x: sidePizzaSpreadOffset(at: index))
                            .zIndex(isSelected ? 1 : 0)
                            .onTapGesture {
                                guard !isSelected else { return }

                                withAnimation(.interpolatingSpring(mass: 1, stiffness: 400, damping: 30)) {
                                    pizzaViewModel.handleSelectPizza(at: index)
                                }
                            }
                        }
                    }
                    .opacity(isVisible ? 1 : 0)
                    .frame(width: geometry.size.width, alignment: .leading)
                    .offset(x: carouselOffsetX(width: geometry.size.width, spacing: carouselSpacing))
                    .offset(
                        y: -pizzaBottomOffset +
                            pizzaViewModel.selectedSize.cellSize / 2 +
                            (isZoomed
                                ? zoomCenteringOffsetY(screenHeight: geometry.size.height)
                                : 0)
                    )
                    .animation(GlobalConstants.Motion.sizeChange, value: pizzaViewModel.selectedSize)
                    .animation(GlobalConstants.Motion.carousel, value: pizzaViewModel.selectedIndex)
                    .animation(GlobalConstants.Motion.fullScreenZoom, value: isZoomed)

                    CircleBottomView(
                        pizzaViewModel: pizzaViewModel,
                        isZoomed: isZoomed,
                        isVisible: isVisible
                    )
                }
                .offset(y: -circleTopOffset)
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture(minimumDistance: 30)
                        .onEnded { value in
                            let threshold: CGFloat = 40

                            if value.translation.width < -threshold {
                                withAnimation(.interpolatingSpring(mass: 1, stiffness: 400, damping: 30)) {
                                    pizzaViewModel.handleSelectPizza(
                                        at: pizzaViewModel.selectedIndex + 1
                                    )
                                }
                            } else if value.translation.width > threshold {
                                withAnimation(.interpolatingSpring(mass: 1, stiffness: 400, damping: 30)) {
                                    pizzaViewModel.handleSelectPizza(
                                        at: pizzaViewModel.selectedIndex - 1
                                    )
                                }
                            }
                        }
                )
            }
            .ignoresSafeArea(edges: .top)
            .overlay {
                if isZoomed {
                    Color.clear
                        .contentShape(Rectangle())
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(GlobalConstants.Motion.fullScreenZoom) {
                                isZoomed = false
                                pinchScale = 1.0
                                livePinch = 1.0
                            }
                        }
                        .gesture(
                            MagnifyGesture()
                                .onChanged { value in
                                    livePinch = value.magnification
                                }
                                .onEnded { value in
                                    pinchScale = min(max(pinchScale * value.magnification, 1.0), maxPinch)
                                    livePinch = 1
                                }
                        )
                }
            }
        }
        .onAppear {
            withAnimation(.interpolatingSpring(mass: 1, stiffness: 170, damping: 20)) {
                isVisible = true
            }
        }
    }

    // MARK: - Properties. Private

    @Environment(PizzasViewModel.self) private var pizzaViewModel
    @State private var isVisible = false
    @State private var isZoomed = false
    @State private var pinchScale: CGFloat = 1.0
    @State private var livePinch: CGFloat = 1.0
    private let maxPinch: CGFloat = 3.0

    private var pinchAmount: CGFloat {
        min(max(pinchScale * livePinch, 1.0), maxPinch)
    }

    private let circleSize: CGFloat = 607
    private let circleTopOffset: CGFloat = 87
    private let headerSlideDistance: CGFloat = 160
    private let bottomSlideDistance: CGFloat = 220
    private let sidePizzaSpreadDistance: CGFloat = 220
    private let zoomOvershoot: CGFloat = 2.0

    private let zoomShadowOpacity: Double = 0.05
    private let zoomShadowBlur: CGFloat = 104
    private let zoomShadowOffsetY: CGFloat = 24
    private let pizzaBottomOffset: CGFloat = 238

    // MARK: - Methods. Private

    private func zoomScale(screen: CGSize) -> CGFloat {
        max(screen.width, screen.height)
        / PizzaSize.large.cellSize
        * zoomOvershoot
    }

    private func zoomCenteringOffsetY(screenHeight: CGFloat) -> CGFloat {
        let pizzaCenterY = circleSize
            - circleTopOffset
            - pizzaBottomOffset
            - pizzaViewModel.selectedSize.cellSize / 2

        return screenHeight / 2 - pizzaCenterY
    }

    private func sidePizzaSpreadOffset(at index: Int) -> CGFloat {
        guard isZoomed, index != pizzaViewModel.selectedIndex else { return 0 }

        return index < pizzaViewModel.selectedIndex
            ? -sidePizzaSpreadDistance
            : sidePizzaSpreadDistance
    }

    private func cellWidth(at index: Int) -> CGFloat {
        index == pizzaViewModel.selectedIndex
            ? pizzaViewModel.selectedSize.cellSize
            : PizzaSize.sideCellSize
    }

    private func carouselOffsetX(width: CGFloat, spacing: CGFloat) -> CGFloat {
        let selected = pizzaViewModel.selectedIndex

        guard pizzaViewModel.pizzas.indices.contains(selected) else { return 0 }

        var centerX: CGFloat = 0

        for index in 0..<selected {
            centerX += cellWidth(at: index) + spacing
        }

        centerX += cellWidth(at: selected) / 2

        return width / 2 - centerX
    }

    // MARK: - Subviews. Private

    private struct HeaderView: View {

        let isZoomed: Bool
        let isVisible: Bool

        private var isHidden: Bool { isZoomed || !isVisible }

        var body: some View {
            HStack {
                CircleButton(
                    image: Image(.barIconBack),
                    action: {
                        AppLogger.app.info("Back button tapped")
                    }
                )
                .offset(x: isHidden ? -buttonSlideDistance : 0)
                .opacity(isHidden ? 0 : 1)

                Spacer()

                CircleButton(
                    image: Image(.iconFav),
                    action: {
                        AppLogger.app.info("Fav button tapped")
                    }
                )
                .offset(x: isHidden ? buttonSlideDistance : 0)
                .opacity(isHidden ? 0 : 1)
            }
            .padding(.horizontal, headerHorizontalPadding)
            .overlay {
                VStack(spacing: 0) {
                    Text("Pizzas")
                        .foregroundStyle(Color(hex: 0x000000).opacity(0.7))
                        .font(.figtree.regular.size(10))
                        .frame(height: 5)

                    Text(pizzaViewModel.selectedPizza?.name ?? "")
                        .foregroundStyle(Color(hex: 0x000000))
                        .font(.figtree.semiBold.size(24))
                }
                .offset(y: isHidden ? -textSlideDistance : -4)
                .opacity(isHidden ? 0 : 1)
            }
            .padding(.bottom, contentBottomPadding)
            .frame(maxWidth: .infinity)
            .frame(height: headerHeight, alignment: .bottom)
        }

        @Environment(PizzasViewModel.self) private var pizzaViewModel

        private let headerHeight: CGFloat = 128
        private let headerHorizontalPadding: CGFloat = 24
        private let contentBottomPadding: CGFloat = 18
        private let buttonSlideDistance: CGFloat = 80
        private let textSlideDistance: CGFloat = 100
    }

    private struct CircleBottomView: View {

        // MARK: - Properties. Public

        let pizzaViewModel: PizzasViewModel
        let isZoomed: Bool
        let isVisible: Bool

        private var isHidden: Bool { isZoomed || !isVisible }

        // MARK: - Body

        var body: some View {
            ZStack(alignment: .top) {
                Rectangle()
                    .fill(.clear)

                HStack(alignment: .top) {
                    CircleButton(
                        text: PizzaSize.small.rawValue,
                        isSelected: pizzaViewModel.isSelected(.small),
                        action: {
                            pizzaViewModel.handlePizzaSize(.small)
                        }
                    )

                    Spacer()

                    CircleButton(
                        text: PizzaSize.large.rawValue,
                        isSelected: pizzaViewModel.isSelected(.large),
                        action: {
                            pizzaViewModel.handlePizzaSize(.large)
                        }
                    )
                }

                Image(.banana)
                    .resizable()
                    .scaledToFit()
                    .frame(width: bananaImageWidth, height: bananaImageHeight)
                    .offset(y: -bananaImageOffset)

                CircleButton(
                    text: PizzaSize.medium.rawValue,
                    isSelected: pizzaViewModel.isSelected(.medium),
                    action: {
                        pizzaViewModel.handlePizzaSize(.medium)
                    }
                )
                .frame(maxHeight: .infinity, alignment: .bottom)

            }
            .frame(width: rectangleWidth, height: rectangleHeight)
            .offset(y: isHidden ? slideDownDistance : 24)
            .opacity(isHidden ? 0 : 1)
        }

        // MARK: - Properties. Private

        let rectangleHeight: CGFloat = 64
        let rectangleWidth: CGFloat = 244
        let bananaImageWidth: CGFloat = 97
        let bananaImageHeight: CGFloat = 63
        let bananaImageOffset: CGFloat = 36
        let sideSpreadDistance: CGFloat = 160
        let slideDownDistance: CGFloat = 400
    }

    private struct BottomView: View {

        // MARK: - Properties. Public

        @Binding var isVisible: Bool

        let screenHeight: CGFloat

        // MARK: - Body

        var body: some View {
            if screenHeight > GlobalConstants.Screen.iPhoneSEHeight {
                content
                    .padding(.bottom, defaultBottomPadding)
            } else {
                ScrollView {
                    content
                        .padding(.bottom, 10)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
            }
        }

        // MARK: - Properties. Private

        @Environment(PizzasViewModel.self) private var pizzaViewModel

        let defaultBottomPadding: CGFloat = 57
        let defaultVerticalPadding: CGFloat = 40
        let defaultHorizontalPadding: CGFloat = 24
        let descriptionSlideDistance: CGFloat = 60

        @ViewBuilder
        private var content: some View {
            VStack(spacing: defaultVerticalPadding) {
                Text(pizzaViewModel.selectedPizza?.description ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.figtree.regular.size(14))
                    .multilineTextAlignment(.leading)
                    .padding(.leading, 40)
                    .padding(.trailing, 21)
                    .offset(y: isVisible ? 0 : descriptionSlideDistance)
                    .opacity(isVisible ? 1 : 0)

                HStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(GlobalConstants.AppColor.background)

                        HStack {
                            RepeatCircleButton(
                                image: Image(.minus),
                                imageSize: 14,
                                isEnabled: true,
                                accessibilityLabel: "Decrease quantity",
                                onStep: {
                                    guard pizzaViewModel.canDecreaseQuantity else { return false }

                                    pizzaViewModel.handleDecreaseQuantity()
                                    return pizzaViewModel.canDecreaseQuantity
                                }
                            )

                            Spacer()

                            RepeatCircleButton(
                                image: Image(.plus),
                                imageSize: 14,
                                isEnabled: true,
                                accessibilityLabel: "Increase quantity",
                                onStep: {
                                    pizzaViewModel.handleIncreaseQuantity()
                                    return true
                                }
                            )
                            .opacity(isVisible ? 1 : 0)
                        }

                        Text("\(pizzaViewModel.quantity)")
                            .frame(width: 42)
                            .font(.figtree.extraBold.size(24))
                    }
                    .frame(width: 143)

                    Spacer()

                    Text(String(format: "$%.2f", pizzaViewModel.totalPrice))
                        .font(.figtree.extraBold.size(24))

                    Spacer()

                    Button(action: {
                        AppLogger.app.info("Add button tapped")
                    }, label: {
                        Capsule()
                            .frame(width: 83)
                            .foregroundStyle(Color(hex: 0x19C4EA))
                            .overlay {
                                Text("Add")
                                    .foregroundStyle(GlobalConstants.AppColor.surface)
                                    .font(.figtree.extraBold.size(24))
                            }
                    })
                }
                .frame(height: 48)
                .padding(.leading, defaultHorizontalPadding + 1)
                .padding(.trailing, defaultHorizontalPadding)
            }
        }
    }
}

#Preview {
    PizzaView()
        .environment(PizzasViewModel(networkService: NetworkService()))
}
