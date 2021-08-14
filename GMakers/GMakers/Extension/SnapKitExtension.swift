//
//  SnapKitExtension.swift
//  GMakers
//
//  Created by Lee on 2021/08/14.
//

import SnapKit

extension UIView {
  
    var safeArea : ConstraintLayoutGuideDSL {
        return safeAreaLayoutGuide.snp
    }
}
