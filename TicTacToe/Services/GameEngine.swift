//
//  GameEngine.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

struct GameEngine: GameEngineProtocol {
    private let winPatterns: [[Int]] = [
        [0,1,2],[3,4,5],[6,7,8],
        [0,3,6],[1,4,7],[2,5,8],
        [0,4,8],[2,4,6]
    ]
    
    func makeMove(in state: GameState, at index: Int) -> GameState {
        var newState = state
        guard newState.board[index].isEmpty, !newState.isGameOver else { return newState }
        
        newState.board[index] = newState.currentPlayer.rawValue
        if let winner = checkWinner(board: newState.board, player: newState.currentPlayer) {
            newState.winner = winner
            newState.statusMessage = "\(winner.rawValue) Wins!"
        } else if !newState.board.contains("") {
            newState.isDraw = true
            newState.statusMessage = "It's a Draw!"
        } else {
            newState.currentPlayer = newState.currentPlayer.next
        }
        return newState
    }
    
    func reset() -> GameState {
        GameState()
    }
    
    private func checkWinner(board: [String], player: Player) -> Player? {
        for pattern in winPatterns {
            let match = pattern.allSatisfy { board[$0] == player.rawValue }
            if match { return player }
        }
        return nil
    }
}
