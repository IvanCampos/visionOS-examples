//
//  ContentView.swift
//  Timer Vision
//
//  Created by IVAN CAMPOS
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var timerViewModel = TimerViewModel()
    @State private var inputSeconds: String = ""
    
    let CUSTOM_FONT = "Audiowide-Regular"
    
    var body: some View {
        ZStack {
            Color.white.opacity(0.0).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                if timerViewModel.timerState == .stopped {
                    TextField("Sec", text: $inputSeconds)
                        .padding()
                        .foregroundColor(Color.blue)
                        .background(Color.white)
                        .cornerRadius(5)
                        .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.gray, lineWidth: 1))
                        .keyboardType(.numberPad)
                        .font(.custom(CUSTOM_FONT, size: 36))
                        .multilineTextAlignment(.center)
                        .frame(width: 200)
                        .padding()
                    
                    Button("Start Timer") {
                        if let seconds = Int(inputSeconds) {
                            timerViewModel.startTimer(duration: seconds)
                        }
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                } else {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(1.0)
                            .foregroundColor(Color.gray)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(timerViewModel.progress))
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(timerViewModel.hasFinished ? .gray : .green)
                            .rotationEffect(Angle(degrees: -90))
                            .animation(.linear, value: timerViewModel.progress)
                        
                        // Place the time-formatted text in the center of the circle
                        Text(timerViewModel.timeFormatted)
                            .font(.custom(CUSTOM_FONT, size: 42))
                            .fontWeight(.bold)
                            .foregroundColor(timerViewModel.hasFinished ? .gray : .white)
                    }
                    .frame(width: 200, height: 200)
                }
                
                if timerViewModel.hasFinished {
                    Button("Stop Sound") {
                        timerViewModel.stopSound()
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .clipShape(Capsule())
                }
            }
        }
        .font(.custom(CUSTOM_FONT, size: 0.3))
    }
}
