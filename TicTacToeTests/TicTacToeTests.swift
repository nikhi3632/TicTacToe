//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/21/25.
//

import XCTest
@testable import TicTacToe

final class TicTacToeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGameResetsCorrectly() throws {
        let engine = GameEngine()
        let state = engine.reset()

        // Expect 9 empty cells and no winner
        XCTAssertEqual(state.board.count, 9)
        XCTAssertTrue(state.board.allSatisfy { $0 == "" })
        XCTAssertNil(state.winner)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
