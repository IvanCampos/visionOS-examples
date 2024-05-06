//
//  PencilApp.swift
//  Pencil
//
//  Created by IVAN CAMPOS on 4/27/24.
//

import SwiftUI

@main
struct PencilApp: App {
    
    @Environment(\.openURL) var openURL
    
    var body: some Scene {
        
        WindowGroup {
            Text("Use Lasso Tool, then Drag & Drop")
            Button("Open Settings for Pencil") {
                let settingsUrl = URL(string: UIApplication.openSettingsURLString)!
                openURL(settingsUrl)
            }
            CombinedView()
        }
        
        WindowGroup(id:"PencilKitBlack") {
            ContentView(backgroundColor: .black)
        }
        
        WindowGroup(id:"PencilKitWhite") {
            ContentView(backgroundColor: .white)
        }
        
        WindowGroup(id:"PencilKitClear") {
            ContentView(backgroundColor: .clear)
        }
        
    }
}
