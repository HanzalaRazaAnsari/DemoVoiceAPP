import UIKit
import AVFoundation

class RecordSoundViewController : UIViewController, AVAudioRecorderDelegate{
    
    static let instance = RecordSoundViewController()
    var recordingName = ""
    var pathArray = [""]
    var filePath : URL?
    
    @IBOutlet weak var label: UILabel!
    
    //    var filePath : URL?
    @IBOutlet weak var playButton: UIButton!
    
    
    
    @IBOutlet weak var stopButton: UIButton!
    
    
    var audioRecorder:AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stopButton!.isEnabled = false
    }
    
    @IBAction func play(_ sender: Any) {
        
        
        
        label.text = "Recording in Progress"
        stopButton.isEnabled = true
        playButton.isEnabled = false
        
        
        //get path for recording
        let  dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask,true)[0] as String
        
        recordingName = "recordedAudio.wav"
        pathArray = [dirPath,recordingName]
        filePath = URL(string: pathArray.joined(separator: "/"))
        // print("FilePath:\(filePath)")
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        self.audioRecorder.delegate = self
        self.audioRecorder.isMeteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
        
    }
    
    
    //
    
    
    
    
    @IBAction func stop(_ sender: Any) {
        
        
        
        
        label.text = "Tap to Recording"
        stopButton.isEnabled  =  false
        playButton.isEnabled = true
        let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
        self.audioRecorder.stop()
        
        
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        print(flag)
        
        
        
        if flag{
            let url = recorder.url
            self.performSegue(withIdentifier: "record", sender: url)
            
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "record"{
            let dest = segue.destination as! UIPitchPerfect
            dest.recordingUrl = sender as! URL
            //  print(dest.recordedAudioURL)
            
        }
        
        
}
}
