//
//  TabBarController.swift
//  SoundMap
//
//  Created by 胡采思 on 10/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    var recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
    //var timer = Timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMiddleButton()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        var recordButtonFrame = recordButton.frame
        recordButtonFrame.origin.y = self.view.bounds.height - recordButtonFrame.height - 3
        recordButtonFrame.origin.x = self.view.bounds.width / 2 - recordButtonFrame.size.width / 2
        recordButton.frame = recordButtonFrame
        
        self.view.addSubview(recordButton)
        
        recordButton.setImage(UIImage(named: "tabbar-disk.png"), for: UIControlState.normal)
        recordButton.addTarget(self, action: #selector(TabBarController.recordButtonAction), for: UIControlEvents.touchUpInside)
        
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
    
    // record Button Touch Action
    func recordButtonAction(sender: UIButton) {
        self.selectedIndex = 0
        // console print to verify the button works
        print("Record Button was just pressed!")
        
        // Spin
        UIView.animate(withDuration: 0.25, animations:{
            sender.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
        })
        
        /*var popoverContent = UIViewController()
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.popover
        var popover = nav.popoverPresentationController as! UIPopoverPresentationController
        popover.delegate = self as! UIPopoverPresentationControllerDelegate
        popover.popoverContentSize = CGSizeMake(1000, 300)
        popover.sourceView = self.view
        popover.sourceRect = CGRectMake(100,100,0,0)
        
        self.present(nav, animated: true, completion: nil)*/
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
