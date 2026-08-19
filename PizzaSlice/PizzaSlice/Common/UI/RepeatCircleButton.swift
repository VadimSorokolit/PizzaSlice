//
//  RepeatCircleButton.swift
//  PizzaSlice
//
//  Created by Vadim Sorokolit on 19.08.2026.
//

import SwiftUI

struct RepeatCircleButton: View {

    // MARK: - Properties. Public

    let image: Image
    let imageSize: CGFloat
    let isEnabled: Bool
    let accessibilityLabel: String
    let onStep: () -> Bool

    // MARK: - Main Body

    var body: some View {
        CircleButton(
            image: image,
            imageSize: imageSize,
            action: {}
        )
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.35)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(.isButton)
        .accessibilityAction {
            _ = performStep()
        }
        .simultaneousGesture(pressGesture)
        .onDisappear(perform: stopRepeating)
    }

    // MARK: - Properties. Private

    @State private var isPressing = false
    @State private var repeatTask: Task<Void, Never>?

    private let repeatInitialDelay: Duration = .milliseconds(400)
    private let repeatInterval: Duration = .milliseconds(100)

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                beginPressIfNeeded()
            }
            .onEnded { _ in
                endPress()
            }
    }

    // MARK: - Methods. Private

    private func beginPressIfNeeded() {
        guard isEnabled, !isPressing else { return }

        isPressing = true

        guard performStep() else {
            isPressing = false
            return
        }

        repeatTask = Task { @MainActor in
            try? await Task.sleep(for: repeatInitialDelay)

            while !Task.isCancelled, isPressing, isEnabled {
                if !performStep() {
                    break
                }

                try? await Task.sleep(for: repeatInterval)
            }

            isPressing = false
        }
    }

    private func endPress() {
        isPressing = false
        stopRepeating()
    }

    private func stopRepeating() {
        repeatTask?.cancel()
        repeatTask = nil
    }

    @discardableResult
    private func performStep() -> Bool {
        guard isEnabled else { return false }
        return onStep()
    }
}
