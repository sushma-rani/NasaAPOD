//
//  NasaAPODUITests.swift
//  NasaAPODUITests
//
//  Created by Shivakumar, Sushma on 09/12/22.
//

import XCTest
@testable import NasaAPOD

final class NasaAPODUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(3)
        XCTAssertEqual(app.datePickers.count, 1, "Date picker not found")
        XCTAssertNotNil(app.datePickers["datePicker"])
        XCTAssertNotNil(app.staticTexts["viewTitle"])
        XCTAssertNotNil(app.staticTexts["apodTitle"])
        XCTAssertNotNil(app.staticTexts["apodMessage"])
        XCTAssertNotNil(app.images["image"])
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
