//
//  SignupViewController.swift
//  SoundMap
//
//  Created by 胡采思 on 07/06/2017.
//  Copyright © 2017 cnl4. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userIDTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIDTextField.delegate = self
        passwordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        activityIndicator.startAnimating()
    }
    
    
    /****** TextField related ******/
    
    // Move textfield position to avoid blocked by keyboard
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: 50)
    }
    
    // Move textfield back to original position
    func textFieldDidEndEditing(_ textField: UITextField) {
        animateViewMoving(up: true, moveValue: -50)
    }
    
    // Allow return to finish
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
