//
//  UIViewController+Extensions.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit

extension UIViewController {
    
    func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
