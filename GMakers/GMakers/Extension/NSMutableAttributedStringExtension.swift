//
//  NSMutableAttributedStringExtension.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import UIKit

extension NSMutableAttributedString {
  
  class func create(text: String, keyWord: String, keyWordColor: UIColor) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: text)
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: keyWordColor,
                                  range: (text as NSString).range(of: keyWord))
    return attributedString
  }
}
