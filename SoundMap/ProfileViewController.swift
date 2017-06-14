//
//  ProfileViewController.swift
//  SoundMap
//
//  Created by mhci on 2017/6/7.
//  Copyright © 2017年 cnl4. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    @IBOutlet weak var audioCurrent: UILabel!
    @IBOutlet weak var audioTime: UILabel!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    
    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    var timer: Timer!
    
    let picker = UIImagePickerController()
    
    let url = URL(string: "http://140.112.90.200:2096/")!
    //let url = URL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")!
    //let NSurl = NSURL(string: "http://140.112.90.200:2096/")!
    let catPictureURL = URL(string: "http://140.112.90.200:2096/")!
    let testURL = URL(string: "http://140.112.90.203:4005/getuserinformation/1")!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
        self.picker.delegate = self
 
        // Get user name
        self.userName.font = self.userName.font?.withSize(30)
        // TODO: get userID
        
        // Set image to circle
        self.profileImage.frame = CGRect(x: 85, y: 124, width: 150, height: 150) ; // set as you want
        self.profileImage.layer.cornerRadius = self.profileImage.frame.height / 2
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderWidth = 2
        self.profileImage.layer.borderColor = UIColor(red: 86/255, green: 86/255, blue: 1/255, alpha: 1).cgColor
        
 
        // Get audio
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                if let data = data,
                    let html = String(data: data, encoding: String.Encoding.utf8){
                    print(html)
                }
            }
        task.resume()
 
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: self.testURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if data != nil {
                        // Finally convert that Data into an image and do what you wish with it.
                        //let image = UIImage(data: imageData)
                        //self.profileImage.image = image
                        do  {
                            let parsedData = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                            let currentConditions = parsedData["name"] as! String
                            
                            let image = UIImage(data: parsedData["photo"] as! Data)
                            self.profileImage.image = image
                            
                            
                            
                            print(currentConditions)

                        } catch let error as Error{
                            print (error)
                        }
                        //print(imageData)
                        // Do something with your image.
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
 
        
        self.isPaused = false;
        do {
            let audioPath = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
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
    }
    
    
    /****** Photo ******/
    // Upload photo from library
    @IBAction func uploadPhoto(_ sender: Any) {
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.picker.modalPresentationStyle = .popover
        present(self.picker, animated: true, completion: nil)
        self.picker.popoverPresentationController?.sourceView = uploadButton!
        
    }
    
    // Upload photo from taken picture
    /*@IBAction func shootPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }*/
    
    // Pick image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImage.contentMode = .scaleAspectFill //3
        profileImage.image = chosenImage //4
        
        dismiss(animated:true, completion: nil) //5
    }
    
    // Cancel picking from library
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Alert if no camera
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }

}
