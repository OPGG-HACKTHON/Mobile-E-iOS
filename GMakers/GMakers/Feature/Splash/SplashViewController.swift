//
//  SplashViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

final class SplashViewController: BaseViewController {
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
      switch UserDefaultsManager.token {
      case .some:
        WindowManager.set(.main)
        
      case .none:
        WindowManager.set(.login)
      }
    }
  }
  
  
  
  
  override func setAttribute() {
    self.imageView.image = UIImage(named: "Splash")
    self.imageView.contentMode = .scaleAspectFill
    
    self.titleLabel.text = "G-MAKERS"
    self.titleLabel.textColor = .white
    self.titleLabel.font = UIFont.Azonix.base(size: 40)
  }
  
  override func setConstraint() {
    [self.imageView, self.titleLabel].forEach {
      self.view.addSubview($0)
    }
    
    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}
