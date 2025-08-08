////
////  Piano.swift
////  piano101-test
////
////  Created by Mg  Good on 6/8/25.
////
//
import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct Piano : View {
    @Binding var highlightedIndex: Int
    let musicNotes : [MusicNote]
    let notes: [any KeyNote] = [
        WhiteNote(name: "C4"),
        WhiteNote(name: "D4"),
        WhiteNote(name: "E4"),
        WhiteNote(name: "F4"),
        WhiteNote(name: "G4"),
        WhiteNote(name: "A4"),
        WhiteNote(name: "B4"),
        WhiteNote(name: "C5"),
    ]

    
    var body: some View {
        HStack(spacing: 20) {
            ForEach(notes, id: \.id) { note in
                
                Model3D(named: musicNotes[highlightedIndex].pitch == note.name ? "blueNote" : note.modelName, bundle: realityKitContentBundle)
                                        .onTapGesture {
                                            SoundManager.shared.playSound(named: note.name)
                                                
                                                if musicNotes[highlightedIndex].pitch == note.name {
                                                    if (highlightedIndex < musicNotes.count - 1)
                                                    {
                                                        highlightedIndex += 1
                                                    }
                                                    else {
                                                        highlightedIndex = 0
                                                    }
                                                } else {
                                                    print("Wrong note tapped: \(note.name)")
                                                }

                                        }
                                        .hoverEffect(.lift)
            }
        }
    }
}
