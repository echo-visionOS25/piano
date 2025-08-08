//
//  immersionApp.swift
//  immersion
//
//  Created by Event on 6/8/25.
//

import SwiftUI

@main
struct ImmersionApp: App {
    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
              .environment(appModel)
        }
        
        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)

        ImmersiveSpace(id: "mountain-scene") {
            ImmersiveMountainView()
        }

        ImmersiveSpace(id: "lake-scene") {
            ImmersiveLakeView()
        }
    }
}
