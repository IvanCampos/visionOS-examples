//
//  CountdownApp.swift
//  Countdown
//
//  Created by IVAN CAMPOS on 3/17/24.
//

import SwiftUI

@main
struct CountdownApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
