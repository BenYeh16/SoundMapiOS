//
//  ProfileViewController.swift
//  SoundMap
//
//  Created by mhci on 2017/6/7.
//  Copyright © 2017年 cnl4. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {

    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    
    let url = URL(string: "http://140.112.90.200:2096/")!
    //let url = URL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")!
    //let NSurl = NSURL(string: "http://140.112.90.200:2096/")!
    let catPictureURL = URL(string: "http://140.112.90.200:2096/")!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playAudioPressed(_ sender: Any) {
        if ( self.isPaused == false ) {
            remotePlayer.play()
            playButton.setBackgroundImage(UIImage(named: "audioplayer_pause.png"), for: .normal)
            self.isPaused = true
        } else {
            remotePlayer.pause()
            playButton.setBackgroundImage(UIImage.init(named: "audioplayer_play"), for: .normal)
            self.isPaused = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                print("Start Request")
                if let data = data,
                    let html = String(data: data, encoding: String.Encoding.utf8){
                    print(html)
                }
            }
        //task.resume()
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
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
        //downloadPicTask.resume()
        
        self.isPaused = false;
        do {
            let audioPath = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            //try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            //try player = AVAudioPlayer(contentsOf: url)
            let playerItem = AVPlayerItem(url: url)
            
            try remotePlayer = AVPlayer(playerItem: playerItem)
            remotePlayer.volume = 1.0
        } catch {
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
