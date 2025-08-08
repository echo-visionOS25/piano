//
//  ImmersiveView.swift
//  immersive_piano
//
//  Created by AUNG TAYZA OO on 8/8/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    private var keys = ["C4", "D4", "E4", "F4", "G4", "A4", "B4", "C5"]
    @State private var Entities: [String : Entity?] = [:]
    var body: some View {
        RealityView { content in
            //            makeHandEntities(in: content)
            let rootEntity = Entity()
            rootEntity.position = [0, 0, 0]
            
            //            Task {
            for (index, key) in keys.enumerated() {
                do {
                    let entity = try await Entity(named: "whiteNote", in: realityKitContentBundle)
                    entity.position = SIMD3<Float>((Float(index) * 0.08) - 0.08, 0.7, 0)
                    entity.components.set(CollisionComponent(shapes:[ShapeResource.generateBox(width: 0.05, height: 0.1, depth: 0.3)]))
                    entity.transform.translation.z = -0.8
                    entity.name = key
                    Entities[key] = entity
                    rootEntity.addChild(entity)
                    print("\(key) loaded successfully.")
                } catch {
                    print("Failed to load \(key): \(error)")
                }
            }
            
            let leftHand = Entity()
            
            leftHand.components.set(HandTrackingComponent(chirality: .left))
            content.add(leftHand)
            
            //            content.subscribe(to: CollisionEvents.Began.self, on: leftHand) { event in
            //                if (event.entityB.name = "C4")
            //            }
            
            let rightHand = Entity()
            rightHand.components.set(HandTrackingComponent(chirality: .right))
            content.add(rightHand)
            //            content.subscribe(to: CollisionEvents.Began.self, on: rootEntity) { event in
            //                print("collision", event.entityB.name)
            //            }
            
            for entity in Entities {
                let _ = content.subscribe(to: CollisionEvents.Began.self, on: entity.value) { event in
                    //                    SoundManager.shared.playSound(named: entity.key)
                    
                    switch entity.value?.name {
                    case "C4" : SoundManager.shared.playSound(named: "C4")
                    case "D4" : SoundManager.shared.playSound(named: "D4")
                    case "E4" : SoundManager.shared.playSound(named: "E4")
                    case "F4" : SoundManager.shared.playSound(named: "F4")
                    case "G4" : SoundManager.shared.playSound(named: "G4")
                    case "A4" : SoundManager.shared.playSound(named: "A4")
                    case "B4" : SoundManager.shared.playSound(named: "B4")
                    case "C5" : SoundManager.shared.playSound(named: "C5")
                    default : print("default")
                    }
                }
                }
                content.add(rootEntity)
            }
        }
    }

    
    //        @MainActor
    //        func makeHandEntities(in content: any RealityViewContentProtocol) {
    //            // Add the left hand.
    //            let leftHand = Entity()
    //            leftHand.components.set(HandTrackingComponent(chirality: .left))
    //            content.add(leftHand)
    //
    //
    //            // Add the right hand.
    //            let rightHand = Entity()
    //            rightHand.components.set(HandTrackingComponent(chirality: .right))
    //            content.add(rightHand)
    
    
    
    //#Preview(immersionStyle: .mixed) {
    //    ImmersiveView()
    //        .environment(AppModel())
    //}

