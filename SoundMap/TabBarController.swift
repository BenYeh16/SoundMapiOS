//
//  TabBarController.swift
//  SoundMap
//
//  Created by 胡采思 on 10/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController, UIPopoverPresentationControllerDelegate, AVAudioRecorderDelegate {
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    //var meterTimer:Timer!
    var recordBtnTappedCount = 0
    var isRecording = true
    var soundFileURL: URL!
    var playButton: UIButton! = nil
    @IBOutlet var recordButton: UIButton!
    
    //var timer = Timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecordButton()
        setupPlayButton()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .allowUserInteraction],
                       animations: {self.recordButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) )},
                       completion: nil)
        changeState()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupPlayButton(){
        playButton = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        playButton.backgroundColor = UIColor.gray
        playButton.addTarget(self, action: #selector(pressPlayButton(button:)), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    func pressPlayButton(button: UIButton) {
        var url:URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.soundFileURL!
        }
        print("playing \(url ?? nil)")
        
        do {
            self.player = try AVAudioPlayer(contentsOf: url!)
            
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
        NSLog("pressed!")
    }
    // TabBarButton – Setup Middle Button
    func setupRecordButton() {
        var recordButtonFrame = recordButton.frame
        recordButtonFrame.origin.y = self.view.bounds.height - recordButtonFrame.height - 3
        recordButtonFrame.origin.x = self.view.bounds.width / 2 - recordButtonFrame.size.width / 2
        recordButton.frame = recordButtonFrame
        
        self.view.addSubview(recordButton)
        self.view.layoutIfNeeded()
        
        //recordButton.addTarget(self, action: #selector(TabBarController.startRecording), for: UIControlEvents.touchDown)
        //recordButton.addTarget(self, action: #selector(TabBarController.stopRecording), for: [UIControlEvents.touchUpInside, UIControlEvents.touchUpOutside])
        
    }
    
    /*func startRecording() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(TabBarController.spin), userInfo: nil, repeats: true)
        
    }
    
    func spin() {
        // Spin
        UIView.animate(withDuration: 5, animations:{
    self.recordButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
    })

    }
    
    func stopRecording() {
        timer.invalidate(<#Timer#>)
    }*/
    
    
    @IBAction func record(_ sender: UIButton) {
        
        self.selectedIndex = 0
        // console print to verify the button works
        print("Record Button was just pressed!")
        
        // Spin
        changeState()
        if isRecording {
            recordButton.setImage(#imageLiteral(resourceName: "compactDisc"), for: .normal)
            record()
            
        }else{
            recordButton.setImage(#imageLiteral(resourceName: "tabbar-disk"), for: .normal)
            print("stop")
            recorder?.stop()
            //meterTimer.invalidate()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setActive(false)
            } catch let error as NSError {
                print("could not make session inactive")
                print(error.localizedDescription)
            }
            
            // Show modal
            performSegue(withIdentifier: "recordPopover", sender: nil)
        }
        
    }
    func record() {
        
        /*if player != nil && player.isPlaying {
            player.stop()
        }*/
        
        if recorder == nil {
            print("recording. recorder nil")
            recordWithPermission(true)
            return
        } else {
            print("recording")
            //recordButton.setTitle("Pause", for:UIControlState())
            //recorder.record()
            recordWithPermission(false)
        }
    }
   
    func recordWithPermission(_ setup:Bool) {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    self.recorder.record()
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    func setupRecorder() {
        //let format = DateFormatter()
        //format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        let currentFileName = "recording-123.m4a"
        print("currentFileName : " + currentFileName)
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.soundFileURL = documentsDirectory.appendingPathComponent(currentFileName)
        print("writing to soundfile url: '\(soundFileURL!)'")
        
        if FileManager.default.fileExists(atPath: soundFileURL.absoluteString) {
            // probably won't happen. want to do something about it?
            print("soundfile \(soundFileURL.absoluteString) exists")
        }
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey:             NSNumber(value: kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : NSNumber(value:AVAudioQuality.max.rawValue),
            AVEncoderBitRateKey :      NSNumber(value:320000),
            AVNumberOfChannelsKey:     NSNumber(value:2),
            AVSampleRateKey :          NSNumber(value:44100.0)
        ]
        
        
        do {
            recorder = try AVAudioRecorder(url: soundFileURL, settings: recordSettings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            recorder = nil
            print(error.localizedDescription)
        }
        
    }
    // UIPopoverPresentationControllerDelegate method
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Force popover style
        return UIModalPresentationStyle.none
    }

    
    // record Button Touch Action
    func recordButtonAction(sender: UIButton) {
        self.selectedIndex = 0
        // console print to verify the button works
        print("Record Button was just pressed!")
        
        // Spin
        UIView.animate(withDuration: 0.25, animations:{
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        })
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyboard.instantiateViewController(withIdentifier: "recordPopover")
        popoverVC.view.backgroundColor = UIColor.brown
        popoverVC.modalTransitionStyle = .crossDissolve
        present(popoverVC, animated: true, completion:nil)
        
        /*var popoverContent = UIViewController()
        var nav = UINavigationContsroller(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        var popover = nav.popoverPresentationController as! UIPopoverPresentationController
        popover.delegate = self as! UIPopoverPresentationControllerDelegate
        popover.popoverContentSize = CGSizeMake(1000, 300)
        popover.sourceView = self.view
        popover.sourceRect = CGRectMake(100,100,0,0)
        
        self.present(nav, animated: true, completion: nil)*/
    }
    
    
    func pauseLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    func resumeLayer(layer: CALayer) {
        let pausedTime: CFTimeInterval = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    func changeState() {
        let layer = recordButton.layer
        
        if isRecording {
            pauseLayer(layer : layer)
        } else {
            resumeLayer(layer : layer)
        }
        isRecording = !isRecording
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
