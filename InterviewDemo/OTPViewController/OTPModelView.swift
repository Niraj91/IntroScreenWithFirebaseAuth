//
//  OTPModelView.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import Foundation

enum OTPValidation {
    case OTPFailure(message: String)
    case success
}

protocol OTPModel {
    func validateOTP(strOTP: String) -> OTPValidation
}

class OTPModelView : NSObject,OTPModel {
    
    func validateOTP(strOTP: String) -> OTPValidation {
        if strOTP.isEmpty {
            return .OTPFailure(message: "Please enter OTP")
        } else {
            return .success
        }
    }
}
