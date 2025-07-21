//
//  ConfettiView.swift
//  TicTacToe
//
//  Created by NIKHILESH KUMAR REDDY ANAM on 7/20/25.
//

import SwiftUI

struct ConfettiView: View {
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ForEach(0..<20, id: \.self) { i in
                Circle()
                    .fill(randomColor())
                    .frame(width: 6, height: 6)
                    .position(
                        x: CGFloat.random(in: 0...geo.size.width),
                        y: animate ? geo.size.height + 20 : -20
                    )
                    .animation(
                        .easeInOut(duration: Double.random(in: 1.0...2.0))
                            .delay(Double(i) * 0.03),
                        value: animate
                    )
            }
        }
        .ignoresSafeArea()
        .onAppear { animate = true }
    }

    private func randomColor() -> Color {
        [.red, .blue, .green, .yellow, .orange, .purple].randomElement() ?? .white
    }
}
