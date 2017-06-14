//
//  RecordInfoViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 12/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit
import AVFoundation
import CoreLocation


class RecordInfoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var recordInfoView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var soundInfoLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var audioCurrent: UILabel!
    @IBOutlet weak var audioTime: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    var timer: Timer!
    var soundFileURL: URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set design attributes
        recordInfoView.layer.cornerRadius = 10
        recordInfoView.layer.masksToBounds = true
        soundInfoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleText.layer.borderColor = UIColor.init(red: 203/255, green: 203/255, blue: 203/255, alpha: 1).cgColor
        descriptionText.layer.borderColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        saveButton.layer.borderColor = UIColor.init(red: 7/255, green: 55/255, blue: 99/255, alpha: 1).cgColor
        
        // Keyboard
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Text delegate
        descriptionText.delegate = self
        titleText.delegate = self
        
        // Initialize audio
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        soundFileURL = documentsDirectory.appendingPathComponent("recording-123.m4a")

        self.isPaused = false;
        do {
            //let audioPath = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            //try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            try player = AVAudioPlayer(contentsOf: soundFileURL!)
            player.volume = 1.0
            audioSlider.maximumValue = Float(player.duration)
            audioSlider.value = 0.0
            audioTime.text = stringFromTimeInterval(interval: player.duration)
            audioCurrent.text = stringFromTimeInterval(interval: player.currentTime)
            //try player = AVAudioPlayer(contentsOf: url)
            //let playerItem = AVPlayerItem(url: self.url)
            
            //try self.remotePlayer = AVPlayer(playerItem: playerItem)
            //self.remotePlayer.volume = 1.0
        } catch {
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /****** TextView related ******/
    /*func keyboardWillShow(notification: NSNotification) {
        /*let keyboardSize: CGSize = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)!
        let offset: CGSize = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size)!
        
        if keyboardSize.height == offset.height {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }*/
        
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) {
            let rect = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.descriptionText.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0)
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) {
            let rect = keyboardFrame.cgRectValue
            self.view.frame.origin.y += rect.size.height
        }*/
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.descriptionText.contentInset = UIEdgeInsets.zero
        }, completion: nil)

        
    }*/
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        animateViewMoving(up: true, moveValue: 50)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        animateViewMoving(up: true, moveValue: -50)
    }
    
    func animateViewMoving (up: Bool, moveValue: CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // Allow RETURN to hide keyboard for textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Allow RETURN to hide keyboard for textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    /****** Button action ******/
    @IBAction func saveSound(_ sender: Any) {
        let data = SharedData()
        //let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        //let soundFileURL: URL = documentsDirectory.appendingPathComponent("recording-123.m4a")
        //self.parentView.pinFromOutside()
        
        
        
        print("soundfile url: '\(soundFileURL)'")
        print("title: " + titleText.text!)
        print ("descripText: " + descriptionText.text)
        
        if ( titleText.text != "" && descriptionText.text != ""){
            
            print("ready to upload")
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "stopSoundNotification"), object: nil)
            
            let locationManager = CLLocationManager()
            var currentLocation = locationManager.location!
            /*upload with
             user id
             titleText.text 
             descriptionText.text
             \(currentLocation.coordinate.latitude)
             \(currentLocation.coordinate.longitude)
             \(soundFileURL)
                */
            
            var storeUrl = data.storeSound(latitude: "25.033331",
                longitude: "121.534831",
                id: data.getUserId(),
                title: titleText.text!,
                descript: descriptionText.text
            )
            print("!@#!@#!# storeUrl" + storeUrl)
            var request = URLRequest(url: URL(string: storeUrl)!) // link removed
            //var request = URLRequest(url : URL(string: "http://140.112.90.203:4000/setUserVoice/1")!)
            
            request.httpMethod = "POST"
            
            
            /* create body*/
            let body = NSMutableData()
            //let file = "\(soundFileURL)" // :String
            let bundlefile = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            print("!!!!!! " + bundlefile!)
            let url = URL(string: bundlefile!) // :URL
            let data = try! Data(contentsOf: url!)
            body.append(data)
            
            request.httpBody = body as Data
            /* body create complete*/
            
            let atask = URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil{
                    print("error in dataTask")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        let resultValue:String = parseJSON["success"] as! String;
                        print("result: \(resultValue)")
                        print(parseJSON)
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            atask.resume()
            // Close modal
            dismiss(animated: true, completion: nil)
        }else {
            let alertController = UIAlertController(
                title: "Don't leave Blank",
                message: "Title or description missing",
                preferredStyle: .alert)
            
            // 建立[確認]按鈕
            let okAction = UIAlertAction(
                title: "確認",
                style: .default,
                handler: {
                    (action: UIAlertAction!) -> Void in
                    print("按下確認後，閉包裡的動作")
            })
            alertController.addAction(okAction)
            
            // 顯示提示框
            self.present(
                alertController,
                animated: true,
                completion: nil)
        }
        
        
        
        
        //
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    /****** Audio ******/
    @IBAction func playAudioPressed(_ sender: Any) {
        if ( self.isPaused == false ) {
            player.play()
            playButton.setImage(UIImage(named: "music-pause"), for: .normal)
            self.isPaused = true
            //audioSlider.value = Float(player.currentTime)
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        } else {
            player.pause()
            playButton.setImage(UIImage(named: "music-play"), for: .normal)
            self.isPaused = false
            timer.invalidate()
        }
    }
    
    @IBAction func slide(_ sender: Any) {
        player.currentTime = TimeInterval(audioSlider.value)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateSlider(_ timer: Timer) {
        audioSlider.value = Float(player.currentTime)
        audioCurrent.text = stringFromTimeInterval(interval: player.currentTime)
        audioTime.text = stringFromTimeInterval(interval: player.duration - player.currentTime)
        if audioTime.text == "00:00" { // done
            playButton.setImage(UIImage(named: "music-play"), for: .normal)
        }
        
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
