//
//  ProfileVerify2ViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit

final class ProfileVerify2ViewController: ProfileBaseViewController {
  
  private let dismissButton = UIButton()
  private let titleLabel = UILabel()
  private let cardCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let endButton = UIButton()
  
  var preferLines = [AddPreferLine]()
  var data: ProfileVerifyModel?
  
  var profileCard: ProfileCardModel?
  
  
  
  // MARK: - Action
  
  @objc private func dismissDidTap(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    super.setAttribute()
    
    self.backButton.isHidden = true
    
    self.dismissButton.setImage(UIImage(named: "dismiss_black"), for: .normal)
    self.dismissButton.addTarget(self, action: #selector(self.dismissDidTap(_:)), for: .touchUpInside)
    
    self.naviLabel.text = "계정 인증"
    
    self.progressbar.progress = 1
    
    self.titleLabel.numberOfLines = 2
    self.titleLabel.text = "2. 계정 인증이 완료되었습니다\n이제 나만의 프로필을 만들어 보세요!"
    self.titleLabel.textColor = .my878991
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 14)
    
    self.cardCollectionView.backgroundColor = .white
    self.cardCollectionView.register(GCardCollectionViewCell.self, forCellWithReuseIdentifier: GCardCollectionViewCell.identifier)
    self.cardCollectionView.dataSource = self
    self.cardCollectionView.delegate = self
    
    self.endButton.layer.cornerRadius = 4
    self.endButton.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
    self.endButton.backgroundColor = .my6540E9
    self.endButton.setTitle("완료", for: .normal)
    self.endButton.setTitleColor(.white, for: .normal)
    self.endButton.addTarget(self, action: #selector(self.dismissDidTap(_:)), for: .touchUpInside)
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    [self.dismissButton, self.titleLabel, self.cardCollectionView, self.endButton].forEach {
      self.view.addSubview($0)
    }
    
    self.dismissButton.snp.makeConstraints { make in
      make.top.equalTo(self.view.safeAreaLayoutGuide).offset(18)
      make.trailing.equalToSuperview().inset(20)
      make.width.height.equalTo(24)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.progressbar).offset(48)
      make.leading.equalTo(20)
    }
    
    self.cardCollectionView.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom)
      make.leading.trailing.equalToSuperview()
    }
    
    self.endButton.snp.makeConstraints { make in
      make.top.equalTo(self.cardCollectionView.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
      make.height.equalTo(54)
    }
  }
}



extension ProfileVerify2ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.data == nil ? 0 : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GCardCollectionViewCell.identifier, for: indexPath) as! GCardCollectionViewCell
    
    cell.bind(data: self.data!, line: self.preferLines, isVerify: true)
    
    return cell
  }
}



extension ProfileVerify2ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 24, left: 20, bottom: 24, right: 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.frame.width - 40
    let height = width * 206 / 335
    return CGSize(width: width, height: height)
  }
}
