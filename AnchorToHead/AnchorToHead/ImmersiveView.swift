//
//  ImmersiveView.swift
//  AnchorToHead
//
//  Created by IVAN CAMPOS on 2/21/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State var headTrackedEntity: Entity = {
        let headAnchor = AnchorEntity(.head)
        headAnchor.position = [0, -0.15, -1]
        return headAnchor
    }()
    
    var body: some View {
        RealityView { content in
            
            let boxEntity = ModelEntity(
                mesh: .generateBox(size: 0.1),
                materials: [UnlitMaterial(color: UIColor(hex: "7DFDFE"))]
            )
            
            headTrackedEntity.addChild(boxEntity)
            content.add(headTrackedEntity)
            
        }
    }
}

// Function to create UIColor from hex string
extension UIColor {
    convenience init(hex: String) {
        
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(color & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

