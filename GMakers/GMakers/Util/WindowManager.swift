//
//  WindowManager.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import UIKit

final class WindowManager {
  
  enum VisibleViewControllerType {
    case splash
    case login
    case main
    
    var controller: UIViewController {
      switch self {
      case .splash:   return SplashViewController()
      case .login:   return UINavigationController(rootViewController: LoginViewController())
      case .main:    return UINavigationController(rootViewController: MainViewController())
      }
    }
  }
  
  class func set(_ type: VisibleViewControllerType) {
    guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.backgroundColor = .systemBackground
    window.rootViewController = type.controller
    window.makeKeyAndVisible()
    
    delegate.window = window
  }
}
