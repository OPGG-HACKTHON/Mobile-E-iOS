//
//  ProfileAdd3ViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/06.
//

import UIKit

import Alamofire

final class ProfileAdd3ViewController: ProfileBaseViewController {
  
  private let titleLabel = UILabel()
  private let cardCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let buttonStackView = UIStackView()
  private let endButton = UIButton()
  private let verifyButton = UIButton()
  
  var profileCard: ProfileCardModel?
  
  
  
  
  // MARK: - Action
  
  @objc private func endDidTap(_ sender: UIButton) {
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  @objc private func verifyDidTap(_ sender: UIButton) {
    let vc = ProfileVerify1ViewController()
    vc.profileCard = self.profileCard
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    super.setAttribute()
    
    self.backButton.isHidden = true
    
    self.progressbar.progress = 1
    
    self.titleLabel.numberOfLines = 2
    self.titleLabel.text = "3. 프로필 생성이 완료되었습니다!\n계정 인증을 인증하고 커스터마이징 해보세요!"
    self.titleLabel.textColor = .my878991
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 14)
    
    self.cardCollectionView.backgroundColor = .white
    self.cardCollectionView.register(GCardCollectionViewCell.self, forCellWithReuseIdentifier: GCardCollectionViewCell.identifier)
    self.cardCollectionView.dataSource = self
    self.cardCollectionView.delegate = self
    
    self.buttonStackView.alignment = .fill
    self.buttonStackView.axis = .horizontal
    self.buttonStackView.distribution = .fillEqually
    self.buttonStackView.spacing = 13
    
    self.endButton.backgroundColor = .white
    self.endButton.layer.borderWidth = 1
    self.endButton.layer.borderColor = UIColor.my4D4E56.cgColor
    self.endButton.setTitle("다음에 하기", for: .normal)
    self.endButton.setTitleColor(.my4D4E56, for: .normal)
    self.endButton.addTarget(self, action: #selector(self.endDidTap(_:)), for: .touchUpInside)
    
    self.verifyButton.backgroundColor = .my6540E9
    self.verifyButton.setTitle("계정 인증하기", for: .normal)
    self.verifyButton.setTitleColor(.white, for: .normal)
    self.verifyButton.addTarget(self, action: #selector(self.verifyDidTap(_:)), for: .touchUpInside)
    
    [self.endButton, self.verifyButton].forEach {
      $0.layer.cornerRadius = 4
      $0.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
      self.buttonStackView.addArrangedSubview($0)
    }
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    [self.titleLabel, self.cardCollectionView, self.buttonStackView].forEach {
      self.view.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.progressbar).offset(48)
      make.leading.equalTo(20)
    }
    
    self.cardCollectionView.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom)
      make.leading.trailing.equalToSuperview()
    }
    
    self.buttonStackView.snp.makeConstraints { make in
      make.top.equalTo(self.cardCollectionView.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(24)
      make.height.equalTo(54)
    }
  }
  
}



extension ProfileAdd3ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.profileCard == nil ? 0 : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GCardCollectionViewCell.identifier, for: indexPath) as! GCardCollectionViewCell
    
    cell.bind(data: self.profileCard!)
    
    return cell
  }
}



extension ProfileAdd3ViewController: UICollectionViewDelegateFlowLayout {
  
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
