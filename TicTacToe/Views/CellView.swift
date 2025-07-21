//
//  CellView.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

import SwiftUI

struct CellView: View {
    let mark: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.primary.opacity(0.1))
                .aspectRatio(1, contentMode: .fit)

            Text(mark)
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(.primary)
        }
        .animation(.easeInOut, value: mark)
    }
}

