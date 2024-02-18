//
//  TypewriterEffect.swift
//  ChatAVP
//
//  Created by IVAN CAMPOS on 2/18/24.
//

import SwiftUI

struct TypewriterText: View {
    let fullText: String
    let speed: TimeInterval
    @State private var visibleCharactersCount: Int = 0
    private let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        Text(String(fullText.prefix(visibleCharactersCount)))
            .font(.system(size: 24, weight: .bold, design: .monospaced)) // Customize font as needed
            .padding()
            .lineLimit(nil) // Ensure there is no line limit
            .fixedSize(horizontal: false, vertical: true) // Allow the text to grow vertically
            .multilineTextAlignment(.leading) // Align text to the left
            .onReceive(timer) { _ in
                // Incrementally reveal the text
                if visibleCharactersCount < fullText.count {
                    visibleCharactersCount += 1
                } else {
                    timer.upstream.connect().cancel() // Stop the timer when the entire text is displayed
                }
            }
            .onAppear {
                // Reset the visible character count when the view appears
                visibleCharactersCount = 0
            }
    }
}
