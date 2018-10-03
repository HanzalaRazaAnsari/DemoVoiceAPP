//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright Â© 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - PlaySoundsViewController: AVAudioPlayerDelegate

extension UIPitchPerfect: AVAudioPlayerDelegate {
    
    // MARK: Alerts
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    
    // MARK: PlayingState (raw values correspond to sender tags)
    
    enum PlayingState { case playing, notPlaying }
    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            print(recordingUrl)
            audioFile = try AVAudioFile(forReading: recordingUrl!)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
    }
    
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false , alien:Bool = false , cosmo : Bool = false , echo2 : Bool = false) {
        
        // initialize audio engine components
        audioEngine = AVAudioEngine()
        
        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)
        
        // node for echo
         let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho2)
        audioEngine.attach(echoNode)
//
//        let echoNode = AVAudioUnitDistortion()
//        echoNode.loadFactoryPreset(.multiEcho)
//        audioEngine.attach(echoNode)
//
    
        
        // node for echo2
         let alienVoice = AVAudioUnitDistortion()
        alienVoice.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(alienVoice)
        
        let cosmoNode = AVAudioUnitDistortion()
        cosmoNode.loadFactoryPreset(.speechCosmicInterference)
        audioEngine.attach(cosmoNode)
    
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        
        var arr = [AVAudioNode]()
        arr.append(audioPlayerNode)
        arr.append(changeRatePitchNode)
        if echo == true{
            arr.append(echoNode)
        }
        
        if cosmo == true{
            arr.append(cosmoNode)
        }
        if alien == true{
            arr.append(alienVoice)
        }
        if reverb == true{
            arr.append(reverbNode)
        }
        arr.append(audioEngine.outputNode)
        connectAudioNodes(arr)
        // connect nodes
//        if echo == true && reverb == true && alien == true && cosmo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, alienVoice,cosmoNode, audioEngine.outputNode)
//
//        } else if echo == true && reverb == true {
//                connectAudioNodes(audioPlayerNode, changeRatePitchNode,echoNode,reverbNode, audioEngine.outputNode)
//           //  connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
//        } else if echo == true && alien == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode,alienVoice, audioEngine.outputNode)
//        } else if echo == true && cosmo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode,cosmoNode, audioEngine.outputNode)
//        } else if reverb == true && alien == true {
//                connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, alienVoice, audioEngine.outputNode)
//        } else if reverb == true && cosmo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, cosmoNode, audioEngine.outputNode)
//        } else if alien == true && cosmo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, alienVoice, cosmoNode ,audioEngine.outputNode)
//        } else if echo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
//        }  else if alien == true {
//                connectAudioNodes(audioPlayerNode, changeRatePitchNode, alienVoice, audioEngine.outputNode)
//        } else if reverb == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
//        } else if cosmo == true {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, cosmoNode, audioEngine.outputNode)
//        } else {
//            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
//        }
        
        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil)
        {
           print("[Extension].audioFile\(self.audioFile)")
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(UIPitchPerfect.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // play the recording!
        audioPlayerNode.play()
    }
    
    func lastTapEffect(){
        
        let recordedAudioEffect = audioPlayerNode.lastRenderTime.debugDescription
        
    }
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.notPlaying)
        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(_ nodes: [AVAudioNode]) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        snailButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        vaderButton.isEnabled = enabled
//        echoButton.isEnabled = enabled
//        reverbButton.isEnabled = enabled
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
