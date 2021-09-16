//
//  IndicatorViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/14.
//

import UIKit

final class IndicatorViewController: UIViewController {
  
  private let indicatorView = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setAttribute()
    self.setConstraint()
  }
}



// MARK: - UI

extension IndicatorViewController {
  private func setAttribute() {
    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    
    self.indicatorView.startAnimating()
    self.indicatorView.style = UIActivityIndicatorView.Style.large
    self.indicatorView.color = .white
  }
  
  private func setConstraint() {
    let guide = self.view.safeAreaLayoutGuide
    
    view.addSubview(self.indicatorView)
    self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      self.indicatorView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      self.indicatorView.centerYAnchor.constraint(equalTo: guide.centerYAnchor)
    ])
  }
}
