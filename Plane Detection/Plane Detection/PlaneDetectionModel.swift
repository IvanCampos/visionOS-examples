import ARKit
import Foundation
import RealityKit

class PlaneDetectionModel: NSObject {
        
    // An ARKit session for managing augmented reality experiences.
    let session = ARKitSession()
    
    // A root entity acting as a container for all dynamically generated plane entities in the scene.
    var rootEntity = AnchorEntity(world: .zero)
    
    // Starts the AR session with plane detection enabled for both horizontal and vertical surfaces.
    // The use of @MainActor ensures that these functions are executed on the main thread, which is crucial for UI updates and interactions with RealityKit and ARKit.
    @MainActor func startSession() async {
        // Initialize the plane detection provider with specified plane alignments.
        let planeDataProvider = PlaneDetectionProvider(alignments: [.horizontal, .vertical])
        
        // An array to hold data providers, here intended for plane detection.
        var providers: [DataProvider] = []
        // Check if plane detection is supported and, if so, add the planeDataProvider to the providers array.
        if PlaneDetectionProvider.isSupported {
            providers.append(planeDataProvider)
        }
        do {
            // Attempt to start the session with the specified providers.
            try await session.run(providers)
            
            // Listen for updates from the planeDataProvider and update plane entities accordingly.
            for await planeDetectionUpdate in planeDataProvider.anchorUpdates {
                try await updatePlaneEntity(planeDetectionUpdate.anchor)
            }
        } catch {
            // If an error occurs, print it to the console.
            print("error is \(error)")
        }
    }
    
    // Stops the AR session.
    @MainActor func stopSession() {
        session.stop()
    }
    
    // Updates or creates a new plane entity in the scene based on the provided plane anchor.
    @MainActor fileprivate func updatePlaneEntity(_ anchor: PlaneAnchor) async throws {
        // Generate visual representation for the plane's extent.
        let modelEntity = try await createPlaneModelEntity(anchor)
        // Generate visual representation for the plane's classification text.
        let textEntity = await createTextModelEntity(anchor)
        // Check if an entity for this anchor already exists in the scene.
        if let anchorEntity = rootEntity.findEntity(named: "\(anchor.id)") {
            // If it does, remove all its children (for update) and add the new model and text entities.
            anchorEntity.children.removeAll()
            anchorEntity.addChild(modelEntity)
            anchorEntity.addChild(textEntity)
        } else {
            // If it doesn't, create a new anchor entity, set its orientation, and add it to the root entity.
            let anchorEntity = AnchorEntity(world: anchor.originFromAnchorTransform)
            // Rotates the anchorEntity by -90 degrees around the x-axis.
            anchorEntity.orientation = .init(angle: -.pi / 2, axis: .init(1, 0, 0))
            anchorEntity.addChild(modelEntity)
            anchorEntity.addChild(textEntity)
            anchorEntity.name = "\(anchor.id)"
            rootEntity.addChild(anchorEntity)
        }
    }
    
    // Removes a plane entity from the scene based on the provided plane anchor.
    fileprivate func removePlaneEntity(_ anchor: PlaneAnchor) throws {
        // Attempt to find the entity associated with the provided anchor.
        if let anchorEntity = rootEntity.findEntity(named: "\(anchor.id)") {
            // If found, remove it from its parent, effectively deleting it from the scene.
            anchorEntity.removeFromParent()
        }
    }
    
    // Generates a visual representation of a plane's extent.
    @MainActor fileprivate func createPlaneModelEntity(_ anchor: PlaneAnchor) async throws -> ModelEntity {
        // Use the plane's extent (size) to define the size of the generated plane mesh.
        let extent = anchor.geometry.extent
        // Create a material for the plane, setting its base color based on the plane's classification.
        var planeMaterial = PhysicallyBasedMaterial()
        planeMaterial.baseColor = .init(tint: colorForPlaneClassification(classification: anchor.classification))
        // Create the model entity using the plane mesh and the material.
        let planeModelEntity = ModelEntity(mesh: .generatePlane(width: extent.width, height: extent.height), materials: [planeMaterial])
        
        return planeModelEntity
    }
    
    // Generates a visual representation of a plane's classification as text.
    @MainActor fileprivate func createTextModelEntity(_ anchor: PlaneAnchor) async -> ModelEntity {
        // Create a white material for the text.
        let planeTextMaterial = UnlitMaterial(color: .white)
        // Generate a model entity for the text, using the plane's classification description.
        let planeTextModelEntity = ModelEntity(mesh: .generateText(anchor.classification.description.uppercased(), extrusionDepth: 0.001, font: .boldSystemFont(ofSize: 0.1), containerFrame: .zero, alignment: .center, lineBreakMode: .byWordWrapping), materials: [planeTextMaterial])
        
        return planeTextModelEntity
    }
}
