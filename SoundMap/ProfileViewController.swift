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

    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    
    let url = URL(string: "http://140.112.90.200:2096/")!
    //let url = URL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")!
    //let NSurl = NSURL(string: "http://140.112.90.200:2096/")!
    let catPictureURL = URL(string: "http://140.112.90.200:2096/")!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!

    let picker = UIImagePickerController()
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
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
        let downloadPicTask = session.dataTask(with: self.url) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        self.profileImage.image = image
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
            playButton.setBackgroundImage(UIImage(named: "audioplayer_pause.png"), for: .normal)
            self.isPaused = true
        } else {
            player.pause()
            playButton.setBackgroundImage(UIImage.init(named: "audioplayer_play"), for: .normal)
            self.isPaused = false
        }
    }

    
    /****** Photo ******/
    @IBAction func uploadPhoto(_ sender: Any) {
        self.picker.allowsEditing = false
        self.picker.sourceType = .photoLibrary
        self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.picker.modalPresentationStyle = .popover
        present(self.picker, animated: true, completion: nil)
        self.picker.popoverPresentationController?.sourceView = uploadButton!
        
    }
    
    @IBAction func shootPhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCamera()
        }
    }
    
    //MARK: - Delegates
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        profileImage.contentMode = .scaleAspectFill //3
        profileImage.image = chosenImage //4
        

        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
