//
//  ImmersiveView.swift
//  Countdown
//
//  Created by IVAN CAMPOS on 3/17/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    let BASE_FONT = "Audiowide-Regular"
    let BASE_TEXTURE = "Starfield.jpg"
    let TEXTURE_NOT_FOUND = "Base Texture Not Found!"
    let COUNTDOWN_COLOR = "ff9900"
    let END_MESSAGE = "GAME\nOVER"
    let END_MESSAGE_COLOR = "FF0000"
    let FONT_SIZE = 0.3
    
    var body: some View {
        
        let timerEntity = createTimer()
        
        RealityView { content in
            content.add(timerEntity)
            
            var resource = try! await TextureResource.load(named: BASE_TEXTURE)
            
            var material = SimpleMaterial()
            material.color = SimpleMaterial.BaseColor(tint: .white, texture: .init(resource))
            
            let environment = Entity()
            environment.components.set(ModelComponent(
                mesh: .generateSphere(radius: 2000),
                materials: [material]
            ))
            environment.scale *= .init(x: -2, y: 2, z: 2)
            content.add(environment)
        }
    }
    
    func updatePosition(entity: Entity, x: Float, y: Float, z: Float) {
        entity.position = SIMD3<Float>(x, y, z)
    }
    
    func createTimer() -> ModelEntity {
        
        var startTime = 10
        var timer: Timer?
        
        let timerEntity = ModelEntity(
            mesh: .generateText(String(startTime), extrusionDepth: 0, font: UIFont(name: BASE_FONT, size: FONT_SIZE) ?? .systemFont(ofSize: FONT_SIZE), containerFrame: .zero,
                                alignment: .center, lineBreakMode: .byCharWrapping),
            materials: [SimpleMaterial(color: UIColor(hex: COUNTDOWN_COLOR), isMetallic: false)]
        )
        
        updatePosition(entity: timerEntity, x: 0.0, y: 1.75, z: -2)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            startTime = startTime - 1
            
            if (startTime >= 0) {
                
                DispatchQueue.main.async {
                    timerEntity.model?.mesh = .generateText(String(startTime), extrusionDepth: 0, font: UIFont(name: BASE_FONT, size: FONT_SIZE) ?? .systemFont(ofSize: FONT_SIZE), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping)
                    pulseEffect(entity: timerEntity)
                }
            } else {
                timer?.invalidate()
                
                DispatchQueue.main.async {
                    updatePosition(entity: timerEntity, x: -1.25, y: 1.75, z: -2)
                    timerEntity.model?.mesh = .generateText(END_MESSAGE, extrusionDepth: 0, font: UIFont(name: BASE_FONT, size: FONT_SIZE) ?? .systemFont(ofSize: FONT_SIZE), containerFrame: .zero, alignment: .center, lineBreakMode: .byCharWrapping)
                    timerEntity.model?.materials = [SimpleMaterial(color: UIColor(hex: END_MESSAGE_COLOR), isMetallic: false)]
                }
            }
        }
        
        return timerEntity
    }
    
    func pulseEffect(entity: ModelEntity) {
        
        let initialScale = entity.scale
        let SCALE: Float = 3.0
        let largerScale = SIMD3<Float>(initialScale.x * SCALE, initialScale.y * SCALE, initialScale.z * SCALE)
        
        entity.scale = largerScale
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            entity.scale = initialScale
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                entity.scale = initialScale
            }
        }
    }
}
