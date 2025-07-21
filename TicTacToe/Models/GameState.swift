//
//  GameState.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

struct GameState {
    var board: [String] = Array(repeating: "", count: 9)
    var currentPlayer: Player = .x
    var winner: Player? = nil
    var isDraw: Bool = false
    var statusMessage: String? = nil
    
    var isGameOver: Bool {
        winner != nil || isDraw
    }
}
