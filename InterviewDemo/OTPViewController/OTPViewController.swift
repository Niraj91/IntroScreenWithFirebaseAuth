//
//  OTPViewController.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit
import FirebaseAuth

class OTPViewController: UIViewController {

    // MARK:- IBOutlet
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK:- Variables
    var currentVerificationId: String?
    let viewModel = OTPModelView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 8
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        
        let OTPValidation =  viewModel.validateOTP(strOTP: otpTextField.text ?? "")
        switch OTPValidation {
        case .OTPFailure(let message):
            self.showAlert(with: "Message", and: message)
        case .success:
            guard let verificationCode = otpTextField.text else { return }
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: self.currentVerificationId ?? "", verificationCode: verificationCode)
            
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    let authError = error as NSError
                    print(authError.description)
                    return
                }
                
                // User has signed in successfully and currentUser object is valid
                let currentUserInstance = Auth.auth().currentUser
                
                // Navigation for FormViewController
                let userID = currentUserInstance?.uid
                let storyboard = UIStoryboard(name: "FormViewController", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "FormViewController") as! FormViewController
                vc.userID = userID
                self.navigationController?.pushViewController(vc,animated: true)
            }
        }
    }
}
