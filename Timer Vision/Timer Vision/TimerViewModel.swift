//
//  TimerViewModel.swift
//  Timer Vision
//
//  Created by IVAN CAMPOS
//

import AVFoundation
import SwiftUI
import RealityKit

class TimerViewModel: ObservableObject {
    enum TimerState {
        case finished
        case running
        case stopped
    }
    
    @Published var timeRemaining: Int = 0
    @Published var hasFinished: Bool = false
    @Published var timerState: TimerState = .stopped
    
    var progress: Double {
        guard timeRemaining != 0 else { return 0 }
        return Double(timeRemaining) / Double(initialTime)
    }
    
    var timeFormatted: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var timer: Timer?
    private var player: AVAudioPlayer?
    private var initialTime: Int = 0
    
    func startTimer(duration: Int) {
        initialTime = duration
        timeRemaining = duration
        timerState = .running
        hasFinished = false
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.hasFinished = true
                self.timerState = .finished
                self.playSound()
                self.timer?.invalidate()
            }
        }
    }
    
    func stopSound() {
        player?.stop()
        timerState = .stopped
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "VirtualityHustle", withExtension: "mp3") else { return }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Couldn't load sound file")
        }
    }
}
