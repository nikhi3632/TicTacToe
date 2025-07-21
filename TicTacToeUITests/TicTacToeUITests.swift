//
//  TicTacToeUITests.swift
//  TicTacToeUITests
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/21/25.
//

import XCTest

final class TicTacToeUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        if self.name != "testLaunchPerformance" {
            app.launch()
        }

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func tapSequence(_ moves: [Int]) {
        for index in moves {
            let cell = app.buttons["Cell\(index)"]
            XCTAssertTrue(cell.exists, "Cell\(index) should exist")
            cell.tap()
        }
    }

    func assertCell(_ index: Int, hasLabel expected: String) {
        let cell = app.buttons["Cell\(index)"]
        XCTAssertEqual(cell.label, expected)
    }

    func resetGame() {
        let resetButton = app.buttons["ResetButton"]
        XCTAssertTrue(resetButton.exists)
        resetButton.tap()
    }

    @MainActor
    func testPlayerXWins() {
        // X: 0, 1, 2
        tapSequence([0, 3, 1, 4, 2])

        let status = app.staticTexts["X Wins!"]
        XCTAssertTrue(status.waitForExistence(timeout: 2.0), "X should win and status should be visible")

        // Ensure winner's cells are correct
        assertCell(0, hasLabel: "X")
        assertCell(1, hasLabel: "X")
        assertCell(2, hasLabel: "X")
    }

    @MainActor
    func testPlayerOWins() {
        // O: 2, 4, 6
        tapSequence([0, 2, 1, 4, 3, 6])

        let status = app.staticTexts["O Wins!"]
        XCTAssertTrue(status.waitForExistence(timeout: 2.0), "O should win and status should be visible")

        assertCell(2, hasLabel: "O")
        assertCell(4, hasLabel: "O")
        assertCell(6, hasLabel: "O")
    }

    @MainActor
    func testDrawGame() {
        // Fill board to draw state
        tapSequence([0, 1, 2, 4, 3, 5, 7, 6, 8])
        let drawStatus = app.staticTexts["It's a Draw!"]
        XCTAssertTrue(drawStatus.waitForExistence(timeout: 2.0))
    }

    @MainActor
    func testResetGameClearsBoard() {
        app.buttons["Cell0"].tap()
        assertCell(0, hasLabel: "X")

        resetGame()
        assertCell(0, hasLabel: "")
    }

    @MainActor
    func testInvalidMoveIsIgnored() {
        let cell = app.buttons["Cell0"]
        cell.tap()
        XCTAssertEqual(cell.label, "X")

        cell.tap() // Second tap should be ignored
        XCTAssertEqual(cell.label, "X", "Should not overwrite X with O")
    }

    @MainActor
    func testStatusLabelUpdatesCorrectly() {
        XCTAssertTrue(app.staticTexts["Player X's Turn"].exists)
        app.buttons["Cell0"].tap()
        XCTAssertTrue(app.staticTexts["Player O's Turn"].exists)
        app.buttons["Cell1"].tap()
        XCTAssertTrue(app.staticTexts["Player X's Turn"].exists)
    }

    @MainActor
    func testAllCellsAccessible() {
        for i in 0..<9 {
            let cell = app.buttons["Cell\(i)"]
            XCTAssertTrue(cell.exists, "Cell\(i) is missing")
        }
    }

    @MainActor
    func testGameStatusAfterWinPreventsMoves() {
        tapSequence([0, 3, 1, 4, 2]) // X wins

        let cell = app.buttons["Cell5"]
        let labelBefore = cell.label
        cell.tap()
        let labelAfter = cell.label

        XCTAssertEqual(labelBefore, labelAfter, "No moves should be allowed after game ends")
    }

    @MainActor
    func testGameStatusAfterDrawPreventsMoves() {
        tapSequence([0,1,2,4,3,5,7,6,8]) // Draw

        let cell = app.buttons["Cell0"]
        let labelBefore = cell.label
        cell.tap()
        let labelAfter = cell.label

        XCTAssertEqual(labelBefore, labelAfter, "No moves should be allowed after a draw")
    }

    @MainActor
    func testLaunchPerformance() throws {
        guard #available(iOS 16.0, *) else { return }
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let launchApp = XCUIApplication()
            launchApp.launch()
        }
    }
}
