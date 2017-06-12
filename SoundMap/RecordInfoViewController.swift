//
//  RecordInfoViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 12/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit

class RecordInfoViewController: UIViewController {

    @IBOutlet weak var recordInfoView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var soundInfoLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set design attributes
        recordInfoView.layer.cornerRadius = 10
        recordInfoView.layer.masksToBounds = true
        soundInfoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleText.layer.borderColor = UIColor.init(red: 203/255, green: 203/255, blue: 203/255, alpha: 1).cgColor
        descriptionText.layer.borderColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        saveButton.layer.borderColor = UIColor.init(red: 7/255, green: 55/255, blue: 99/255, alpha: 1).cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveSound(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
