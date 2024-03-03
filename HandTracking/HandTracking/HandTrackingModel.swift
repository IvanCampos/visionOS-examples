//
//  HandTrackingModel.swift
//  HandTracking
//
//  Created by IVAN CAMPOS on 2/23/24.
//

import RealityKit
import ARKit
import SwiftUI

struct HandsUpdates {
    var left: HandAnchor?
    var right: HandAnchor?
}

class HandTrackingModel: ObservableObject {
    let session = ARKitSession()
    var handTrackingProvider = HandTrackingProvider()
    @Published var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    
    // State variables for sphere model entities
    @Published var leftWristModelEntity = ModelEntity.createHandEntity()
    @Published var leftThumbKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var leftThumbIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var leftThumbIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftThumbTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftIndexFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var leftIndexFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var leftIndexFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var leftIndexFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftIndexFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftMiddleFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var leftMiddleFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var leftMiddleFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var leftMiddleFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftMiddleFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftRingFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var leftRingFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var leftRingFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var leftRingFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftRingFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftLittleFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var leftLittleFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var leftLittleFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var leftLittleFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftLittleFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var leftForearmWristModelEntity = ModelEntity.createHandEntity()
    
    // State variables for box model entities
    @Published var leftForearmArmModelEntity = ModelEntity.createArmEntity()
    
    // Repeat the pattern for right hand and forearm entities
    @Published var rightWristModelEntity = ModelEntity.createHandEntity()
    @Published var rightThumbKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var rightThumbIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var rightThumbIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightThumbTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightIndexFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var rightIndexFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var rightIndexFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var rightIndexFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightIndexFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightMiddleFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var rightMiddleFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var rightMiddleFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var rightMiddleFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightMiddleFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightRingFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var rightRingFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var rightRingFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var rightRingFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightRingFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightLittleFingerMetacarpalModelEntity = ModelEntity.createHandEntity()
    @Published var rightLittleFingerKnuckleModelEntity = ModelEntity.createHandEntity()
    @Published var rightLittleFingerIntermediateBaseModelEntity = ModelEntity.createHandEntity()
    @Published var rightLittleFingerIntermediateTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightLittleFingerTipModelEntity = ModelEntity.createHandEntity()
    @Published var rightForearmWristModelEntity = ModelEntity.createHandEntity()
    @Published var rightForearmArmModelEntity = ModelEntity.createArmEntity()
    
    func handTracking() {
        if HandTrackingProvider.isSupported {
            Task {
                do {
                    try await session.run([handTrackingProvider])
                    for await update in handTrackingProvider.anchorUpdates {
                        DispatchQueue.main.async { // Ensure updates are on the main thread
                            switch update.event {
                            case .updated:
                                let anchor = update.anchor
                                if !anchor.isTracked {
                                    return // Use 'return' instead of 'continue' outside loops
                                }
                                if anchor.chirality == .left {
                                    self.latestHandTracking.left = anchor
                                } else if anchor.chirality == .right {
                                    self.latestHandTracking.right = anchor
                                }
                            default:
                                break
                            }
                        }
                    }
                } catch {
                    print("Error starting hand tracking: \(error)")
                }
            }
        }
    }
    
    func computeTransformHeartTracking() {
        guard let leftHandAnchor = latestHandTracking.left,
              let rightHandAnchor = latestHandTracking.right,
              leftHandAnchor.isTracked, rightHandAnchor.isTracked else {
            return
        }
        leftWristModelEntity.transform = getTransform(leftHandAnchor, .wrist, leftWristModelEntity.transform)
        leftThumbKnuckleModelEntity.transform = getTransform(leftHandAnchor, .thumbKnuckle, leftThumbKnuckleModelEntity.transform)
        leftThumbIntermediateBaseModelEntity.transform = getTransform(leftHandAnchor, .thumbIntermediateBase, leftThumbIntermediateBaseModelEntity.transform)
        leftThumbIntermediateTipModelEntity.transform = getTransform(leftHandAnchor, .thumbIntermediateTip, leftThumbIntermediateTipModelEntity.transform)
        leftThumbTipModelEntity.transform = getTransform(leftHandAnchor, .thumbTip, leftThumbTipModelEntity.transform)
        leftIndexFingerMetacarpalModelEntity.transform = getTransform(leftHandAnchor, .indexFingerMetacarpal, leftIndexFingerMetacarpalModelEntity.transform)
        leftIndexFingerKnuckleModelEntity.transform = getTransform(leftHandAnchor, .indexFingerKnuckle, leftMiddleFingerKnuckleModelEntity.transform)
        leftIndexFingerIntermediateBaseModelEntity.transform = getTransform(leftHandAnchor, .indexFingerIntermediateBase, leftIndexFingerIntermediateBaseModelEntity.transform)
        leftIndexFingerIntermediateTipModelEntity.transform = getTransform(leftHandAnchor, .indexFingerIntermediateTip, leftIndexFingerIntermediateTipModelEntity.transform)
        leftIndexFingerTipModelEntity.transform = getTransform(leftHandAnchor, .indexFingerTip, leftIndexFingerTipModelEntity.transform)
        leftMiddleFingerMetacarpalModelEntity.transform = getTransform(leftHandAnchor, .middleFingerMetacarpal, leftMiddleFingerMetacarpalModelEntity.transform)
        leftMiddleFingerKnuckleModelEntity.transform = getTransform(leftHandAnchor, .middleFingerKnuckle,leftMiddleFingerKnuckleModelEntity.transform)
        leftMiddleFingerIntermediateBaseModelEntity.transform = getTransform(leftHandAnchor, .middleFingerIntermediateBase,leftMiddleFingerIntermediateBaseModelEntity.transform)
        leftMiddleFingerIntermediateTipModelEntity.transform = getTransform(leftHandAnchor, .middleFingerIntermediateTip,leftMiddleFingerIntermediateTipModelEntity.transform)
        leftMiddleFingerTipModelEntity.transform = getTransform(leftHandAnchor, .middleFingerTip,leftMiddleFingerTipModelEntity.transform)
        leftRingFingerMetacarpalModelEntity.transform = getTransform(leftHandAnchor, .ringFingerMetacarpal,leftRingFingerMetacarpalModelEntity.transform)
        leftRingFingerKnuckleModelEntity.transform = getTransform(leftHandAnchor, .ringFingerKnuckle,leftRingFingerKnuckleModelEntity.transform)
        leftRingFingerIntermediateBaseModelEntity.transform = getTransform(leftHandAnchor, .ringFingerIntermediateBase,leftRingFingerIntermediateBaseModelEntity.transform)
        leftRingFingerIntermediateTipModelEntity.transform = getTransform(leftHandAnchor, .ringFingerIntermediateTip,leftRingFingerIntermediateTipModelEntity.transform)
        leftRingFingerTipModelEntity.transform = getTransform(leftHandAnchor, .ringFingerTip,leftRingFingerTipModelEntity.transform)
        leftLittleFingerMetacarpalModelEntity.transform = getTransform(leftHandAnchor, .littleFingerMetacarpal,leftLittleFingerMetacarpalModelEntity.transform)
        leftLittleFingerKnuckleModelEntity.transform = getTransform(leftHandAnchor, .littleFingerKnuckle,leftLittleFingerKnuckleModelEntity.transform)
        leftLittleFingerIntermediateBaseModelEntity.transform = getTransform(leftHandAnchor, .littleFingerIntermediateBase, leftLittleFingerIntermediateBaseModelEntity.transform)
        leftLittleFingerIntermediateTipModelEntity.transform = getTransform(leftHandAnchor, .littleFingerIntermediateTip,leftLittleFingerIntermediateTipModelEntity.transform)
        leftLittleFingerTipModelEntity.transform = getTransform(leftHandAnchor, .littleFingerTip,leftLittleFingerTipModelEntity.transform)
        leftForearmWristModelEntity.transform = getTransform(leftHandAnchor, .forearmWrist,leftForearmWristModelEntity.transform)
        leftForearmArmModelEntity.transform = getTransform(leftHandAnchor, .forearmArm,leftForearmArmModelEntity.transform)
        
        rightWristModelEntity.transform = getTransform(rightHandAnchor, .wrist,rightWristModelEntity.transform)
        rightThumbKnuckleModelEntity.transform = getTransform(rightHandAnchor, .thumbKnuckle,rightThumbKnuckleModelEntity.transform)
        rightThumbIntermediateBaseModelEntity.transform = getTransform(rightHandAnchor, .thumbIntermediateBase,rightThumbIntermediateBaseModelEntity.transform)
        rightThumbIntermediateTipModelEntity.transform = getTransform(rightHandAnchor, .thumbIntermediateTip,rightThumbIntermediateTipModelEntity.transform)
        rightThumbTipModelEntity.transform = getTransform(rightHandAnchor, .thumbTip,rightThumbTipModelEntity.transform)
        rightIndexFingerMetacarpalModelEntity.transform = getTransform(rightHandAnchor, .indexFingerMetacarpal,rightIndexFingerMetacarpalModelEntity.transform)
        rightIndexFingerKnuckleModelEntity.transform = getTransform(rightHandAnchor, .indexFingerKnuckle,rightIndexFingerKnuckleModelEntity.transform)
        rightIndexFingerIntermediateBaseModelEntity.transform = getTransform(rightHandAnchor, .indexFingerIntermediateBase,rightIndexFingerIntermediateBaseModelEntity.transform)
        rightIndexFingerIntermediateTipModelEntity.transform = getTransform(rightHandAnchor, .indexFingerIntermediateTip,rightIndexFingerIntermediateTipModelEntity.transform)
        rightIndexFingerTipModelEntity.transform = getTransform(rightHandAnchor, .indexFingerTip,rightIndexFingerTipModelEntity.transform)
        rightMiddleFingerMetacarpalModelEntity.transform = getTransform(rightHandAnchor, .middleFingerMetacarpal,rightMiddleFingerMetacarpalModelEntity.transform)
        rightMiddleFingerKnuckleModelEntity.transform = getTransform(rightHandAnchor, .middleFingerKnuckle,rightMiddleFingerKnuckleModelEntity.transform)
        rightMiddleFingerIntermediateBaseModelEntity.transform = getTransform(rightHandAnchor, .middleFingerIntermediateBase,rightMiddleFingerIntermediateBaseModelEntity.transform)
        rightMiddleFingerIntermediateTipModelEntity.transform = getTransform(rightHandAnchor, .middleFingerIntermediateTip, rightMiddleFingerIntermediateTipModelEntity.transform)
        rightMiddleFingerTipModelEntity.transform = getTransform(rightHandAnchor, .middleFingerTip,rightMiddleFingerTipModelEntity.transform)
        rightRingFingerMetacarpalModelEntity.transform = getTransform(rightHandAnchor, .ringFingerMetacarpal,rightRingFingerMetacarpalModelEntity.transform)
        rightRingFingerKnuckleModelEntity.transform = getTransform(rightHandAnchor, .ringFingerKnuckle,rightRingFingerKnuckleModelEntity.transform)
        rightRingFingerIntermediateBaseModelEntity.transform = getTransform(rightHandAnchor, .ringFingerIntermediateBase,rightRingFingerIntermediateBaseModelEntity.transform)
        rightRingFingerIntermediateTipModelEntity.transform = getTransform(rightHandAnchor, .ringFingerIntermediateTip, rightRingFingerIntermediateTipModelEntity.transform)
        rightRingFingerTipModelEntity.transform = getTransform(rightHandAnchor, .ringFingerTip,rightRingFingerTipModelEntity.transform)
        rightLittleFingerMetacarpalModelEntity.transform = getTransform(rightHandAnchor, .littleFingerMetacarpal,rightLittleFingerMetacarpalModelEntity.transform)
        rightLittleFingerKnuckleModelEntity.transform = getTransform(rightHandAnchor, .littleFingerKnuckle, rightLittleFingerKnuckleModelEntity.transform)
        rightLittleFingerIntermediateBaseModelEntity.transform = getTransform(rightHandAnchor, .littleFingerIntermediateBase, rightLittleFingerIntermediateBaseModelEntity.transform)
        rightLittleFingerIntermediateTipModelEntity.transform = getTransform(rightHandAnchor, .littleFingerIntermediateTip, rightLittleFingerIntermediateTipModelEntity.transform)
        rightLittleFingerTipModelEntity.transform = getTransform(rightHandAnchor, .littleFingerTip, rightLittleFingerTipModelEntity.transform)
        rightForearmWristModelEntity.transform = getTransform(rightHandAnchor, .forearmWrist, rightForearmWristModelEntity.transform)
        rightForearmArmModelEntity.transform = getTransform(rightHandAnchor, .forearmArm, rightForearmArmModelEntity.transform)
    }
    
    func getTransform(_ anchor: HandAnchor, _ jointName: HandSkeleton.JointName, _ beforeTransform: Transform) -> Transform {
        let joint = anchor.handSkeleton?.joint(jointName)
        if ((joint?.isTracked) != nil) {
            let t = matrix_multiply(anchor.originFromAnchorTransform, (anchor.handSkeleton?.joint(jointName).anchorFromJointTransform)!)
            return Transform(matrix: t)
        }
        return beforeTransform
    }
    
    func addToContent(_ content: RealityKit.RealityViewContent) {
        // Skeleton Joints to Track in View
        let modelEntities = [
            //Skeleton Joints to Track in View
            leftWristModelEntity,
            leftThumbKnuckleModelEntity,
            leftThumbIntermediateBaseModelEntity,
            leftThumbIntermediateTipModelEntity,
            leftThumbTipModelEntity,
            leftIndexFingerMetacarpalModelEntity,
            leftIndexFingerKnuckleModelEntity,
            leftIndexFingerIntermediateBaseModelEntity,
            leftIndexFingerIntermediateTipModelEntity,
            leftIndexFingerTipModelEntity,
            leftMiddleFingerMetacarpalModelEntity,
            leftMiddleFingerKnuckleModelEntity,
            leftMiddleFingerIntermediateBaseModelEntity,
            leftMiddleFingerIntermediateTipModelEntity,
            leftMiddleFingerTipModelEntity,
            leftRingFingerMetacarpalModelEntity,
            leftRingFingerKnuckleModelEntity,
            leftRingFingerIntermediateBaseModelEntity,
            leftRingFingerIntermediateTipModelEntity,
            leftRingFingerTipModelEntity,
            leftLittleFingerMetacarpalModelEntity,
            leftLittleFingerKnuckleModelEntity,
            leftLittleFingerIntermediateBaseModelEntity,
            leftLittleFingerIntermediateTipModelEntity,
            leftLittleFingerTipModelEntity,
            leftForearmWristModelEntity,
            leftForearmArmModelEntity,
            
            rightWristModelEntity,
            rightThumbKnuckleModelEntity,
            rightThumbIntermediateBaseModelEntity,
            rightThumbIntermediateTipModelEntity,
            rightThumbTipModelEntity,
            rightIndexFingerMetacarpalModelEntity,
            rightIndexFingerKnuckleModelEntity,
            rightIndexFingerIntermediateBaseModelEntity,
            rightIndexFingerIntermediateTipModelEntity,
            rightIndexFingerTipModelEntity,
            rightMiddleFingerMetacarpalModelEntity,
            rightMiddleFingerKnuckleModelEntity,
            rightMiddleFingerIntermediateBaseModelEntity,
            rightMiddleFingerIntermediateTipModelEntity,
            rightMiddleFingerTipModelEntity,
            rightRingFingerMetacarpalModelEntity,
            rightRingFingerKnuckleModelEntity,
            rightRingFingerIntermediateBaseModelEntity,
            rightRingFingerIntermediateTipModelEntity,
            rightRingFingerTipModelEntity,
            rightLittleFingerMetacarpalModelEntity,
            rightLittleFingerKnuckleModelEntity,
            rightLittleFingerIntermediateBaseModelEntity,
            rightLittleFingerIntermediateTipModelEntity,
            rightLittleFingerTipModelEntity,
            rightForearmWristModelEntity,
            rightForearmArmModelEntity
        ]
        
        modelEntities.forEach { content.add($0) }
    }
    
}
