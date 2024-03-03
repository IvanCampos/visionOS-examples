//
//  ImmersiveView.swift
//  HandTracking
//
//  Created by IVAN CAMPOS on 2/23/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import ARKit

struct ImmersiveView: View {
    
    @StateObject var handTrackingModel = HandTrackingModel()
    
    var body: some View {
        VStack {
            RealityView { content in
                handTrackingModel.addToContent(content)
            } update: { content in
                handTrackingModel.computeTransformHeartTracking()
            }
        }
        .upperLimbVisibility(.hidden)
        .ignoresSafeArea()
        .onAppear {
            handTrackingModel.handTracking()
        }
    }
}
