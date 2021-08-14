//
//  UserDefaultsManager.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import Foundation

class UserDefaultsManager {
  
  static var token: String? {
    get { UserDefaults.standard.string(forKey: "token") }
    set { UserDefaults.standard.setValue(newValue, forKey: "token") }
  }
}
