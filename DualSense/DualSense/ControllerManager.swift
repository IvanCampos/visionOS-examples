//
//  ControllerManager.swift
//  DualSense
//
//  Created by IVAN CAMPOS on 1/12/25.
//
import SwiftUI
import GameController
import AVFoundation

class ControllerManager: ObservableObject {
    @Published var controllerName: String?
    @Published var lightBar: GCColor?
    @Published var batteryLevel: Float?
    
    // Face Buttons
    @Published var buttonA: Bool = false
    @Published var buttonB: Bool = false
    @Published var buttonX: Bool = false
    @Published var buttonY: Bool = false

    // Trigger values
    @Published var leftTriggerValue: Float = 0.0
    @Published var rightTriggerValue: Float = 0.0
    
    // Shoulder values
    @Published var leftShoulderValue: Float = 0.0
    @Published var rightShoulderValue: Float = 0.0
    
    // DualSense’s touchpad
    @Published var touchpad: Bool = false
    
    // Finger locations on the touchpad (0.0 to 1.0)
    @Published var touchpadPrimaryX: Float = 0.0
    @Published var touchpadPrimaryY: Float = 0.0
    @Published var touchpadSwipeDirection: SwipeDirection?
    
    // Misc Buttons
    @Published var buttonMenu: Float = 0.0
    @Published var buttonOptions: Float = 0.0

    // D-Pad
    @Published var dPadUp: Float = 0.0
    @Published var dPadDown: Float = 0.0
    @Published var dPadLeft: Float = 0.0
    @Published var dPadRight: Float = 0.0
    
    // Thumbsticks
    @Published var leftThumbstick: Float = 0.0
    @Published var rightThumbstick: Float = 0.0
    
    // Thumbstick axis values
    @Published var leftThumbstickX: Float = 0.0
    @Published var leftThumbstickY: Float = 0.0
    @Published var rightThumbstickX: Float = 0.0
    @Published var rightThumbstickY: Float = 0.0
    
    // Thumbstick angles (in degrees, -180...180)
    @Published var leftThumbstickAngle: Float = 0.0
    @Published var rightThumbstickAngle: Float = 0.0
    
    // MARK: - Sequence Tracking
    enum ControllerInput {
        case dPadUp
        case dPadDown
        case dPadLeft
        case dPadRight
        case buttonA
        case buttonB
        case buttonX
        case buttonY
        case buttonMenu
        case buttonOptions
    }
    
    enum SwipeDirection {
        case left
        case right
        case up
        case down
    }
    
    struct CheatSequence {
        let name: String
        let steps: [ControllerInput]
        let audioFile: String
        var currentIndex: Int = 0
    }
    
    private var cheatSequences: [CheatSequence] = [
        CheatSequence(
            name: "Konami Code",
            steps: [
                .dPadUp, .dPadUp, .dPadDown, .dPadDown,
                .dPadLeft, .dPadRight, .dPadLeft, .dPadRight,
                .buttonA, .buttonB, .buttonMenu
            ],
            audioFile: "cheat1.mp3"
        ),
        CheatSequence(
            name: "Secret Mode",
            steps: [
                .dPadLeft, .dPadLeft, .buttonB, .buttonA
            ],
            audioFile: "cheat2.mp3"
        )
        // Add more if needed...
    ]
    
    // MARK: - Audio
    private var audioPlayer: AVAudioPlayer?
    
    // MARK: - For Gesture Detection
    // A simple approach to detect tap/swipe on the primary touch.
    private var lastTouchPosition: CGPoint?
    private var touchStartTime: Date?
    private let swipeThreshold: CGFloat = 0.5    // 0.5 of the trackpad's range
    private let tapMaxDuration: TimeInterval = 0.25
    
    private var currentController: GCController?
    private var dualSensePad: GCDualSenseGamepad?

    // MARK: - Start Monitoring
    func startMonitoringControllers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidConnect(_:)),
            name: .GCControllerDidConnect,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(controllerDidDisconnect(_:)),
            name: .GCControllerDidDisconnect,
            object: nil
        )

        // If a controller is already connected at launch
        if let controller = GCController.controllers().first {
            setupController(controller)
        }
    }

    // MARK: - Stop Monitoring
    func stopMonitoringControllers() {
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        NotificationCenter.default.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
    }

    // MARK: - Notifications
    @objc private func controllerDidConnect(_ notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        setupController(controller)
    }

    @objc private func controllerDidDisconnect(_ notification: Notification) {
        guard let controller = notification.object as? GCController else { return }
        // If the currently tracked controller disconnected, clear references
        if controller == currentController {
            clearCurrentController()
        }
    }

    private func clearCurrentController() {
        DispatchQueue.main.async {
            self.currentController = nil
            self.dualSensePad = nil
            self.controllerName = nil
            // Reset all published properties to default
            self.resetAllValues()
        }
    }
    
    private func resetAllValues() {
        batteryLevel = nil
        lightBar = nil
        buttonA = false
        buttonB = false
        buttonX = false
        buttonY = false
        leftTriggerValue = 0.0
        rightTriggerValue = 0.0
        leftShoulderValue = 0.0
        rightShoulderValue = 0.0
        touchpad = false
        buttonMenu = 0.0
        buttonOptions = 0.0
        dPadUp = 0.0
        dPadDown = 0.0
        dPadLeft = 0.0
        dPadRight = 0.0
        leftThumbstick = 0.0
        rightThumbstick = 0.0
        lastTouchPosition = nil
        touchStartTime = nil
    }

    // MARK: - Setup Controller
    private func setupController(_ controller: GCController) {
        currentController = controller
        controllerName = controller.vendorName ?? "Unknown Controller"

        guard let dualSense = controller.extendedGamepad as? GCDualSenseGamepad else {
            print("Controller is not recognized as a DualSense.")
            return
        }
        
        // Store the DualSense reference for later (e.g. adaptive triggers)
        dualSensePad = dualSense
        
        // MARK: Battery
        if let battery = controller.battery {
            DispatchQueue.main.async {
                self.batteryLevel = battery.batteryLevel
            }
        }

        // MARK: Light Bar
        // Example: set to green at start
        let defaultColor = GCColor(red: 0.0, green: 1.0, blue: 0.0)
        lightBar = defaultColor
        controller.light?.color = defaultColor

        // MARK: Thumbsticks (Buttons on L3/R3)
        controller.extendedGamepad?.leftThumbstickButton?.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.leftThumbstick = value
            }
        }
        
        controller.extendedGamepad?.rightThumbstickButton?.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.rightThumbstick = value
            }
        }
        
        // MARK: Thumbstick Directions (x, y)
        // This allows capturing the actual axes of each thumbstick
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            DispatchQueue.main.async {
                self?.leftThumbstickX = xValue
                self?.leftThumbstickY = yValue
                self?.leftThumbstickAngle = self?.calculateAngle(x: xValue, y: yValue) ?? 0.0
            }
        }
        
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = { [weak self] _, xValue, yValue in
            DispatchQueue.main.async {
                self?.rightThumbstickX = xValue
                self?.rightThumbstickY = yValue
                self?.rightThumbstickAngle = self?.calculateAngle(x: xValue, y: yValue) ?? 0.0
            }
        }
        
        
        // MARK: D-Pad
        controller.extendedGamepad?.dpad.up.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.dPadUp = value
                if value > 0.0 {
                    self?.handleInput(.dPadUp)
                }
            }
        }
        
        controller.extendedGamepad?.dpad.down.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.dPadDown = value
                if value > 0.0 {
                    self?.handleInput(.dPadDown)
                }
            }
        }
        
        controller.extendedGamepad?.dpad.left.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.dPadLeft = value
                if value > 0.0 {
                    self?.handleInput(.dPadLeft)
                }
            }
        }
        
        controller.extendedGamepad?.dpad.right.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.dPadRight = value
                if value > 0.0 {
                    self?.handleInput(.dPadRight)
                }
            }
        }
        
        // MARK: Face Buttons
        dualSense.buttonA.pressedChangedHandler = { [weak self] _, _, pressed in
            DispatchQueue.main.async {
                self?.buttonA = pressed
                if pressed {
                    self?.handleInput(.buttonA)
                }
            }
        }
        
        dualSense.buttonB.pressedChangedHandler = { [weak self] _, _, pressed in
            DispatchQueue.main.async {
                self?.buttonB = pressed
                if pressed {
                    self?.handleInput(.buttonB)
                }
            }
        }
        
        dualSense.buttonX.pressedChangedHandler = { [weak self] _, _, pressed in
            DispatchQueue.main.async {
                self?.buttonX = pressed
                if pressed {
                    self?.handleInput(.buttonX)
                }
            }
        }
        
        dualSense.buttonY.pressedChangedHandler = { [weak self] _, _, pressed in
            DispatchQueue.main.async {
                self?.buttonY = pressed
                if pressed {
                    self?.handleInput(.buttonY)
                }
            }
        }
        
        // MARK: Menu / Options Buttons
        
        if let menuButton = controller.extendedGamepad?.buttonMenu {
            menuButton.valueChangedHandler = { [weak self] _, value, _ in
                DispatchQueue.main.async {
                    // e.g. interpret this as "Options" or "Pause"
                    self?.buttonMenu = value
                    if value > 0.0 {
                        self?.handleInput(.buttonMenu)
                    }
                }
            }
        }
        
        if let optionsButton = controller.extendedGamepad?.buttonOptions {
            optionsButton.valueChangedHandler = { [weak self] _, value, _ in
                DispatchQueue.main.async {
                    // e.g. interpret this as "Menu" or "Select"
                    self?.buttonOptions = value
                    if value > 0.0 {
                        self?.handleInput(.buttonOptions)
                    }
                }
            }
        }
        
        // MARK: Triggers and Shoulders
        dualSense.leftTrigger.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.leftTriggerValue = value
            }
        }
        
        dualSense.rightTrigger.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.rightTriggerValue = value
            }
        }
        
        controller.extendedGamepad?.leftShoulder.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.leftShoulderValue = value
            }
        }
        
        controller.extendedGamepad?.rightShoulder.valueChangedHandler = { [weak self] _, value, _ in
            DispatchQueue.main.async {
                self?.rightShoulderValue = value
            }
        }

        // MARK: Touchpad
        dualSense.touchpadButton.pressedChangedHandler = { [weak self] _, _, pressed in
            DispatchQueue.main.async {
                self?.touchpad = pressed
            }
        }
        
        // Primary Touchpad Finger (xValue, yValue range: 0.0 to 1.0)
        dualSense.touchpadPrimary.valueChangedHandler = { [weak self] _, xValue, yValue in
            DispatchQueue.main.async {
                self?.touchpadPrimaryX = xValue
                self?.touchpadPrimaryY = yValue
                self?.touchpadSwipeDirection = self?.detectTouchpadGestures(xValue: xValue, yValue: yValue)
            }
        }
        
        // Up/Down/Left/Right on the primary portion of the touchpad
        dualSense.touchpadPrimary.down.valueChangedHandler = { _, value, _ in
            // print("Touchpad Primary Down: \(value)")
        }
        
        dualSense.touchpadPrimary.up.valueChangedHandler = { _, value, _ in
            // print("Touchpad Primary Up: \(value)")
        }
        
        dualSense.touchpadPrimary.left.valueChangedHandler = { _, value, _ in
            // print("Touchpad Primary Left: \(value)")
        }
        
        dualSense.touchpadPrimary.right.valueChangedHandler = { _, value, _ in
            // print("Touchpad Primary Right: \(value)")
        }
    }

    // MARK: - Manage Tap or Swipe Gestures on the Touchpad
    /// Detects a tap or swipe gesture on the touchpad, returning a direction
    /// if the gesture qualifies as a swipe.
    ///
    /// - Parameters:
    ///   - xValue: The current X coordinate of the primary touch (range 0–1)
    ///   - yValue: The current Y coordinate of the primary touch (range 0–1)
    ///
    /// - Returns: A `SwipeDirection` if this call detects a swipe, otherwise `nil`.
    func detectTouchpadGestures(xValue: Float, yValue: Float) -> SwipeDirection? {
        let currentPoint = CGPoint(x: CGFloat(xValue), y: CGFloat(yValue))
        
        // If we have no recorded position yet, treat this as a "touch began."
        guard let start = lastTouchPosition else {
            lastTouchPosition = currentPoint
            touchStartTime = Date()
            return nil
        }
        
        // If xValue or yValue jumps quickly, check for swipe
        let dx = currentPoint.x - start.x
        let dy = currentPoint.y - start.y
        let distance = sqrt(dx*dx + dy*dy)
        
        // Check for swipe if the distance exceeds the threshold
        if distance > swipeThreshold {
            // It's a swipe!
            print("Detected swipe on touchpad: dx=\(dx), dy=\(dy)")
            
            let swipeDirection: SwipeDirection
            
            if abs(dx) > abs(dy) {
                // Horizontal swipe
                swipeDirection = dx > 0 ? .right : .left
            } else {
                // Vertical swipe
                swipeDirection = dy > 0 ? .down : .up
            }
            
            touchpadSwipeDirection = swipeDirection
            print("Swipe Direction: \(swipeDirection)")
            
            // Reset state for the next gesture
            lastTouchPosition = nil
            touchStartTime = nil
            
            return swipeDirection
        }
        
        // If the user lifts their finger or movement is minimal, you might interpret a tap.
        // In this example, we detect a "tap" if the user quickly pressed and did NOT move far.
        if let startTime = touchStartTime {
            let elapsed = Date().timeIntervalSince(startTime)
            if elapsed > tapMaxDuration && distance < swipeThreshold {
                // This was a longer hold, so maybe not a tap; do nothing yet
                return nil
            }
        }
        
        // No swipe detected yet
        return nil
    }
    
    // MARK: - Compute Angle Helper
    private func calculateAngle(x: Float, y: Float) -> Float {
        // atan2 returns angle in radians; convert to degrees for clarity
        let radians = atan2(y, x)
        return radians * 180.0 / .pi
    }
    
    // MARK: - Adaptive Feedback
    func triggerAdaptiveFeedback() {
        guard let dualSense = dualSensePad else { return }

        let adaptiveTrigger = dualSense.rightTrigger
        // Example: a simple adaptive feedback effect
        let resistiveStrength = min(1.0, 0.2 + adaptiveTrigger.value)
        
        if adaptiveTrigger.value < 0.9 {
            adaptiveTrigger.setModeFeedbackWithStartPosition(
                0.0,
                resistiveStrength: resistiveStrength
            )
        } else {
            adaptiveTrigger.setModeVibrationWithStartPosition(
                0.0,
                amplitude: resistiveStrength,
                frequency: 0.03
            )
        }
        
        // Turn it off after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            adaptiveTrigger.setModeOff()
        }
    }
    
    // MARK: - Handle Multiple Cheat Sequences
    private func handleInput(_ input: ControllerInput) {
        for i in cheatSequences.indices {
            let expected = cheatSequences[i].steps[cheatSequences[i].currentIndex]
            if input == expected {
                cheatSequences[i].currentIndex += 1
                
                // Check for completion
                if cheatSequences[i].currentIndex == cheatSequences[i].steps.count {
                    playCheatCodeAudio(filename: cheatSequences[i].audioFile)
                    print("\(cheatSequences[i].name) completed!")
                    // Reset so user can attempt it again if they want
                    cheatSequences[i].currentIndex = 0
                }
            } else {
                // Mismatch, reset index
                cheatSequences[i].currentIndex = 0
            }
        }
    }
    
    // MARK: - Audio Playback
    private func playCheatCodeAudio(filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Audio file not found: \(filename)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Light Bar Color Changer
    func setLightBarColor(red: Float, green: Float, blue: Float) {
        guard let controller = currentController else { return }
        let color = GCColor(red: red, green: green, blue: blue)
        controller.light?.color = color
        self.lightBar = color
    }
}
