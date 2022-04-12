//
//  LoginViewController.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK:- IBOutlet
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var sendOTPButton: UIButton!
    
    // MARK:- Variables
    var currentVerificationId = ""
    let viewModel = LoginModelView()
    
    // View Controller Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.sendOTPButton.layer.cornerRadius = 8
    }
}

// MARK:- Action Methods -
extension LoginViewController {
    
    @IBAction func sendOTPButtonClicked(_ sender: UIButton) {
        
        let loginValidation =  viewModel.validateLogin(strmobileNumber: mobileNumberTextField.text ?? "")
        
        switch loginValidation {
            
        case .mobileNumberFailure(let message):
            self.showAlert(with: "Message", and: message)
            
        case .success:
            Auth.auth().languageCode = "en"
            
            // Added Country code
            let phoneNumber = ("+91" + mobileNumberTextField.text!)
            
            // Phone Auth Provider
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                
                // Error
                if let error = error {
                    print(error.localizedDescription)
                    self.sendOTPButton.setTitle("Try Again", for: .normal)
                    return
                }
                
                // verification ID
                self.currentVerificationId = verificationID!
                
                // Navigation for OTPViewController
                let storyboard = UIStoryboard(name: "OTPViewController", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                vc.currentVerificationId = self.currentVerificationId
                self.navigationController?.pushViewController(vc,animated: true)
            }
        }
    }
}
