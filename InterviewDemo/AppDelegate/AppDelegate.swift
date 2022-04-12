//
//  AppDelegate.swift
//  InterviewDemo
//
//  Created by Niraj Gambhava on 11/04/22.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // For Keybord Manager
        IQKeyboardManager.shared.enable = true
        
        FirebaseApp.configure()
        self.window!.makeKeyAndVisible()
        return true
    }
}
