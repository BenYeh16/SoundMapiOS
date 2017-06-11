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
    var isPaused:BooleanLiteralType = false;
    
    let url = URL(string: "http://140.112.90.203:4001/isLoginSuccess/userid/pw")
    let picker = UIImagePickerController()

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        
        // Get user name
        userName.font = userName.font.withSize(30)
        // TODO: get userID
        
        // Set image to circle
        profileImage.frame = CGRect(x: 85, y: 124, width: 150, height: 150) ; // set as you want
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor(red: 86/255, green: 86/255, blue: 1/255, alpha: 1).cgColor
        
        
        // Get audio
        /*let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
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
        }*/
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
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.sourceView = uploadButton!
        
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
