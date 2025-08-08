//
//  notes.swift
//  painoWindow
//
//  Created by AUNG TAYZA OO on 7/8/25.
//

import Foundation

enum    NoteDuration: String {
    case whole, half, quarter, eighth, sixteenth
}

struct MusicNote: Identifiable {
    let id = UUID()
    let pitch: String   // e.g., "C4", "D#5"
    let duration: NoteDuration
    let measure: Int
    let beat: Double
}
