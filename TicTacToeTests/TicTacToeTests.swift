//
//  TicTacToeTests.swift
//  TicTacToeTests
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/21/25.
//

import XCTest
@testable import TicTacToe

final class TicTacToeTests: XCTestCase {
    
    var engine: GameEngine!
    var initialState: GameState!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
        engine = GameEngine()
        initialState = engine.reset()
    }

    func testInitialBoardIsEmpty() {
        XCTAssertEqual(initialState.board.filter { !$0.isEmpty }.count, 0)
        XCTAssertEqual(initialState.currentPlayer, .x)
        XCTAssertNil(initialState.winner)
        XCTAssertFalse(initialState.isGameOver)
    }

    func testValidMoveChangesBoard() {
        let newState = engine.makeMove(in: initialState, at: 0)
        XCTAssertEqual(newState.board[0], "X")
        XCTAssertEqual(newState.currentPlayer, .o)
    }

    func testInvalidMoveIsIgnored() {
        var state = engine.makeMove(in: initialState, at: 0)
        state = engine.makeMove(in: state, at: 0) // Already taken
        XCTAssertEqual(state.board[0], "X")
        XCTAssertEqual(state.currentPlayer, .o) // Should not have changed
    }

    func testWinDetection() {
        guard var state = initialState else {
            XCTFail("Initial state was nil")
            return
        }
        state.board = ["X", "X", "",
                       "", "", "",
                       "", "", ""]
        state.currentPlayer = Player.x

        let result = engine.makeMove(in: state, at: 2)

        XCTAssertEqual(result.winner, .x)
        XCTAssertEqual(result.statusMessage, "X Wins!")
    }

    func testDrawDetection() {
        let state = GameState(board: ["X", "O", "X",
                                      "X", "O", "O",
                                      "O", "X", ""],
                              currentPlayer: .x)
        let result = engine.makeMove(in: state, at: 8)
        XCTAssertTrue(result.isDraw)
        XCTAssertNil(result.winner)
        XCTAssertEqual(result.statusMessage, "It's a Draw!")
    }

    func testResetClearsGame() {
        var state = engine.makeMove(in: initialState, at: 0)
        state = engine.makeMove(in: state, at: 1)
        let resetState = engine.reset()
        XCTAssertEqual(resetState.board.filter { !$0.isEmpty }.count, 0)
        XCTAssertEqual(resetState.currentPlayer, .x)
        XCTAssertNil(resetState.winner)
    }
}
