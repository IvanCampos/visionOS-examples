//
//  ContentView.swift
//  Pencil
//
//  Created by IVAN CAMPOS on 4/27/24.
//

import SwiftUI
import RealityKit
import PencilKit

struct CombinedView: View {
    
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        HStack {
            // EMPTY
        }.task {
            // Open multiple PencilKit windows with specific IDs for different configurations
            openWindow(id: "PencilKitBlack")
            openWindow(id: "PencilKitWhite")
            openWindow(id: "PencilKitClear")
        }
    }
}

struct ContentView: View {
    @State var backgroundColor: UIColor
    
    var body: some View {
        VStack {
            // A view hosting a drawing canvas, passing the selected background color
            CanvasView(color: backgroundColor)
        }
    }
}
 
struct CanvasView: UIViewRepresentable {
    @State var color: UIColor
    @State private var canvasView: PKCanvasView = PKCanvasView()
    @State private var toolPicker = PKToolPicker()
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .anyInput // Allows input from any source (finger, pencil)
        canvasView.becomeFirstResponder() // Makes this view the first responder to receive input events
        canvasView.isRulerActive.toggle() // Toggles the ruler's visibility
        
        if (color == .clear) {
            canvasView.isOpaque = false // Makes the background transparent
            canvasView.alpha = 1 // Sets the transparency level (opaque)
            canvasView.backgroundColor = .clear // Applies a clear background
        } else {
            canvasView.isOpaque = true // Makes the background non-transparent
            canvasView.backgroundColor = color // Applies the chosen color as background
        }
        
        toolPicker.setVisible(true, forFirstResponder: canvasView) // Displays the tool picker
        toolPicker.addObserver(canvasView) // Registers the canvas as an observer to tool picker events
                
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) { 
        // EMPTY
    }
}
