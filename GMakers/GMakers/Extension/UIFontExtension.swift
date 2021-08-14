//
//  UIFontExtension.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import UIKit

extension UIFont {
  
  // MARK: - NotoSansKR
  
  class NotoSansKR {
    
    class func black(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Black", size: size)!
    }
    
    class func bold(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Bold", size: size)!
    }
    
    class func light(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Light", size: size)!
    }
    
    class func medium(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Medium", size: size)!
    }
    
    class func regular(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Regular", size: size)!
    }
    
    class func thin(size: CGFloat) -> UIFont {
      UIFont(name: "NotoSansKR-Thin", size: size)!
    }
  }
  
  
  
  // MARK: - Azonix
  
  class Azonix {
    
    class func base(size: CGFloat) -> UIFont {
      UIFont(name: "azonix", size: size)!
    }
  }
  
  
}
