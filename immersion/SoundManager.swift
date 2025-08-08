//
//  SoundManager.swift
//  immersion
//
//  Created by Event on 7/8/25.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    var audioPlayer: AVAudioPlayer?

    func playSound(named soundName: String) {
        
        guard let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "mp3")
        else {
            print("Sound file not found: soundss/\(soundName).mp3")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
