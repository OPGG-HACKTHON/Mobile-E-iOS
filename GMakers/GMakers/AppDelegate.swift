//
//  AppDelegate.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window?.rootViewController = SplashViewController()
    self.window?.makeKeyAndVisible()
    
    return true
  }
  
}

