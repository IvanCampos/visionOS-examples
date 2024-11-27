//
//  ContentView.swift
//  bsky 3D
//
//  Created by IVAN CAMPOS on 11/25/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {

    var body: some View {
        VStack {
            
            Text("Bluesky 3D")
                .font(.custom("Orbitron-ExtraBold", size: 72))
                .foregroundColor(Color(hex: "#007BFF") ?? .blue)
            
            Text("bsky.app/profile/ivancampos.com")
                .font(.custom("Orbitron-Regular", size: 48))
                .foregroundColor(Color(hex: "#1e90ff") ?? .cyan)
            
            ToggleImmersiveSpaceButton()
        }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.hasPrefix("#") ? String(hexSanitized.dropFirst()) : hexSanitized

        let length = hexSanitized.count
        guard length == 6 || length == 8 else { return nil }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red, green, blue, alpha: Double
        if length == 6 {
            red = Double((rgb >> 16) & 0xFF) / 255.0
            green = Double((rgb >> 8) & 0xFF) / 255.0
            blue = Double(rgb & 0xFF) / 255.0
            alpha = 1.0
        } else {
            red = Double((rgb >> 24) & 0xFF) / 255.0
            green = Double((rgb >> 16) & 0xFF) / 255.0
            blue = Double((rgb >> 8) & 0xFF) / 255.0
            alpha = Double(rgb & 0xFF) / 255.0
        }

        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}
