//
//  AudioPlayer.swift
//  Gwent
//
//  Created by Анатолий Миронов on 12.12.2021.
//

import AVFoundation

enum Music: String {
    case main = "H3Main"
    case combat = "H3Combat"
    case victory = "H3Victory"
}

class AudioPlayer {
    static let shared = AudioPlayer()
    var isMusicStop = false
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {}
    
    func playMusic(name: String) {
        let localURL = Bundle.main.path(forResource: name, ofType: "mp3")
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let localURL = localURL else { return }
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: localURL))
            
            guard let audioPlayer = audioPlayer else { return }
            audioPlayer.play()
        } catch {
            print("Audio: error")
        }
    }
    
    func stopMusic() {
        guard let audioPlayer = audioPlayer, audioPlayer.isPlaying else { return }
        audioPlayer.stop()
    }
}


