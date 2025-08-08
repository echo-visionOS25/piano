//import SwiftUI
//
//struct MusicSheetView: View {
//    let notes: [MusicNote]
//    @Binding var highlightedIndex: Int
//    private let space: CGFloat = 2
//
//    var body: some View {
//        VStack(spacing: 30) {
//            // First ZStack (notes 0 to 15)
//            ZStack(alignment: .topLeading) {
//                StaffView(lines: 1, space: space)
//                ForEach(Array(notes.prefix(16).enumerated()), id: \.element.id) { index, note in
//                    NoteView(note: note, space: space, currentNote: (highlightedIndex == index))
//                        .padding(.leading, CGFloat(note.beat) * 20 * space)
//                }
//                .frame(height: 100)
//            }
//            
//            
//            // Second ZStack (notes 16 to 31)
//            ZStack(alignment: .topLeading) {
//                StaffView(lines: 1, space: space)
//                ForEach(Array(notes.dropFirst(16).enumerated()), id: \.element.id) { index, note in
//                    let actualIndex = index + 16
//                    NoteView(note: note, space: space, currentNote: (highlightedIndex == actualIndex))
//                        .padding(.leading, CGFloat(note.beat - 30) * 20 * space)
//                }
//                .frame(height: 100)
//            }
//        }
//    }
//}

import SwiftUI

struct MusicSheetView: View {
    let notes: [MusicNote]
    @Binding var highlightedIndex: Int
    private let space: CGFloat = 2

    var body: some View {
        VStack(spacing: 30) {
            // First ZStack (notes 0 to 15)
            ZStack(alignment: .topLeading) {
                StaffView(lines: 1, space: space)
                ForEach(Array(notes.prefix(16).enumerated()), id: \.element.id) { index, note in
                    NoteView(note: note, space: space, currentNote: (highlightedIndex == index))
                        .padding(.leading, CGFloat(note.beat) * 20 * space)
                }
                .frame(height: 100)
            }
            
            // Second ZStack (notes 16 to 31)
            ZStack(alignment: .topLeading) {
                StaffView(lines: 1, space: space)
                ForEach(Array(notes.dropFirst(16).prefix(16).enumerated()), id: \.element.id) { index, note in
                    let actualIndex = index + 16
                    NoteView(note: note, space: space, currentNote: (highlightedIndex == actualIndex))
                        .padding(.leading, CGFloat(note.beat - 30) * 20 * space)
                }
                .frame(height: 100)
            }
            
            // Third ZStack (notes 32 to 47)
            ZStack(alignment: .topLeading) {
                StaffView(lines: 1, space: space)
                ForEach(Array(notes.dropFirst(32).prefix(16).enumerated()), id: \.element.id) { index, note in
                    let actualIndex = index + 32
                    NoteView(note: note, space: space, currentNote: (highlightedIndex == actualIndex))
                        .padding(.leading, CGFloat(note.beat - 60) * 20 * space)
                }
                .frame(height: 100)
            }
        }
    }
}
