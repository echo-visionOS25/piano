//
//  immersionApp.swift
//  immersion
//
//  Created by Event on 6/8/25.
//

import SwiftUI

@main
struct ImmersionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "mountain-scene") {
            ImmersiveMountainView()
        }

        ImmersiveSpace(id: "lake-scene") {
            ImmersiveLakeView()
        }
    }
}
