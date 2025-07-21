//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

import Foundation

final class GameViewModel: ObservableObject {
    @Published private(set) var state: GameState
    private let engine: GameEngineProtocol
    
    init(engine: GameEngineProtocol = GameEngine()) {
        self.engine = engine
        self.state = engine.reset()
    }
    
    func tapCell(at index: Int) {
        state = engine.makeMove(in: state, at: index)
    }
    
    func resetGame() {
        state = engine.reset()
    }
}
