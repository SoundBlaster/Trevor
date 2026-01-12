// TrevorTests.swift
import XCTest

@testable import TrevorLibrary

final class TrevorTests: XCTestCase {
    func testGreet() {
        XCTAssertEqual(TrevorLibrary.greet(), "Hello, Trevor!")
    }
}
