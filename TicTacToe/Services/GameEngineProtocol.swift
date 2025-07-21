//
//  GameEngineProtocol.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

protocol GameEngineProtocol {
    func makeMove(in state: GameState, at index: Int) -> GameState
    func reset() -> GameState
}
