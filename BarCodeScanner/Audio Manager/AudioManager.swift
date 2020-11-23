//
//  AudioManager.swift
//  GlobalSmart
//
//  Created by Manoj Karki on 9/18/19.
//  Copyright © 2019 Global IME Bank Limited. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager: NSObject {
    
   fileprivate var audioPlayer: AVAudioPlayer?

   func playBleep() {

        guard let filePath = Bundle.main.path(forResource: "bleep.wav", ofType: nil) else {
            return
        }
        
        do {
             audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: filePath))
             audioPlayer?.prepareToPlay()
             audioPlayer?.play()
            
        } catch let error {
            print("Error initializing audio player \(error.localizedDescription)")
        }

    }

}
