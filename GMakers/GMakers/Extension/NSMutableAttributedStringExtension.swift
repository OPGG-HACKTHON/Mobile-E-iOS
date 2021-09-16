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
//    let font = UIFont.NotoSansKR.medium(size: 12)
//    attributedString.addAttribute(NSAttributedString.Key.font, value: font, range: (text as NSString).range(of: keyWord))
    attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                  value: keyWordColor,
                                  range: (text as NSString).range(of: keyWord))
    return attributedString
  }
}
