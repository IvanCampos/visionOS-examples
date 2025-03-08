//
//  Helpers.swift
//  Music Kit
//
//  Created by IVAN CAMPOS on 2/22/25.
//

import SwiftUI
import RealityKit
import MusicKit
import UIKit

/// A RealityKit component that holds a reference to the associated `Song`.
struct SongReferenceComponent: Component {
    let song: Song
}

/// Make the component codable if needed (optional).
extension SongReferenceComponent: Codable {}

/// Convert an Apple MusicKit Artwork to a CGImage.
func cgImageFromArtwork(artwork: Artwork, width: Int) async throws -> CGImage {
    // Provide a URL with the desired width x height
    guard let imageURL = artwork.url(width: width, height: width) else {
        throw NSError(domain: "ArtworkConversionError", code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Invalid artwork URL"])
    }
    
    let (data, _) = try await URLSession.shared.data(from: imageURL)
    guard let uiImage = UIImage(data: data) else {
        throw NSError(domain: "ArtworkConversionError", code: -1,
                      userInfo: [NSLocalizedDescriptionKey: "Unable to convert data into a UIImage"])
    }
    
    if let directCG = uiImage.cgImage {
        return directCG
    } else {
        let renderer = UIGraphicsImageRenderer(size: uiImage.size)
        let rendered = renderer.image { _ in uiImage.draw(at: .zero) }
        guard let renderedCG = rendered.cgImage else {
            throw NSError(domain: "ArtworkConversionError", code: -1,
                          userInfo: [NSLocalizedDescriptionKey: "Unable to generate CGImage"])
        }
        return renderedCG
    }
}

/// Create a ModelEntity using a Song's artwork (unlit plane).
@MainActor
func createArtworkEntity(
    for song: Song,
    width: Float = 0.2,
    height: Float = 0.2
) async -> ModelEntity? {
    guard let artwork = song.artwork else { return nil }
    
    do {
        let cgImage = try await cgImageFromArtwork(artwork: artwork, width: 300)
        let texture = try await TextureResource(image: cgImage, options: .init(semantic: .color))
        
        var material = SimpleMaterial()
        let matTexture = MaterialParameters.Texture(texture)
        material.color = .init(texture: matTexture)
        
        let planeMesh = MeshResource.generatePlane(width: width, height: height)
        let entity = ModelEntity(mesh: planeMesh, materials: [material])
        return entity
    } catch {
        print("Error creating artwork entity: \(error)")
        return nil
    }
}

/// A sample SwiftUI view for playback controls. Attach or modify as needed.
struct PlaybackControlsView: View {
    @EnvironmentObject var musicManager: MusicManager
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Playback Controls")
                .font(.headline)
            HStack {
                Button("Stop") {
                    musicManager.stopPlayback()
                }
                Button("Pause") {
                    musicManager.pausePlayback()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.regularMaterial)
        .cornerRadius(12)
    }
}
