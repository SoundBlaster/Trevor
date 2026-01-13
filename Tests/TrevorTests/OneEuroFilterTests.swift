//
//  OneEuroFilterTests.swift
//  TrevorTests
//
//  Created by Trevor on 2024-10-01.
//  Copyright © 2024 Trevor. All rights reserved.
//

import XCTest

@testable import TrevorLibrary

final class OneEuroFilterTests: XCTestCase {

    func testNoNaNOutput() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)
        let (x, y) = filter.filter(x: 0.0, y: 0.0, timestamp: 0.0)
        XCTAssertFalse(x.isNaN)
        XCTAssertFalse(y.isNaN)
    }

    func testNoInfiniteOutput() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)
        let (x, y) = filter.filter(x: 0.0, y: 0.0, timestamp: 0.0)
        XCTAssertFalse(x.isInfinite)
        XCTAssertFalse(y.isInfinite)
    }

    func testFilterInvariants() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)

        // Test output magnitude ≤ input magnitude
        let (x1, y1) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.0)
        XCTAssertLessThanOrEqual(abs(x1), 10.0)
        XCTAssertLessThanOrEqual(abs(y1), 10.0)

        // Test smooth transition (no sudden jumps in output)
        let (x2, y2) = filter.filter(x: 10.1, y: 10.1, timestamp: 0.01)
        XCTAssertLessThan(abs(x2 - x1), 10.0)
        XCTAssertLessThan(abs(y2 - y1), 10.0)

        // Test monotonic response to step input
        let (x3, y3) = filter.filter(x: 11.0, y: 11.0, timestamp: 0.02)
        XCTAssertGreaterThanOrEqual(x3, x2)
        XCTAssertGreaterThanOrEqual(y3, y2)
    }

    func testDeltaTimeHandling() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)

        // Test dt=0 doesn't cause division by zero
        let (x1, y1) = filter.filter(x: 1.0, y: 1.0, timestamp: 0.0)
        XCTAssertFalse(x1.isNaN)
        XCTAssertFalse(y1.isNaN)

        // Test large dt doesn't destabilize filter
        let (x2, y2) = filter.filter(x: 2.0, y: 2.0, timestamp: 10.0)
        XCTAssertFalse(x2.isNaN)
        XCTAssertFalse(y2.isNaN)

        // Test variable frame rates
        let (x3, y3) = filter.filter(x: 3.0, y: 3.0, timestamp: 10.1)
        XCTAssertFalse(x3.isNaN)
        XCTAssertFalse(y3.isNaN)
    }

    func testEdgeCases() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)

        // Test initialization
        let (x1, y1) = filter.filter(x: 0.0, y: 0.0, timestamp: 0.0)
        XCTAssertEqual(x1, 0.0)
        XCTAssertEqual(y1, 0.0)

        // Test repeated identical inputs (convergence)
        let (x2, y2) = filter.filter(x: 1.0, y: 1.0, timestamp: 0.01)
        let (x3, y3) = filter.filter(x: 1.0, y: 1.0, timestamp: 0.02)
        XCTAssertLessThan(abs(x3 - x2), 1.0)
        XCTAssertLessThan(abs(y3 - y2), 1.0)

        // Test sign changes (tremor in opposite directions)
        let (x4, y4) = filter.filter(x: -1.0, y: -1.0, timestamp: 0.03)
        XCTAssertLessThan(abs(x4 - x3), 5.0)
        XCTAssertLessThan(abs(y4 - y3), 5.0)

        // Test mixed input rates (variable Hz)
        let (x5, y5) = filter.filter(x: 2.0, y: 2.0, timestamp: 0.04)
        let (x6, y6) = filter.filter(x: 3.0, y: 3.0, timestamp: 0.1)
        XCTAssertFalse(x5.isNaN)
        XCTAssertFalse(y5.isNaN)
        XCTAssertFalse(x6.isNaN)
        XCTAssertFalse(y6.isNaN)
    }

    func testPerformance() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)

        // Measure performance
        measure {
            for i in 0..<1000 {
                let timestamp = Double(i) * 0.01
                let (_, _) = filter.filter(x: Double(i), y: Double(i), timestamp: timestamp)
            }
        }
    }

    func testPresetInitialization() {
        // Test initialization with each preset
        let fineControlFilter = OneEuroFilter(frequency: 60.0, preset: .fineControl)
        let balancedFilter = OneEuroFilter(frequency: 60.0, preset: .balanced)
        let aggressiveFilter = OneEuroFilter(frequency: 60.0, preset: .aggressive)

        // Verify filters are initialized
        XCTAssertNotNil(fineControlFilter)
        XCTAssertNotNil(balancedFilter)
        XCTAssertNotNil(aggressiveFilter)
    }

    func testPresetApplication() {
        let filter = OneEuroFilter(
            frequency: 60.0, minCutoff: 1.0, beta: 0.1, derivativeCutoff: 1.0)

        // Apply fine control preset
        filter.applyPreset(.fineControl)
        let (x1, y1) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.0)

        // Apply balanced preset
        filter.applyPreset(.balanced)
        let (x2, y2) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.1)

        // Apply aggressive preset
        filter.applyPreset(.aggressive)
        let (x3, y3) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.2)

        // Verify outputs are different (presets produce distinct results)
        XCTAssertNotEqual(x1, x2)
        XCTAssertNotEqual(y1, y2)
        XCTAssertNotEqual(x2, x3)
        XCTAssertNotEqual(y2, y3)
    }

    func testPresetParameters() {
        // Test that each preset has valid parameters
        let presets = Preset.allCases
        for preset in presets {
            let params = preset.parameters
            XCTAssertGreaterThan(params.minCutoff, 0)
            XCTAssertGreaterThan(params.beta, 0)
            XCTAssertGreaterThan(params.derivativeCutoff, 0)
        }
    }

    func testPresetSwitchingSmoothness() {
        let filter = OneEuroFilter(frequency: 60.0, preset: .balanced)

        // Filter some values with balanced preset
        let (_, _) = filter.filter(x: 5.0, y: 5.0, timestamp: 0.0)
        let (x2, y2) = filter.filter(x: 5.1, y: 5.1, timestamp: 0.1)

        // Switch to aggressive preset
        filter.applyPreset(.aggressive)

        // Filter more values - should be smooth transition
        let (x3, y3) = filter.filter(x: 5.2, y: 5.2, timestamp: 0.2)
        let (x4, y4) = filter.filter(x: 5.3, y: 5.3, timestamp: 0.3)

        // Verify no sudden jumps in output
        XCTAssertLessThan(abs(x3 - x2), 10.0)
        XCTAssertLessThan(abs(y3 - y2), 10.0)
        XCTAssertLessThan(abs(x4 - x3), 10.0)
        XCTAssertLessThan(abs(y4 - y3), 10.0)
    }

    // MARK: - Slider Mapping Tests

    func testSliderMappingMin() {
        let params = OneEuroFilter.parametersForSliderPosition(0.0)
        XCTAssertEqual(params.minCutoff, 1.0, accuracy: 0.01)
        XCTAssertEqual(params.beta, 0.1, accuracy: 0.01)
        XCTAssertEqual(params.derivativeCutoff, 1.0, accuracy: 0.01)
    }

    func testSliderMappingMax() {
        let params = OneEuroFilter.parametersForSliderPosition(1.0)
        XCTAssertEqual(params.minCutoff, 3.0, accuracy: 0.01)
        XCTAssertEqual(params.beta, 0.5, accuracy: 0.01)
        XCTAssertEqual(params.derivativeCutoff, 3.0, accuracy: 0.01)
    }

    func testSliderMappingMid() {
        let params = OneEuroFilter.parametersForSliderPosition(0.5)
        XCTAssertEqual(params.minCutoff, 2.0, accuracy: 0.01)
        XCTAssertEqual(params.beta, 0.3, accuracy: 0.01)
        XCTAssertEqual(params.derivativeCutoff, 2.0, accuracy: 0.01)
    }

    func testSliderMappingClamping() {
        // Test that slider positions outside [0, 1] are clamped
        let belowMin = OneEuroFilter.parametersForSliderPosition(-0.5)
        let aboveMax = OneEuroFilter.parametersForSliderPosition(1.5)

        XCTAssertEqual(belowMin.minCutoff, 1.0, accuracy: 0.01)
        XCTAssertEqual(aboveMax.minCutoff, 3.0, accuracy: 0.01)
    }

    func testSliderApplication() {
        let filter = OneEuroFilter(frequency: 60.0, preset: .balanced)

        // Apply min slider position
        filter.applySliderPosition(0.0)
        let (x1, y1) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.0)

        // Apply max slider position
        filter.applySliderPosition(1.0)
        let (x2, y2) = filter.filter(x: 10.0, y: 10.0, timestamp: 0.1)

        // Verify outputs are different
        XCTAssertNotEqual(x1, x2)
        XCTAssertNotEqual(y1, y2)
    }

    func testSliderInitialization() {
        // Test initialization with slider positions
        let minFilter = OneEuroFilter(frequency: 60.0, sliderPosition: 0.0)
        let maxFilter = OneEuroFilter(frequency: 60.0, sliderPosition: 1.0)

        XCTAssertNotNil(minFilter)
        XCTAssertNotNil(maxFilter)
    }

    func testSliderSmoothness() {
        _ = OneEuroFilter(frequency: 60.0, sliderPosition: 0.5)

        // Test small changes in slider position
        let params1 = OneEuroFilter.parametersForSliderPosition(0.5)
        let params2 = OneEuroFilter.parametersForSliderPosition(0.51)

        // Verify small changes result in small parameter differences
        XCTAssertLessThan(abs(params2.minCutoff - params1.minCutoff), 0.1)
        XCTAssertLessThan(abs(params2.beta - params1.beta), 0.1)
        XCTAssertLessThan(abs(params2.derivativeCutoff - params1.derivativeCutoff), 0.1)
    }
}
