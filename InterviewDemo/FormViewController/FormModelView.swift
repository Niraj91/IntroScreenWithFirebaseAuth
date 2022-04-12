//
//  FormModelView.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import Foundation
import UIKit
import iOSDropDown
import Alamofire

enum FormValidation {
    case firstNameFailure(message: String)
    case lastNameFailure(message: String)
    case birthDateFailure(message: String)
    case genderFailure(message: String)
    case pinCodeFailure(message: String)
    case success
}

protocol FormModel {
    func setGender() -> [String]
    func getAddressAf(pinCode: String?,completion: @escaping ([AddressResponse]) -> Void)
    func validateForm(strfirstName: String, strlastName: String, strbirthDate: String, strgender: String, strpinCode: String) -> FormValidation
}

class FormModelView: NSObject, FormModel {
    
    // MARK:- Variables
    weak var vc: FormViewController?
    var arrayAddress = [AddressResponse]()
    
    func validateForm(strfirstName: String, strlastName: String, strbirthDate: String, strgender: String, strpinCode: String) -> FormValidation {
        if strfirstName.isEmpty {
            return .firstNameFailure(message: "Please Enter firstName")
        } else if strlastName.isEmpty {
            return .lastNameFailure(message: "Please Enter lastName")
        } else if strbirthDate.isEmpty {
            return .birthDateFailure(message: "Please Select birthdate")
        } else if strgender.isEmpty {
            return .genderFailure(message: "Please Select gender")
        } else if strpinCode.isEmpty {
            return .pinCodeFailure(message: "Please Enter pincode")
        } else {
            return .success
        }
    }
    
    func setGender() -> [String]{
        let gender = ["Male","Female","Other"]
        return gender
    }
    
    func getAddressAf(pinCode: String?,completion: @escaping ([AddressResponse]) -> Void) {
        Alamofire.request("https://api.getAddress.io/find/\(pinCode ?? "")/10?api-key=ptPi36uWJkGiF1dgo7xJFQ34887&expand=true").response { response in
            
            if let data = response.data {
                do {
                    let Address = try JSONDecoder().decode(AddressResponse.self, from: data)
                    DispatchQueue.main.async {
                        print((Address))
                        self.arrayAddress.append(Address)
                        completion(self.arrayAddress)
                    }
                } catch {
                    print(error)
                    //completion(nil)
                }
            }
        }
    }
}
