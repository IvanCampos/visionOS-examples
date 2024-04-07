import SwiftUI
import RealityKit
import ARKit

struct ImmersiveView: View {
    // @State property wrapper to manage the state of plane detection within the SwiftUI view
    @State var planeDetection = PlaneDetectionModel()
    
    var body: some View {
        // RealityView is a custom view that integrates with RealityKit for AR experiences
        RealityView { content in
            // Adds the rootEntity of the planeDetection model to the RealityView's content
            // This is where the detected planes or other AR content would be added
            content.add(planeDetection.rootEntity)
        }
        .task {
            // Asynchronously starts the AR session with plane detection
            // This method is expected to configure and run the AR session
            await planeDetection.startSession()
        }
        .onDisappear {
            // Stops the AR session when the view disappears
            // This is important for freeing up resources and stopping the AR experience when not needed
            planeDetection.stopSession()
        }
    }
}
