//
//  ChampionView.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

class ChampionView: UIView {
  
  let imageView = UIImageView()
  let removeButton = UIButton()

  
  // MARK: - Life Cycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.setAttribute()
    self.setConstraint()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setting(name: String) {
    self.imageView.image = UIImage(named: name)
    
    self.removeButton.isHidden = false
  }
  
  func remove() {
    self.imageView.image = nil
    self.removeButton.isHidden = true
  }
}



// MARK: - UI
extension ChampionView {
  
  private func setAttribute() {
    self.backgroundColor = UIColor.myE1E3E6
    
    self.imageView.contentMode = .scaleAspectFit
    
    self.removeButton.isHidden = true
    self.removeButton.setImage(UIImage(named: "remove"), for: .normal)
    self.removeButton.addTarget(self, action: #selector(self.removeDidTap(_:)), for: .touchUpInside)
  }
  
  private func setConstraint() {
    [self.imageView, self.removeButton].forEach {
      self.addSubview($0)
    }
    
    self.imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.removeButton.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview().inset(8)
    }
  }
  
  @objc private func removeDidTap(_ sender: UIButton) {
    self.remove()
  }
}
