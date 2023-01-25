//
//  ViewController.swift
//  record
//
//  Created by Aswin Sasikanth Kanduri on 2023-01-18.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?

    @IBAction func recordAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
                playButton.isEnabled = false
                stopButton.isEnabled = true
                audioRecorder?.record()
            }
    }
    
    @IBAction func stopAudio(_ sender: Any) {
        stopButton.isEnabled = false
            playButton.isEnabled = true
            recordButton.isEnabled = true

            if audioRecorder?.isRecording == true {
                audioRecorder?.stop()
            } else {
                audioPlayer?.stop()
            }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        if audioRecorder?.isRecording == false {
               stopButton.isEnabled = true
               recordButton.isEnabled = false

               do {
                   try audioPlayer = AVAudioPlayer(contentsOf:
                           (audioRecorder?.url)!)
                   audioPlayer!.delegate = self
                   audioPlayer!.prepareToPlay()
                   audioPlayer!.play()
               } catch let error as NSError {
                   print("audioPlayer error: \(error.localizedDescription)")
               }
           }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
            stopButton.isEnabled = false

            let fileMgr = FileManager.default

            let dirPaths = fileMgr.urls(for: .documentDirectory,
                            in: .userDomainMask)

            let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")

            let recordSettings =
               [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                        AVEncoderBitRateKey: 16,
                        AVNumberOfChannelsKey: 2,
                        AVSampleRateKey: 44100.0] as [String : Any]

            let audioSession = AVAudioSession.sharedInstance()

            do {
                    try audioSession.setCategory(
                        AVAudioSession.Category.playAndRecord)
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }

            do {
                try audioRecorder = AVAudioRecorder(url: soundFileURL,
                    settings: recordSettings as [String : AnyObject])
                audioRecorder?.prepareToRecord()
            } catch let error as NSError {
                print("audioSession error: \(error.localizedDescription)")
            }
        
    }


}

