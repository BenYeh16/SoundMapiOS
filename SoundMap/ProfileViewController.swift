//
//  ProfileViewController.swift
//  SoundMap
//
//  Created by mhci on 2017/6/7.
//  Copyright © 2017年 cnl4. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ProfileViewController: UIViewController {

    var player:AVAudioPlayer = AVAudioPlayer();
    var remotePlayer:AVPlayer = AVPlayer();
    var isPaused:BooleanLiteralType = false;
    
    let url = URL(string: "http://140.112.90.203:4000/audio")!
    //let url = URL(string: "https://s3.amazonaws.com/kargopolov/BlueCafe.mp3")!
    //let NSurl = NSURL(string: "http://140.112.90.200:2096/")!
    let catPictureURL = URL(string: "http://140.112.90.200:2096/")!
    let catPictureURL = URL(string: "http://140.112.90.203:4000/getUserPhoto/1")!
    let testURL = URL(string: "http://140.112.90.203:4005/testjson")!
    let usernameURL = URL(string: "http://140.112.90.203:4000/username")!
    
    
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
        let task = URLSession.shared.dataTask(with: usernameURL) { (data, response, error) in
                if let data = data,
                    let html = String(data: data, encoding: String.Encoding.utf8){
                    self.userName.text = String(data: data, encoding: String.Encoding.utf8) as String!
                }
            }
        //task.resume()
        
        // Creating a session object with the default configuration.
        // You can read more about it here https://developer.apple.com/reference/foundation/urlsessionconfiguration
        let session = URLSession(configuration: .default)
        
        // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.

        let downloadPicTask = session.dataTask(with: self.catPictureURL) { (data, response, error) in
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
            //let audioPath = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
            //try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
            //try player = AVAudioPlayer(contentsOf: url)
            
            let playerItem = AVPlayerItem(url: self.url)
            try self.remotePlayer = AVPlayer(playerItem: playerItem)
            self.remotePlayer.volume = 1.0
            
            //audioSlider.maximumValue = Float(remotePlayer.currentItem?.duration)
            //audioSlider.value = 0.0
            //audioTime.text = stringFromTimeInterval(interval: remotePlayer.duration)
            //audioCurrent.text = stringFromTimeInterval(interval: remotePlayer.currentTime)
            
            
        } catch {
        }
        
        //if let uploadImage = UIImage(named: "tex.jpg") {
            // Upload Image
        //let dict = ["Email": "test@gmail.com", "Password":"123456"] as [String: Any]
        //if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            var request = URLRequest(url: URL(string: "http://140.112.90.203:4000/storeSound/12/13/1/title/des/date/tag")!) // link removed
            request.httpMethod = "POST"
            //request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //request.httpBody = jsonData
            //let postString = "user_id=a&image=\(uploadImage)"
            request.httpBody = self.createRequestBodyWith(parameters:["1":1 as NSObject], filePathKey:"upload", boundary:self.generateBoundaryString()) as Data
            //request.httpBody = "hello".data(using: .utf8)
            //request.httpBody = uploadImage
            let atask = URLSession.shared.dataTask(with: request) { data, response, error in
                /*
                guard let data = data, error == nil else {               // check for fundamental networking error
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? AnyObject
                
                    if let parseJSON = json {
                        print("resp :\(parseJSON)")
                    }
                } catch let error as NSError {
                    print("error : \(error)")
                }
                */
                if error != nil{
                    print(error?.localizedDescription)
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
        //}
    }
    
    func createRequestBodyWith(parameters: [String: NSObject], filePathKey:String, boundary:String) -> NSData {
        
        let body = NSMutableData()
        
        /*for (key, value) in parameters {
            body.append( stringToData(string: "--\(boundary)\r\n") )
            body.append( stringToData(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n") )
            body.append( stringToData(string: "\(value)\r\n") )
        }*/
        
        //body.append( stringToData(string: "--\(boundary)\r\n"))
        
        //var mimetype = "image/jpg"
        
        //let defFileName = "tex.jpg"
        
        //let uploadImage = UIImage(named: "audiofile.mp3")
        //let imageData = UIImageJPEGRepresentation(uploadImage!, 1)
        
        
        /*if let filepath = Bundle.main.ur
            do {
                let content = try Data(contentsOf: filepath);
                body.append(content)
            } catch {
                print("error")
            }
        }*/
        
        /*
        let filepath = Bundle.main.url(forResource: "Coldplay-feat", withExtension: "jpg")
        do {
            let data = try Data(contentsOf: filepath!)
            body.append(data)
        } catch {
            print("error")
        }
        */
        let file = Bundle.main.path(forResource: "audiofile", ofType: "mp3")
        let url = URL(fileURLWithPath: file!)
        let data = try! Data(contentsOf: url)
        body.append(data)
        
        //body.append( stringToData(string:"Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n") )
        //body.append( stringToData(string: "Content-Type: \(mimetype)\r\n\r\n") )
        //body.append(imageData!)
        //body.append( stringToData(string: "\r\n") )
        
        //body.append( stringToData(string: "--\(boundary)--\r\n") )
        
        return body
    }

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func stringToData(string: String) -> Data {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        return data!
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func updateSlider(_ timer: Timer) {
        //audioSlider.value = Float(player.currentTime)
        //audioCurrent.text = stringFromTimeInterval(interval: player.currentTime)
        //audioTime.text = stringFromTimeInterval(interval: player.duration - player.currentTime)
    }
    
    /****** Audio ******/
    @IBAction func playAudioPressed(_ sender: Any) {
        if ( self.isPaused == false ) {
            //player.play()
            remotePlayer.play()
            playButton.setBackgroundImage(UIImage(named: "audioplayer_pause.png"), for: .normal)
            self.isPaused = true
            //audioSlider.value = Float(player.currentTime)
            timer = Timer(timeInterval: 1.0, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        } else {
            //player.pause()
            remotePlayer.pause()
            playButton.setBackgroundImage(UIImage.init(named: "audioplayer_play"), for: .normal)
            self.isPaused = false
            timer.invalidate()
        }
    }

    @IBAction func slide(_ sender: Any) {
         player.currentTime = TimeInterval(audioSlider.value)
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
