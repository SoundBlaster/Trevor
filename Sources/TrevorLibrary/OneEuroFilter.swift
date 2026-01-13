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

/// Preset configurations for the One Euro filter
///
/// Each preset provides a predefined set of parameters optimized for different use cases.
public enum Preset: String, CaseIterable {
    case fineControl
    case balanced
    case aggressive

    /// Returns the parameters for the preset
    public var parameters: (minCutoff: Double, beta: Double, derivativeCutoff: Double) {
        switch self {
        case .fineControl:
            // Minimal smoothing for precise tasks (e.g., graphic design, coding)
            return (minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)
        case .balanced:
            // General use with balanced smoothing
            return (minCutoff: 2.0, beta: 0.3, derivativeCutoff: 2.0)
        case .aggressive:
            // Maximum smoothing for severe tremors
            return (minCutoff: 3.0, beta: 0.5, derivativeCutoff: 3.0)
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
    /// - Parameters:
    ///   - frequency: The expected frequency of the input signal (in Hz)
    ///   - preset: The preset configuration to use
    public convenience init(frequency: Double, preset: Preset) {
        let params = preset.parameters
        self.init(
            frequency: frequency, minCutoff: params.minCutoff, beta: params.beta,
            derivativeCutoff: params.derivativeCutoff)
    }

    /// Initializes a new One Euro Filter with a slider position
    ///
    /// - Parameters:
    ///   - frequency: The expected frequency of the input signal (in Hz)
    ///   - sliderPosition: The slider position (0.0 to 1.0)
    public convenience init(frequency: Double, sliderPosition: Double) {
        let params = OneEuroFilter.parametersForSliderPosition(sliderPosition)
        self.init(
            frequency: frequency, minCutoff: params.minCutoff, beta: params.beta,
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

    /// Applies a preset to the filter
    ///
    /// - Parameter preset: The preset to apply
    public func applyPreset(_ preset: Preset) {
        let params = preset.parameters
        self.minCutoff = params.minCutoff
        self.beta = params.beta
        self.derivativeCutoff = params.derivativeCutoff
    }

    /// Applies a slider position to the filter
    ///
    /// - Parameter sliderPosition: The slider position (0.0 to 1.0)
    public func applySliderPosition(_ sliderPosition: Double) {
        let params = OneEuroFilter.parametersForSliderPosition(sliderPosition)
        self.minCutoff = params.minCutoff
        self.beta = params.beta
        self.derivativeCutoff = params.derivativeCutoff
    }

    /// Maps slider position to filter parameters
    ///
    /// - Parameter sliderPosition: The slider position (0.0 to 1.0)
    /// - Returns: Filter parameters (minCutoff, beta, derivativeCutoff)
    public static func parametersForSliderPosition(_ sliderPosition: Double) -> (
        minCutoff: Double, beta: Double, derivativeCutoff: Double
    ) {
        // Clamp slider position to valid range
        let clampedPosition = max(0.0, min(1.0, sliderPosition))

        // Linear mapping from slider position to filter parameters
        // minCutoff: 1.0 (min) to 3.0 (max)
        // beta: 0.1 (min) to 0.5 (max)
        // derivativeCutoff: 1.0 (min) to 3.0 (max)
        let minCutoff = 1.0 + clampedPosition * 2.0
        let beta = 0.1 + clampedPosition * 0.4
        let derivativeCutoff = 1.0 + clampedPosition * 2.0

        return (minCutoff, beta, derivativeCutoff)
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

    /// Resets the filter state
    public func reset() {
        x = 0.0
        y = 0.0
        dx = 0.0
        dy = 0.0
        lastTime = 0.0
    }
}
