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
    var isPaused:BooleanLiteralType = false;
    
    let url = URL(string: "http://140.112.90.203:4001/isLoginSuccess/userid/pw")
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let data = data,
                    let html = String(data: data, encoding: String.Encoding.utf8){
                    print(html)
                }
            }
        task.resume()
        self.isPaused = false;
        do {
            let audioPath = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
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
