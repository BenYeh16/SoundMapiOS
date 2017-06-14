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
    
    let data = SharedData();
    var setUpFlag = false {
        didSet(oldValue) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "backToLogin", sender: nil);
            }
        }
    };

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
        if ( userIDTextField.hasText && passwordTextField.hasText ) {
            activityIndicator.startAnimating()
            let url = data.getSetUserAccount(id: userIDTextField.text!, password: passwordTextField.text!);
            if ( url.isEmpty ) {
                print("url is empty");
            } else {
                let session = URLSession(configuration: .default);
                let loginSession = session.dataTask(with: URL(string: url)!) { (data, response, error) in
                    if let e = error {
                        print("Error checking SetUp success: \(e)")
                    } else {
                        if let res = response as? HTTPURLResponse {
                            print("Check if SetUp success \(res.statusCode)")
                            let result = String(data: data!, encoding: String.Encoding.utf8) as String!;
                            if ( result == "True" ) {
                                self.setUpFlag = true;
                            } else {
                                // TODO : SetUp Fail
                            }
                        } else {
                            print("Couldn't get response code for some reason")
                        }
                    }
                }
                loginSession.resume();
            }
        }

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
    
    // Allow RETURN to hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Implement move textfield
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
