//
//  FormViewController.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit
import iOSDropDown
import FirebaseDatabase
import FirebaseCore

class FormViewController: UIViewController {
    
    // MARK:- IBOutlet
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var selectBirthdateTextField: UITextField!
    @IBOutlet weak var pincodeTextField: UITextField!
    @IBOutlet weak var selectGenderTextField: DropDown!
    @IBOutlet weak var submitButton: UIButton!
    
    // MARK:- Variables
    let viewModel = FormModelView()
    var formData: FormDataModel?
    var userID: String?
    let ref = Database.database().reference(withPath: "UserFormData")
    var refObservers: [DatabaseHandle] = []
    private var datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.uiSetUp()
    }
}

// MARK: - Action Methods -
extension FormViewController {
    
    @IBAction func submitButtonClicked(_ sender: UIButton) {

        let formValidation =  viewModel.validateForm(strfirstName: firstNameTextfield.text ?? "", strlastName: lastNameTextField.text ?? "", strbirthDate: selectBirthdateTextField.text ?? "", strgender: selectGenderTextField.text ?? "", strpinCode: pincodeTextField.text ?? "")
        
        switch formValidation {
        case .firstNameFailure(let message), .lastNameFailure(let message), .birthDateFailure(let message), .genderFailure(let message), .pinCodeFailure(let message):
            self.showAlert(with: "Message", and: message)
        case .success:
            viewModel.getAddressAf(pinCode: self.pincodeTextField.text, completion: {
                responseAddress in
                if responseAddress.count == 0 {
                    print("No data")
                } else {
                    
                    print(responseAddress[0].latitude ?? "")
                    print(responseAddress[0].longitude ?? "")
                    let userInfoDictionary = ["firstname": self.firstNameTextfield.text ?? "",
                                              "lastname": self.lastNameTextField.text ?? "",
                                              "birthdate": self.selectBirthdateTextField.text ?? "",
                                              "gender": self.selectGenderTextField.text ?? "",
                                              "pincode": self.pincodeTextField.text ?? "",
                                              "latitude" :responseAddress[0].latitude ?? "",
                                              "longitude":responseAddress[0].longitude ?? "",
                                              "line_1":responseAddress[0].addresses?[0].line_1 ?? "",
                                              "town_or_city":responseAddress[0].addresses?[0].town_or_city ?? "",
                                              "district":responseAddress[0].addresses?[0].district ?? "",
                                              "country":responseAddress[0].addresses?[0].country ?? ""] as [String: Any]
                    
                    self.ref.child(self.userID ?? "123").setValue(userInfoDictionary)
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    for aViewController in viewControllers {
                        if aViewController is LoginViewController {
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        } else {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            })
        }
    }
}

// MARK: - Private Methods -
private extension FormViewController {
    
    func uiSetUp() {
        self.selectGenderTextField.optionArray = viewModel.setGender()
        self.showDatePicker()
        self.submitButton.layer.cornerRadius = 8
    }
    
    func showDatePicker(){
        //Formate Date
        self.datePicker.datePickerMode = .date
        if #available(iOS 15, *) {
            self.datePicker.maximumDate = .now
        } else {
            // Fallback on earlier versions
        }
        
        if #available(iOS 14.0, *) {
            self.datePicker.preferredDatePickerStyle = UIDatePickerStyle.inline
        }
        
        // ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        self.selectBirthdateTextField.inputAccessoryView = toolbar
        self.selectBirthdateTextField.inputView = datePicker
    }
    
    @objc func donedatePicker() {
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if selectBirthdateTextField.isEditing {
            self.selectBirthdateTextField.text = dateFormatter.string(from: self.datePicker.date)
        } else {}
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker() {
        self.view.endEditing(true)
    }
}
