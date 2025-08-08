//
//  NoteView.swift
//  painoWindow
//
//  Created by AUNG TAYZA OO on 7/8/25.
//

import SwiftUI

struct NoteView: View {
    var note: MusicNote
    var space: CGFloat = 1
    var currentNote : Bool
    var body: some View {
        Circle()
            .fill(currentNote ? .blue : .black)
            .frame(width: 10 * space, height: 12 * space)
            .foregroundColor(.black)
            .offset(x: CGFloat(note.beat * 17.5 * space), y: yOffset(for: note.pitch))
            
       
    }
    
    
    
    private func yOffset(for pitch: String) -> CGFloat {
            let mapping: [String: CGFloat] = [
                "C4": 30 * space, "D4": 25 * space, "E4": 19 * space, "F4": 14 * space, "G4": 8 * space, "A4" : 3 * space, "B4" : -3 * space, "C5" : -8 * space, "D5" : -14 * space, "E5" : -19 * space , "F5" : -25 * space, "G5" : -30 * space
            ]
            return mapping[pitch] ?? 0
        }
}

//#Preview {
//    NoteView(note: MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 1), space: 3)
//           .frame(width: 200, height: 100)
//           .border(Color.gray)
//}
