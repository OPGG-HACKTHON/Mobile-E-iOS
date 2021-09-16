//
//  UserDefaultsManager.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import Foundation

class UserDefaultsManager {
  
  static var id: String? {
    get { UserDefaults.standard.string(forKey: "id") }
    set { UserDefaults.standard.setValue(newValue, forKey: "id") }
  }
  
  static var password: String? {
    get { UserDefaults.standard.string(forKey: "password") }
    set { UserDefaults.standard.setValue(newValue, forKey: "password") }
  }
  
  static var token: String? {
    get { UserDefaults.standard.string(forKey: "token") }
    set { UserDefaults.standard.setValue(newValue, forKey: "token") }
  }
  
  static var tokenTime: Int? {
    get {
      let date = UserDefaults.standard.integer(forKey: "tokenTime")
      return date == 0 ? nil : date
    }
    set { UserDefaults.standard.setValue(newValue, forKey: "tokenTime") }
  }
}
