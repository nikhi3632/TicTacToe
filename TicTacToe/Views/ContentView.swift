//
//  ContentView.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(viewModel.state.statusMessage ?? "Player \(viewModel.state.currentPlayer.rawValue)'s Turn")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.top)

                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3), spacing: 10) {
                    ForEach(0..<9, id: \.self) { index in
                        CellView(mark: viewModel.state.board[index])
                            .onTapGesture {
                                viewModel.tapCell(at: index)
                            }
                            .accessibilityIdentifier("Cell\(index)")
                    }
                }
                .padding(.horizontal)

                Button("Reset Game") {
                    viewModel.resetGame()
                }
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .accessibilityIdentifier("ResetButton")
            }

            if viewModel.state.winner != nil {
                ConfettiView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: viewModel.state.winner)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)   // Optional: Preview light mode
        ContentView()
            .preferredColorScheme(.dark)    // Optional: Preview dark mode
    }
}
