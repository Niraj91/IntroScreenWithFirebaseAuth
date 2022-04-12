//
//  LoginViewModel.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import Foundation

enum LoginValidation {
    case mobileNumberFailure(message: String)
    case success
}

protocol LoginModel {
    func validateLogin(strmobileNumber: String) -> LoginValidation
}

class LoginModelView : NSObject,LoginModel {
    
    func validateLogin(strmobileNumber: String) -> LoginValidation {
        
        if strmobileNumber.isEmpty {
            return .mobileNumberFailure(message: "Please enter mobile number")
        } else {
            return .success
        }
    }
}
