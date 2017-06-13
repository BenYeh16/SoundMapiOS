//
//  RecordInfoViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 12/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit

class RecordInfoViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var recordInfoView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var soundInfoLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set design attributes
        recordInfoView.layer.cornerRadius = 10
        recordInfoView.layer.masksToBounds = true
        soundInfoLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        titleText.layer.borderColor = UIColor.init(red: 203/255, green: 203/255, blue: 203/255, alpha: 1).cgColor
        descriptionText.layer.borderColor = UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1).cgColor
        saveButton.layer.borderColor = UIColor.init(red: 7/255, green: 55/255, blue: 99/255, alpha: 1).cgColor
        
        // Keyboard
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Text delegate
        descriptionText.delegate = self
        titleText.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /****** TextView related ******/
    /*func keyboardWillShow(notification: NSNotification) {
        /*let keyboardSize: CGSize = ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size)!
        let offset: CGSize = ((notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size)!
        
        if keyboardSize.height == offset.height {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }*/
        
        if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) {
            let rect = keyboardFrame.cgRectValue
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
                self.descriptionText.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0)
            }, completion: nil)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        /*if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue) {
            let rect = keyboardFrame.cgRectValue
            self.view.frame.origin.y += rect.size.height
        }*/
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            self.descriptionText.contentInset = UIEdgeInsets.zero
        }, completion: nil)

        
    }*/
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        //let scrollPoint : CGPoint = CGPoint(x: 0, y: self.descriptionText.frame.origin.y)
        //self.scrollView.setContentOffset(scrollPoint, animated: true)
        animateViewMoving(up: true, moveValue: 50)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        //self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        animateViewMoving(up: true, moveValue: -50)
    }
    
    func animateViewMoving (up: Bool, moveValue: CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    // Allow RETURN to hide keyboard for textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Allow RETURN to hide keyboard for textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n")
        {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

    
    /****** Button action ******/
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
