//
//  AnchorToHeadApp.swift
//  AnchorToHead
//
//  Created by IVAN CAMPOS on 2/21/24.
//

import SwiftUI

@main
struct AnchorToHeadApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
