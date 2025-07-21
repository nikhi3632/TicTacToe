//
//  Player.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

enum Player: String {
    case x = "X"
    case o = "O"
    
    var next: Player {
        self == .x ? .o : .x
    }
}
