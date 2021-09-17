//
//  ProfileViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import UIKit
import Alamofire

final class ProfileViewController: BaseViewController {
  
  private let backImageView = UIImageView()
  private let naviView = UIView()
  private let backButton = UIButton()
  private let trashButton = UIButton()
  private let scrollView = UIScrollView()
  private let verifyButton = UIButton()
  private let cardCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let nameLabel = UILabel()
  private let tierImageView = UIImageView()
  private let tierLabel = UILabel()
  private let subLabel = UILabel()
  private let lineImageView1 = UIImageView()
  private let lineImageView2 = UIImageView()
  private let descriptionLabel = UILabel()
  private let keywordView = UIView()
  private let lineView = UIView()
  private let preferChampionLabel = UILabel()
  private let preferChampionCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  
  private let profileInfo: ProfileInfoModel
  
  
  init(data: ProfileInfoModel) {
    self.profileInfo = data
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Interface
  
  private func deleteProfile() {
    let id = self.profileInfo.profileID
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    self.presentIndicatorViewController()
    
    AF.request(
      "http://52.79.197.237:8080/api/profiles/\(id)",
      method: .delete,
      parameters: nil,
      headers: headers).response { [weak self] response in
        guard let self = self else { return }
        
        self.dismissIndicatorViewController()
        
        switch response.result {
        case .failure(let error):
          self.alertBase(title: "error delete", message: error.localizedDescription, handler: nil)
          
        case .success:
          self.navigationController?.popViewController(animated: true)
        }
       }
  }
  
  
  
  
  // MARK: - Action
  
  @objc private func backDidTap(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc private func trashDidTap(_ sender: UIButton) {
    self.deleteProfile()
  }
  
  @objc private func verifyDidTap(_ sender: UIButton) {
    let vc = ProfileVerify1ViewController()
    let profileCard = ProfileCardModel(accountID: self.profileInfo.accountID,
                                       username: self.profileInfo.username,
                                       profileID: self.profileInfo.profileID,
                                       summonerAccountID: self.profileInfo.summonerAccountID,
                                       profileIconID: self.profileInfo.profileIconID,
                                       summonerID: self.profileInfo.summonerID,
                                       summonerName: self.profileInfo.summonerName,
                                       preferQueue: self.profileInfo.preferQueue,
                                       level: self.profileInfo.level,
                                       queue: self.profileInfo.queue,
                                       tier: self.profileInfo.tier,
                                       tierLevel: self.profileInfo.tierLevel,
                                       preferLines: self.profileInfo.preferLines,
                                       certified: self.profileInfo.certified)
    vc.profileCard = profileCard
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    let imageName = self.profileInfo.certified ? "background_purple" : "background_dark"
    self.backImageView.image = UIImage(named: imageName)
    
    self.backButton.setImage(UIImage(named: "back_white"), for: .normal)
    self.backButton.addTarget(self, action: #selector(self.backDidTap(_:)), for: .touchUpInside)
    
    let tempImage = UIImage(systemName: "trash")
    let tempColorImage = tempImage?.withTintColor(.white, renderingMode: .alwaysOriginal)
    self.trashButton.setImage(tempColorImage, for: .normal)
    self.trashButton.addTarget(self, action: #selector(self.trashDidTap(_:)), for: .touchUpInside)
    
    self.verifyButton.isHidden = self.profileInfo.certified
    self.verifyButton.backgroundColor = .my6540E9
    self.verifyButton.setTitle("계정 인증하기", for: .normal)
    self.verifyButton.setTitleColor(.white, for: .normal)
    self.verifyButton.titleLabel?.font = UIFont.NotoSansKR.black(size: 14)
    self.verifyButton.layer.cornerRadius = 4
    self.verifyButton.addTarget(self, action: #selector(self.verifyDidTap(_:)), for: .touchUpInside)
    
    self.cardCollectionView.backgroundColor = .clear
    self.cardCollectionView.register(GCardCollectionViewCell.self, forCellWithReuseIdentifier: GCardCollectionViewCell.identifier)
    self.cardCollectionView.dataSource = self
    self.cardCollectionView.delegate = self
    
    self.nameLabel.text = self.profileInfo.summonerName
    self.nameLabel.textColor = .white
    self.nameLabel.font = UIFont.NotoSansKR.bold(size: 32)
    
    self.tierImageView.image = UIImage(named: self.profileInfo.timerImageName)
    self.tierImageView.contentMode = .scaleAspectFit
    
    self.tierLabel.text = self.profileInfo.tier
    self.tierLabel.textColor = .white
    self.tierLabel.font = UIFont.Azonix.base(size: 20)
    
    let text = "\(self.profileInfo.winGames)승 \(self.profileInfo.loseGames)패 (\(self.profileInfo.winRate)%)"
    self.subLabel.text = text
    self.subLabel.textColor = .white
    self.subLabel.font = UIFont.NotoSansKR.medium(size: 14)
    
    self.lineImageView1.image = UIImage(named: self.profileInfo.preferLineImageNames[0])
    self.lineImageView1.contentMode = .scaleAspectFit
    
    self.lineImageView2.image = UIImage(named: self.profileInfo.preferLineImageNames[1])
    self.lineImageView2.contentMode = .scaleAspectFit
    
    self.descriptionLabel.text = self.profileInfo.description
    self.descriptionLabel.textColor = .white
    self.descriptionLabel.font = UIFont.NotoSansKR.medium(size: 14)
    self.descriptionLabel.numberOfLines = 0
    
    var xPoint: CGFloat = 0
    self.profileInfo.preferKeywords.forEach { keyword in
      let label = UILabel()
      label.text = "      " + keyword + "      "
      label.font = UIFont.NotoSansKR.medium(size: 12)
      label.sizeToFit()
      let size = label.frame
      label.frame = CGRect(x: xPoint,
                           y: 0,
                           width: size.width,
                           height: 32)
      xPoint += (size.width + 8)
      label.textColor = .white
      label.backgroundColor = .clear
      label.layer.cornerRadius = 16
      label.layer.borderWidth = 1
      label.layer.borderColor = UIColor.white.cgColor
      self.keywordView.addSubview(label)
    }
    
    self.lineView.backgroundColor = .myA9ACB3
    
    self.preferChampionLabel.text = "선호 챔피언"
    self.preferChampionLabel.textColor = .white
    self.preferChampionLabel.font = UIFont.NotoSansKR.bold(size: 24)
    
    self.preferChampionCollectionView.backgroundColor = .clear
    self.preferChampionCollectionView.register(ChampionMasteryCollectionViewCell.self, forCellWithReuseIdentifier: ChampionMasteryCollectionViewCell.identifier)
    self.preferChampionCollectionView.dataSource = self
    self.preferChampionCollectionView.delegate = self
  }
  
  override func setConstraint() {
    [self.backImageView, self.naviView, self.scrollView, self.verifyButton].forEach {
      self.view.addSubview($0)
    }
    
    [self.backButton, self.trashButton].forEach {
      self.naviView.addSubview($0)
    }
    
    [self.cardCollectionView, self.nameLabel, self.tierImageView, self.tierLabel, self.subLabel, self.lineImageView1, self.lineImageView2, self.descriptionLabel, self.keywordView, self.lineView, self.preferChampionLabel, self.preferChampionCollectionView].forEach {
      self.scrollView.addSubview($0)
    }
    
    self.backImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    
    self.naviView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    self.backButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(20)
    }
    
    self.trashButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(-20)
    }
    
    self.scrollView.snp.makeConstraints { make in
      make.top.equalTo(self.naviView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    self.verifyButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).inset(16)
      make.height.equalTo(54)
    }
    
    self.cardCollectionView.snp.makeConstraints { make in
      make.top.equalTo(8)
      make.leading.trailing.equalToSuperview()
      make.width.equalTo(self.view)
      make.height.equalTo(230)
    }
    
    self.nameLabel.snp.makeConstraints { make in
      make.top.equalTo(self.cardCollectionView.snp.bottom).offset(16)
      make.leading.equalTo(20)
    }
    
    self.tierImageView.snp.makeConstraints { make in
      make.top.equalTo(self.nameLabel.snp.bottom).offset(16)
      make.leading.equalTo(20)
      make.width.equalTo(104)
      make.height.equalTo(114)
    }
    
    self.tierLabel.snp.makeConstraints { make in
      make.top.equalTo(self.tierImageView).offset(16)
      make.leading.equalTo(self.tierImageView.snp.trailing).offset(12)
    }
    
    self.subLabel.snp.makeConstraints { make in
      make.top.equalTo(self.tierLabel.snp.bottom).offset(2)
      make.leading.equalTo(self.tierImageView.snp.trailing).offset(12)
    }
    
    self.lineImageView1.snp.makeConstraints { make in
      make.top.equalTo(self.subLabel.snp.bottom).offset(12)
      make.leading.equalTo(self.tierImageView.snp.trailing).offset(12)
      make.width.height.equalTo(36)
    }
    
    self.lineImageView2.snp.makeConstraints { make in
      make.top.equalTo(self.subLabel.snp.bottom).offset(12)
      make.leading.equalTo(self.lineImageView1.snp.trailing).offset(8)
      make.width.height.equalTo(36)
    }
    
    self.descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(self.tierImageView.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    self.keywordView.snp.makeConstraints { make in
      make.top.equalTo(self.descriptionLabel.snp.bottom).offset(8)
      make.leading.equalTo(24)
      make.height.equalTo(32)
    }
    
    self.lineView.snp.makeConstraints { make in
      make.top.equalTo(self.keywordView.snp.bottom).offset(36)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(2)
    }
    
    self.preferChampionLabel.snp.makeConstraints { make in
      make.top.equalTo(self.lineView.snp.bottom).offset(32)
      make.leading.equalTo(20)
    }
    
    let bottomInset = self.profileInfo.certified ? 8 : 64
    self.preferChampionCollectionView.snp.makeConstraints { make in
      make.top.equalTo(self.preferChampionLabel.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(bottomInset)
      make.height.equalTo(240)
    }
  }
}



extension ProfileViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collectionView == self.cardCollectionView ? 1 : 3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch collectionView {
    case self.cardCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GCardCollectionViewCell.identifier, for: indexPath) as! GCardCollectionViewCell
      
      cell.bind(data: self.profileInfo)
      
      return cell
      
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChampionMasteryCollectionViewCell.identifier, for: indexPath) as! ChampionMasteryCollectionViewCell
      
      cell.bind(data: self.profileInfo.preferChampions[indexPath.row])
      
      return cell
    }
  }
}



extension ProfileViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    switch collectionView {
    case self.cardCollectionView:
      return 0
      
    default:
      return 20
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return .zero
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case self.cardCollectionView:
      let width = collectionView.frame.width - 40
      let height = width * 206 / 335
      return CGSize(width: width, height: height)
      
    default:
      let width = (collectionView.frame.width - (20 * 2) - (20 * 2)) / 3
      let height: CGFloat = 240
      return CGSize(width: width, height: height)
    }
  }
}
