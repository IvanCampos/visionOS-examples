//
//  ImmersiveView.swift
//  bsky 3D
//
//  Created by IVAN CAMPOS on 11/25/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(AppModel.self) var appModel

    @ObservedObject var webSocketService = WebSocketService()
    
    @State private var realityKitContent: RealityViewContent?
    
    var body: some View {
        RealityView { content in
            realityKitContent = content
        }
        .onAppear {
            webSocketService.connect()
        }
        .onDisappear {
            webSocketService.disconnect()
        }
        .onChange(of: webSocketService.postText) { oldValue, newValue in
            guard let realityKitContent = realityKitContent else { return }

            // Create and configure a new text entity based on the new value
            let textEntity = createTextEntity(text: newValue)

            // Add the new entity to the RealityKit content
            realityKitContent.add(textEntity)
            
            // Schedule the textEntity to fade away after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Scale the textEntity to zero over 1 second
                textEntity.move(to: Transform(scale: .zero), relativeTo: textEntity, duration: 1.0)
                
                // Schedule removal of the textEntity after the animation duration
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) { // 3 seconds + 1 second for animation
                    realityKitContent.remove(textEntity)
                }
            }
        }
        .preferredSurroundingsEffect(.colorMultiply(.gray))
    }
    
    func createTextEntity(text: String) -> ModelEntity {
        print("Creating text entity: \(text)")
        
        // Determine the color based on the text content
        let textColor: UIColor
        var fontName: String = "Orbitron-Regular"
        if containsJapanese(text: text) {
            textColor = .red
            fontName = "Orbitron-ExtraBold"
        } else if text.lowercased().hasPrefix("http") {
            textColor = .cyan
        } else if text.hasPrefix("@") || text.hasPrefix("#") {
            textColor = .green
        } else if text.lowercased().contains("bitcoin") || text.lowercased().contains("btc") {
            textColor = .orange
        } else if text.lowercased().contains("bluesky") {
            textColor = UIColor(red: 0.0, green: 123.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else {
            textColor = .white
        }

        // Create the text mesh
        let textMesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.0,  // Depth of the 3D text
            font: UIFont(name: fontName, size: 0.05) ?? .systemFont(ofSize: 0.05),  // System font or a custom one
            containerFrame: CGRect(x: 0, y: 0, width: 1.5, height: 0.75),
            alignment: .center,     // Center alignment
            lineBreakMode: .byWordWrapping
        )

        // Create a material for the text
        let material = UnlitMaterial(color: textColor)

        // Combine the mesh and material into a model entity
        let textEntity = ModelEntity(mesh: textMesh, materials: [material])

        // Randomize the position (in meters) of the text entity within a certain range
        let randomX = Float.random(in: -2...0)
        let randomY = Float.random(in: 0.5...2.0)
        let randomZ = Float.random(in: -4.0 ... -1.0)

        // Position the text entity
        textEntity.position = [randomX, randomY, randomZ]  // Set the randomized position

        return textEntity
    }

    // Function to check if the text contains Japanese characters
    func containsJapanese(text: String) -> Bool {
        for scalar in text.unicodeScalars {
            if (scalar.value >= 0x3040 && scalar.value <= 0x309F) ||  // Hiragana
               (scalar.value >= 0x30A0 && scalar.value <= 0x30FF) ||  // Katakana
               (scalar.value >= 0x4E00 && scalar.value <= 0x9FAF) {  // Kanji
                return true
            }
        }
        return false
    }
    
}
