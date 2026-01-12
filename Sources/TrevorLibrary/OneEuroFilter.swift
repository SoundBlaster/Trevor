//
//  OneEuroFilter.swift
//  TrevorLibrary
//
//  Created by Trevor on 2024-10-01.
//  Copyright © 2024 Trevor. All rights reserved.
//

import Foundation

/// One Euro Filter implementation for mouse tremor stabilization
///
/// The One Euro Filter is a low-pass filter that smooths input signals while preserving
/// the responsiveness of the system. It is particularly useful for filtering noisy input
/// signals such as mouse movements affected by tremors.
///
/// Reference: https://www.lifl.fr/~casiez/1euro/

/// Preset configurations for different use cases
public enum Preset: String, CaseIterable {
    case fineControl
    case balanced
    case aggressive

    /// Returns the parameters for the preset
    var parameters: (frequency: Double, minCutoff: Double, beta: Double, derivativeCutoff: Double) {
        switch self {
        case .fineControl:
            return (frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)
        case .balanced:
            return (frequency: 60.0, minCutoff: 2.0, beta: 0.3, derivativeCutoff: 2.0)
        case .aggressive:
            return (frequency: 60.0, minCutoff: 3.0, beta: 0.5, derivativeCutoff: 3.0)
        }
    }
}

public class OneEuroFilter {
    // Filter parameters
    private var frequency: Double
    private var minCutoff: Double
    private var beta: Double
    private var derivativeCutoff: Double

    // State variables
    private var x: Double = 0.0
    private var y: Double = 0.0
    private var dx: Double = 0.0
    private var dy: Double = 0.0
    private var lastTime: Double = 0.0

    /// Initializes a new One Euro Filter
    ///
    /// - Parameters:
    ///   - frequency: The expected frequency of the input signal (in Hz)
    ///   - minCutoff: The minimum cutoff frequency for the filter
    ///   - beta: The speed coefficient for the filter
    ///   - derivativeCutoff: The cutoff frequency for the derivative filter
    public init(frequency: Double, minCutoff: Double, beta: Double, derivativeCutoff: Double) {
        self.frequency = frequency
        self.minCutoff = minCutoff
        self.beta = beta
        self.derivativeCutoff = derivativeCutoff
    }

    /// Initializes a new One Euro Filter with a preset configuration
    ///
    /// - Parameter preset: The preset to use for the filter
    public convenience init(preset: Preset) {
        let params = preset.parameters
        self.init(
            frequency: params.frequency,
            minCutoff: params.minCutoff,
            beta: params.beta,
            derivativeCutoff: params.derivativeCutoff)
    }

    /// Filters the input coordinates using the One Euro Filter algorithm
    ///
    /// - Parameters:
    ///   - x: The x-coordinate of the input
    ///   - y: The y-coordinate of the input
    ///   - timestamp: The timestamp of the input (in seconds)
    /// - Returns: A tuple containing the filtered x and y coordinates
    public func filter(x: Double, y: Double, timestamp: Double) -> (x: Double, y: Double) {
        // Calculate delta time (dt)
        let dt = max(0.0, timestamp - lastTime)
        lastTime = timestamp

        // Normalize dt to avoid instability
        let normalizedDt = dt * frequency

        // Calculate alpha for the filter
        let alpha = calculateAlpha(normalizedDt, cutoff: minCutoff)

        // Calculate alpha for the derivative filter
        let alphaDerivative = calculateAlpha(normalizedDt, cutoff: derivativeCutoff)

        // Calculate the filtered x and y coordinates
        let filteredX = alpha * x + (1 - alpha) * (self.x + alphaDerivative * dx)
        let filteredY = alpha * y + (1 - alpha) * (self.y + alphaDerivative * dy)

        // Update the state variables
        self.dx = alphaDerivative * (filteredX - self.x) + (1 - alphaDerivative) * dx
        self.dy = alphaDerivative * (filteredY - self.y) + (1 - alphaDerivative) * dy
        self.x = filteredX
        self.y = filteredY

        return (filteredX, filteredY)
    }

    /// Calculates the alpha value for the filter
    ///
    /// - Parameters:
    ///   - dt: The normalized delta time
    ///   - cutoff: The cutoff frequency for the filter
    /// - Returns: The alpha value for the filter
    private func calculateAlpha(_ dt: Double, cutoff: Double) -> Double {
        let te = 1.0 / (cutoff * 2.0 * .pi)
        let alpha = 1.0 / (1.0 + te / (dt + 1e-10))  // Add small epsilon to avoid division by zero
        return alpha
    }

    /// Applies a preset to the filter
    ///
    /// - Parameter preset: The preset to apply
    public func applyPreset(_ preset: Preset) {
        let params = preset.parameters
        self.frequency = params.frequency
        self.minCutoff = params.minCutoff
        self.beta = params.beta
        self.derivativeCutoff = params.derivativeCutoff
    }

    /// Resets the filter state
    public func reset() {
        x = 0.0
        y = 0.0
        dx = 0.0
        dy = 0.0
        lastTime = 0.0
    }
}
