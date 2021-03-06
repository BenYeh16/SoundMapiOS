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
    @IBOutlet weak var playButton: UIButton!
    
    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    var timer: Timer!
    
    let picker = UIImagePickerController()
    
    let catPictureURL = URL(string: "http://140.112.90.200:2096/")!
    
    let data = SharedData()
    
    func loadProfilePic(){
        let url = data.getUserPhoto(id: data.getUserId());
        if ( url.isEmpty ) {
            print("url is empty");
        } else {
            let session = URLSession(configuration: .default);
            let getUserPhotoSession = session.dataTask(with: URL(string: url)!) { (data, response, error) in
                if let e = error {
                    print("Error getting user photo: \(e)")
                } else {
                    if let res = response as? HTTPURLResponse {
                        print("Check if get user photo success \(res.statusCode)")
                        let image = UIImage(data: data!)
                        self.profileImage.image = image
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            getUserPhotoSession.resume();
        }
    }
    
    func loadProfileAudio(){
        let url = data.getUserAudio(id: data.getUserId());
        let playerItem = AVPlayerItem(url: URL(string: url)!)
        
        do {
            try remotePlayer = AVPlayer(playerItem: playerItem)
            self.remotePlayer.volume = 1.0
        } catch {
            print ("Can't load user audio")
        }
    }
    
    //func uploadProfilePhoto(UIImage: image){
        //let url = data.get
    //}
    
    
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
        
        
        // 1. Load Profile Picture
        
        loadProfilePic();
        
        // 2. Load User Name
        
        userName.text = data.getUserId()
        
        // 3. Load Profile Audio
        
        loadProfileAudio();
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /****** Audio ******/
    @IBAction func playAudioPressed(_ sender: Any) {
        if ( self.isPaused == false ) {
            remotePlayer.play()
            playButton.setImage(UIImage(named: "music-pause"), for: .normal)
            self.isPaused = true
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        } else {
            remotePlayer.pause()
            playButton.setImage(UIImage(named: "music-play"), for: .normal)
            self.isPaused = false
            timer.invalidate()
        }
    }

    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func stringFromFloatCMTime(time: Double) -> String {
        let intTime = Int(time)
        let seconds = intTime % 60
        let minutes = (intTime / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateTime(_ timer: Timer) {
        let currentTimeInSeconds = CMTimeGetSeconds((remotePlayer.currentItem?.currentTime())!)
        audioCurrent.text = stringFromFloatCMTime(time: currentTimeInSeconds)
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
    
    // Pick image
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImage.contentMode = .scaleAspectFill //3
        profileImage.image = chosenImage //4
        
        // Upload Image
        //uploadProfileImage(chosenImage: UIImage);
        
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
