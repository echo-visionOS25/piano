//
//  ContentView.swift
//  immersion
//
//  Created by Event on 6/8/25.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum AppState {
    case welcome, songInfo, tutorial, experienceMode, piano
}

// MARK: - Content View
struct ContentView: View {
    @State private var appState: AppState = .welcome
    @State private var glowAmount: CGFloat = 0.3
    @State private var isImmersive = false
    
    let scenes = ["mountain-scene", "lake-scene"]
    @State private var currentSceneIndex = 0
    
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    var body: some View {
        ZStack {
            VStack {
                // Main app state-driven UI
                switch appState {
                case .welcome:
                    WelcomeView(glowAmount: $glowAmount) {
                        appState = .songInfo
                    }
                case .songInfo:
                    SongInfoView {
                        appState = .tutorial
                    }
                case .tutorial:
                    TutorialView {
                        appState = .experienceMode
                    }
                case .experienceMode:
                    ExperienceModeView { immersive in
                        isImmersive = immersive
                        appState = .piano
                    }
                case .piano:
                    if isImmersive {
                        EmptyView()
                        VStack {
                            Button("Next Scene") {
                                Task {
                                    await dismissImmersiveSpace()
                                    try? await Task.sleep(nanoseconds: 500_000_000)
                                    await openImmersiveSpace(id: scenes[currentSceneIndex])
                                    currentSceneIndex = (currentSceneIndex + 1) % scenes.count
                                }
                            }
                            
                            Text("Next: \(getSceneName(scenes[currentSceneIndex]))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 30)
                    } else {
                        PianoOverlayView()
                    }
                }
            }
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    glowAmount = 1.0
                }
            }
            .task(id: appState) {
                if appState == .piano && isImmersive {
                    await openImmersiveSpace(id: "mountain-scene")
                    currentSceneIndex = 1 // prepare next scene as "lake-scene"
                }
            }
        }
    }
    private func getSceneName(_ sceneId: String) -> String {
        switch sceneId {
        case "mountain-scene": return "Mountain"
        case "lake-scene": return "Lake"
        default: return "Unknown"
        }
    }
}

// MARK: - Mountain View
struct ImmersiveMountainView: View {
    var body: some View {
        RealityView { content in
            do {
                // Load environment
                let material = try await UnlitMaterial(texture: .init(named: "mountain"))
                let sphere = ModelEntity(mesh: .generateSphere(radius: 15), materials: [material])
                sphere.scale = [-1, 1, 1]
                content.add(sphere)
                
                // Create piano root
                let pianoRoot = Entity()
                pianoRoot.position = [0, -0.5, -1.0]
                
                let light = DirectionalLight()
                light.light.intensity = 2000
                light.light.color = .white
                content.add(light)
                
                // Add white notes
                let noteNames = ["C5", "D5", "E5", "F5", "G5", "A5", "B5", "C6"]
                
                for (i, name) in noteNames.enumerated() {
                    let noteEntity = try await Entity(named: "whiteNote", in: realityKitContentBundle)
                    noteEntity.name = name
                    noteEntity.position = [Float(i) * 0.12, 0, 0]
                    
                    // Enable interaction
                    //                    noteEntity.generateCollisionShapes(recursive: true)
                    //                    noteEntity.components.set(InputTargetComponent())
                    //                    noteEntity.onTap { _ in
                    //                        SoundManager.shared.playSound(named: name)
                    //                    }
                    
                    pianoRoot.addChild(noteEntity)
                }
                
                content.add(pianoRoot)
                
            } catch {
                print("❌ Failed to load immersive piano: \(error)")
            }
        }
    }
}

// MARK: - Piano View
struct PianoOverlayView: View {
    let sampleNotes: [MusicNote] = [
        // "Twinkle, twinkle, little star"
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 0),
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 1),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 2),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 3),
            MusicNote(pitch: "A4", duration: .quarter, measure: 0, beat: 4),
            MusicNote(pitch: "A4", duration: .quarter, measure: 0, beat: 5),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 6),

            // "How I wonder what you are"
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 7),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 8),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 9),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 10),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 11),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 12),
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 13),

            // "Up above the world so high"
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 14),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 15),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 16),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 17),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 18),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 19),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 20),

            // "Like a diamond in the sky"
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 21),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 22),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 23),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 24),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 25),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 26),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 27),

            // "Twinkle, twinkle, little star" (REPEAT)
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 28),
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 29),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 30),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 31),
            MusicNote(pitch: "A4", duration: .quarter, measure: 0, beat: 32),
            MusicNote(pitch: "A4", duration: .quarter, measure: 0, beat: 33),
            MusicNote(pitch: "G4", duration: .quarter, measure: 0, beat: 34),

            // "How I wonder what you are" (REPEAT)
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 35),
            MusicNote(pitch: "F4", duration: .quarter, measure: 0, beat: 36),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 37),
            MusicNote(pitch: "E4", duration: .quarter, measure: 0, beat: 38),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 39),
            MusicNote(pitch: "D4", duration: .quarter, measure: 0, beat: 40),
            MusicNote(pitch: "C4", duration: .quarter, measure: 0, beat: 41),
    ]
    
    
    @State private var highlightedNoteIndex = 0

    var body: some View {
        VStack
        {
            
            Spacer()
            MusicSheetView(notes: sampleNotes, highlightedIndex: $highlightedNoteIndex)
                .frame(width: 1150, height: 100)
            Spacer()
            Piano(highlightedIndex: $highlightedNoteIndex, musicNotes: sampleNotes)
                .padding(.top, 50)
            Spacer()
        }
    }
    
}

// MARK: - Lake View
struct ImmersiveLakeView: View {
    var body: some View {
        RealityView { content in
            do {
                let material = try await UnlitMaterial(
                    texture: .init(named: "lake")
                )
                
                // Generate a regular sphere
                let sphere = ModelEntity(
                    mesh: .generateSphere(radius: 15),
                    materials: [material]
                )
                
                // Invert the sphere by flipping the X scale
                sphere.scale = [-1, 1, 1] // Flip inside-out
                
                sphere.position = [0, 0, 0]
                content.add(sphere)
                
                
            } catch {
                print("❌ Failed to load lake texture: \(error)")
            }
        }
    }
}
    
    // MARK: - Welcome Screen
    struct WelcomeView: View {
        @Binding var glowAmount: CGFloat
        var onTap: () -> Void
        
        var body: some View {
            VStack(spacing: 30) {
                Text("🎶 Welcome to Echo App")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                
                Text("Tap anywhere to begin")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .shadow(color: .cyan.opacity(glowAmount), radius: 20)
                    .shadow(color: .cyan.opacity(glowAmount * 0.6), radius: 40)
                    .shadow(color: .cyan.opacity(glowAmount * 0.3), radius: 60)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //        .background(Color.black)
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
        }
    }
    
    // MARK: - Song Info
    struct SongInfoView: View {
        var onNext: () -> Void
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Let's play...")
                    .font(.system(size: 30))
                    .padding(.top)
                
                Text("🌟 Twinkle Twinkle Little Star 🌟")
                    .font(.system(size: 38, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("Press Next to continue")
                    .font(.system(size: 20))
                
                Button("Next") {
                    onNext()
                }
                .font(.title2)
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //        .background(Color.white)
        }
    }
    
    // MARK: - Tutorial
struct TutorialView: View {
    var onStart: () -> Void

    // Note names and solfège mapping
    let keyNotes = ["C", "D", "E", "F", "G", "A", "B", "C"]
    let solfege = ["Do", "Re", "Mi", "Fa", "Sol", "La", "Si", "Do"]

    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                Text("🎹 Tutorial")
                    .font(.system(size: 32, weight: .bold))

                Text("• Follow the glowing keys\n• Pinch to play notes\n• Try to keep up with the melody")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20))
                    .padding()

                // 🎼 Music Notation Image
                Image(uiImage: UIImage(named: "notes") ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .cornerRadius(10)
                    .padding(.horizontal)

                // 🎹 Piano keys with note + solfège
                HStack(spacing: 6) {
                    ForEach(0..<keyNotes.count, id: \.self) { index in
                        VStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 40, height: 150)
                                .cornerRadius(5)
                                .shadow(radius: 2)

                            Text(keyNotes[index])
                                .font(.caption)
                                .foregroundColor(.black)

                            Text(solfege[index])
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(1))
                .cornerRadius(10)

                // Start Button
                Button("Start!") {
                    onStart()
                }
                .font(.title2)
                .padding()
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity)
            .padding()
//            .background(Color.white.opacity(0.95))
        }
    }
}
    
    // MARK: - Experience Mode Selection
    struct ExperienceModeView: View {
        var onSelectMode: (_ isImmersive: Bool) -> Void
        
        var body: some View {
            VStack(spacing: 30) {
                Text("Choose Experience Mode")
                    .font(.title2)
                
                Button("🌌 Immersive View") {
                    onSelectMode(true)
                }
                .buttonStyle(.borderedProminent)
                
                Button("🪟 Real World Overlay") {
                    onSelectMode(false)
                }
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //        .background(Color.white)
        }
        //    if(onSelectMode){
        //        Task {
        //                await dismissImmersiveSpace()
        //
        //                // Open the current scene
        //                await openImmersiveSpace(id: scenes[currentSceneIndex])
        //
        //                // Move to next scene for next button press
        //                currentSceneIndex = (currentSceneIndex + 1) % scenes.count
        //
        ////                    }
        //
        //        }
        //    }
        
    }
    
    // MARK: - Piano View
    struct PianoView: View {
        let isImmersive: Bool
        
        var body: some View {
            ZStack {
                if isImmersive {
                    LinearGradient(
                        colors: [.purple, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    ).ignoresSafeArea()
                } else {
                    Color.clear.ignoresSafeArea()
                }
                
                VStack(spacing: 20) {
                    Text("🎹 Piano Mode")
                        .font(.largeTitle)
                        .foregroundColor(isImmersive ? .white : .black)
                    
                    Text(isImmersive ? "Immersive Mode" : "Real World Overlay")
                        .foregroundColor(isImmersive ? .white.opacity(0.8) : .gray)
                    
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isImmersive ? Color.white.opacity(0.3) : Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(Text("🎶 3D Piano UI Here").foregroundColor(.primary))
                }
                .padding()
            }
        }
    }


#Preview {
    ContentView()
}
