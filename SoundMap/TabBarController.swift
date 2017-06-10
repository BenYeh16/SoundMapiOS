//
//  TabBarController.swift
//  SoundMap
//
//  Created by 胡采思 on 10/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

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
        let recordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 65))
        
        var recordButtonFrame = recordButton.frame
        recordButtonFrame.origin.y = self.view.bounds.height - recordButtonFrame.height - 3
        recordButtonFrame.origin.x = self.view.bounds.width / 2 - recordButtonFrame.size.width / 2
        recordButton.frame = recordButtonFrame
        
        self.view.addSubview(recordButton)
        
        recordButton.setImage(UIImage(named: "tabbar-disk.png"), for: UIControlState.normal)
        recordButton.addTarget(self, action: #selector(TabBarController.recordButtonAction), for: UIControlEvents.touchUpInside)
        
        self.view.layoutIfNeeded()
    }
    
    // record Button Touch Action
    func recordButtonAction(sender: UIButton) {
        self.selectedIndex = 0
        // console print to verify the button works
        print("Middle Button was just pressed!")
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
