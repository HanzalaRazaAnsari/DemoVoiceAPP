//
//  UIPitchPerfect.swift
//  PitchPerfect1
//
//  Created by clines142 on 12/12/17.
//  Copyright © 2017 clines142. All rights reserved.
//

import UIKit
import AVFoundation

class UIPitchPerfect: UIViewController {
    

    
    var recordingUrl:URL!
    
    @IBOutlet weak var snailButton: UIButton!
    
    @IBOutlet weak var chipmunkButton: UIButton!
    
    @IBOutlet weak var rabbitButton: UIButton!
    
    @IBOutlet weak var vaderButton: UIButton!
    
    @IBOutlet weak var echoButton: UIButton!
    
    @IBOutlet weak var reverbButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case robot = 0, man, echo, woman
//        drunk , hysterical
    }
//    Your viewWillAppear will contain the following:
//    
//    override func viewWillAppear(_ animated: Bool) {
//        configureUI(.notPlaying)
//    }
    
    
    
    
    @IBAction func playBackSound(_ sender: UIButton) {
        
        self.stopButton.isEnabled = true
//        self.reverbButton.isEnabled = false
        self.snailButton.isEnabled = false
        self.rabbitButton.isEnabled = false
        self.vaderButton.isEnabled = false
//        self.echoButton.isEnabled = false
        self.chipmunkButton.isEnabled = false
//
        
        
        switch (ButtonType(rawValue: sender.tag)!) {
        case .robot  :
            playSound(rate: 0.8 , pitch: -500 , cosmo : true)
        case .man :
            playSound(rate : 0.8 , pitch: -250)
        case .echo :
            playSound(echo : true)
        case .woman :
            self.playSound(rate : 1 , pitch : 500 )
//        case .drunk :
//            playSound(rate: 0.5 , alien :true )
//        case .hysterical :
//            playSound(rate : 1.75 )
      
      configureUI(.playing)


        }
}
    

    
    
 
    
    @IBAction func share(_ sender: Any)  {
//
    
//        let activityItem = URL.init(fileURLWithPath: Bundle.main.path(forResource: "RecordingAudio", ofType: "wav")!)
        
        let activityVC = UIActivityViewController(activityItems: [recordingUrl],applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
        
//
    }
    @IBAction func Stop(_ sender: Any) {
        self.stopButton.isEnabled = false
        self.snailButton.isEnabled = true
        self.chipmunkButton.isEnabled = true
        self.vaderButton.isEnabled = true
        self.rabbitButton.isEnabled = true
//        self.echoButton.isEnabled = true
//        self.reverbButton.isEnabled = true
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("yes")
        print(recordingUrl)
        print("what")

        
        self.stopButton.isEnabled = false
        setupAudio()
       
    }
}
