//
//  TabBarController.swift
//  SoundMap
//
//  Created by 胡采思 on 10/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarController: UITabBarController, UIPopoverPresentationControllerDelegate {
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var recordBtnTappedCount = 0
    var isRecording = true
    @IBOutlet var recordButton: UIButton!
    //var timer = Timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecordButton()
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
        
        if isRecording {
            changeState()
        }else{
            changeState()
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
        //self.myLabel.text = "\(isRecording)"
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
