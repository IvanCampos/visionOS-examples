//
//  ContentView.swift
//  DualSense
//
//  Created by IVAN CAMPOS on 1/12/25.
//

import SwiftUI
import GameController

struct ContentView: View {
    @StateObject private var controllerManager = ControllerManager()
    
    // MARK: - Predefined Rainbow Colors (ROYGBIV)
    private let rainbowColors: [(name: String, color: Color, rgb: (Float, Float, Float))] = [
        ("Red",    .red,    (1.0, 0.0, 0.0)),
        ("Orange", .orange, (1.0, 0.5, 0.0)),
        ("Yellow", .yellow, (1.0, 1.0, 0.0)),
        ("Green",  .green,  (0.0, 1.0, 0.0)),
        ("Blue",   .blue,   (0.0, 0.0, 1.0)),
        ("Indigo", Color(red: 0.29, green: 0.0, blue: 0.51), (0.29, 0.0, 0.51)),
        ("Violet", Color(red: 0.56, green: 0.0, blue: 1.0),  (0.56, 0.0, 1.0))
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            
            if (controllerManager.controllerName != nil) {
                
                VStack(spacing: 20) {
                    
                    ZStack {
                        Group {
                            Image(systemName: "battery.0percent")
                                .font(.system(size: 50))
                        }
                        
                        // The text is drawn *in front of* the battery image
                        Text(
                            controllerManager.batteryLevel != nil
                            ? "\(String(format: "%.0f", controllerManager.batteryLevel! * 100))%"
                            : "N/A"
                        )
                        .font(.subheadline)
                        .foregroundColor(.green)
                    }

                    VStack {
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text(
                                    "\(String(format: "%.2f", controllerManager.leftTriggerValue))"
                                )
                                .font(.headline)
                                if (controllerManager.leftTriggerValue > 0.00) {
                                    Image(
                                        systemName: "l2.button.angledtop.vertical.left.fill"
                                    )
                                    .font(.system(size: 50))
                                } else {
                                    Image(
                                        systemName: "l2.button.angledtop.vertical.left"
                                    )
                                    .font(.system(size: 50))
                                }
                            }
                            
                            VStack {
                                Text(
                                    "\(String(format: "%.2f", controllerManager.rightTriggerValue))"
                                )
                                .font(.headline)
                                if (
                                    controllerManager.rightTriggerValue > 0.00
                                ) {
                                    Image(
                                        systemName: "r2.button.angledtop.vertical.right.fill"
                                    )
                                    .font(.system(size: 50))
                                } else {
                                    Image(
                                        systemName: "r2.button.angledtop.vertical.right"
                                    )
                                    .font(.system(size: 50))
                                }
                            }
                        }
                        
                        HStack {
                            
                            if (controllerManager.leftShoulderValue > 0.00) {
                                Image(
                                    systemName: "l1.button.roundedbottom.horizontal.fill"
                                )
                                .font(.system(size: 50))
                            } else {
                                Image(
                                    systemName: "l1.button.roundedbottom.horizontal"
                                )
                                .font(.system(size: 50))
                            }
                            
                            if (controllerManager.rightShoulderValue > 0.00) {
                                Image(
                                    systemName: "r1.button.roundedbottom.horizontal.fill"
                                )
                                .font(.system(size: 50))
                            } else {
                                Image(
                                    systemName: "r1.button.roundedbottom.horizontal"
                                )
                                .font(.system(size: 50))
                            }
                        }
                    }
                    
                    HStack(spacing: 20) {
                        
                        //Options
                        if (controllerManager.buttonOptions > 0.0) {
                            Image(systemName: "light.max")
                                .font(.system(size: 50))
                                .foregroundColor(controllerManager.lightBar?.imageColor)
                        } else {
                            Image(systemName: "light.max")
                                .font(.system(size: 50))
                        }
                        
                        if (controllerManager.touchpad == true) {
                            Image(systemName: "inset.filled.rectangle")
                                .font(.system(size: 50))
                                .foregroundColor(controllerManager.lightBar?.imageColor)
                        } else {
                            Image(systemName: "rectangle")
                                .font(.system(size: 50))
                        }
                        
                        //Menu
                        if (controllerManager.buttonMenu > 0.0) {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 50))
                                .foregroundColor(controllerManager.lightBar?.imageColor)
                        } else {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 50))
                        }
                    }
                    
                    HStack(spacing: 20) {
                        
                        if (controllerManager.dPadDown > 0.0) {
                            Image(systemName: "dpad.down.fill")
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                        } else if (controllerManager.dPadLeft > 0.0) {
                            Image(systemName: "dpad.left.fill")
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                        } else if (controllerManager.dPadRight > 0.0) {
                            Image(systemName: "dpad.right.fill")
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                        } else if (controllerManager.dPadUp > 0.0) {
                            Image(systemName: "dpad.up.fill")
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                        } else {
                            Image(systemName: "dpad")
                                .font(.system(size: 50))
                                .padding(.trailing, 20)
                        }
                            
                        if (controllerManager.buttonX == true) {
                            Image(systemName: "square.circle.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "square.circle")
                                .font(.system(size: 50))
                        }
                        
                        if (controllerManager.buttonY == true) {
                            Image(systemName: "triangle.circle.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "triangle.circle")
                                .font(.system(size: 50))
                        }
                        
                        if (controllerManager.buttonA == true) {
                            Image(systemName: "x.circle.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "x.circle")
                                .font(.system(size: 50))
                        }
                        
                        if (controllerManager.buttonB == true) {
                            Image(systemName: "circle.circle.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "circle.circle")
                                .font(.system(size: 50))
                        }
                    
                    }
                    
                    HStack(spacing: 20) {
                        
                        if (controllerManager.leftThumbstick > 0.0) {
                            Image(systemName: "l.joystick.tilt.down.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "l.joystick.tilt.down")
                                .font(.system(size: 50))
                        }
                        
                        Text("\(Image(systemName: "playstation.logo"))")
                            .font(.system(size: 35))
                            .foregroundColor(Color(UIColor.darkGray))
                            .padding(.horizontal, 25)
                        
                        if (controllerManager.rightThumbstick > 0.0) {
                            Image(systemName: "r.joystick.tilt.down.fill")
                                .font(.system(size: 50))
                        } else {
                            Image(systemName: "r.joystick.tilt.down")
                                .font(.system(size: 50))
                        }
                        
                    }
                    
                    // MARK: - Thumbstick Axes & Angles
                    VStack(spacing: 6) {
                        Text("Left Thumbstick: X=\(String(format: "%.2f", controllerManager.leftThumbstickX))  Y=\(String(format: "%.2f", controllerManager.leftThumbstickY))")
                            .font(.subheadline)
                        Text("Angle=\(String(format: "%.0f", controllerManager.leftThumbstickAngle))°")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(spacing: 6) {
                        Text("Right Thumbstick: X=\(String(format: "%.2f", controllerManager.rightThumbstickX))  Y=\(String(format: "%.2f", controllerManager.rightThumbstickY))")
                            .font(.subheadline)
                        Text("Angle=\(String(format: "%.0f", controllerManager.rightThumbstickAngle))°")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // MARK: - Touchpad Finger Locations
                    VStack(spacing: 6) {
                        Text("Touchpad Primary: (X=\(String(format: "%.2f", controllerManager.touchpadPrimaryX)), Y=\(String(format: "%.2f", controllerManager.touchpadPrimaryY)))")
                            .font(.subheadline)
                        Text("Swipe Direction: \(String(describing: controllerManager.touchpadSwipeDirection))")
                            .font(.subheadline)
                    }
                    
                    // MARK: - Color Circles (ROYGBIV)
                    HStack(spacing: 12) {
                        ForEach(rainbowColors, id: \.name) { colorItem in
                            Button {
                                let (r, g, b) = colorItem.rgb
                                // Call your manager's function to change the light bar color
                                controllerManager.setLightBarColor(red: r, green: g, blue: b)
                            } label: {
                                Circle()
                                    .fill(colorItem.color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(Color.white.opacity(0.8), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(colorItem.name)
                        }
                    }
                    .padding(.top, 10)
                    
                }
                .padding()
                
            } else {
                Text("\(Image(systemName: "playstation.logo"))")
                    .font(.system(size: 50))
                Text("No PS5 DualSense controller connected")
                    .font(.headline)
                    .foregroundColor(.red)
            }
            
        }
        .onAppear {
            controllerManager.startMonitoringControllers()
        }
        .onDisappear {
            controllerManager.stopMonitoringControllers()
        }
    }
}

extension GCColor {
    var imageColor: Color {
        Color(red: Double(self.red), green: Double(self.green), blue:  Double(self.blue))
    }
}
