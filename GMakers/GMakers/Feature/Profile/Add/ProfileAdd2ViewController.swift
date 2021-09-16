//
//  ProfileAdd2ViewController.swift
//  GMakers
//
//  Created by Lee on 2021/09/06.
//

import UIKit

import Alamofire

final class ProfileAdd2ViewController: ProfileBaseViewController {
  
  private let titleLabel = UILabel()
  private let championStackView = UIStackView()
  private let champion1 = ChampionView()
  private let champion2 = ChampionView()
  private let champion3 = ChampionView()
  private let intialCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let listCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let nextButton = UIButton()
  
  private let intial = ["ㄱ", "ㄴ", "ㄷ", "ㄹ", "ㅁ", "ㅂ", "ㅅ", "ㅇ", "ㅈ", "ㅊ", "ㅋ", "ㅌ", "ㅎ"]
  private var championList = ChampionManager.allData
  private var preferChampion = [ChampionManager.Champion]() {
    didSet {
      let views = [self.champion1, self.champion2, self.champion3]
      views.forEach {
        $0.remove()
      }
      
      self.preferChampion.enumerated().forEach {
        views[$0].setting(name: $1.en)
      }
    }
  }
  
  var data = [String]()
  var keyword = [String]()
  var preferLines = [AddPreferLine]()
  var preferChampions = [PreferChampion]()
  
  
  
  // MARK: - Action
  
  @objc private func removeDidTap(_ sender: UIButton) {
    self.preferChampion.remove(at: sender.tag)
  }
  
  @objc private func nextDidTap(_ sender: UIButton) {
    guard self.preferChampion.count == 3 else {
      self.alertBase(title: "선호하는 챔피언을 3개 선택해 주세요", message: nil, handler: nil)
      return
    }
    
    self.preferChampions = self.preferChampion.enumerated().map {
      PreferChampion(priority: $0, championID: $1.tag, nullable: false)
    }
    
    self.createProfile()
  }
  
  private func createProfile() {
    let data = ProfileAddModel(
      summonerName: self.data[0],
      welcomeDescription: self.data[1],
      preferKeywords: self.keyword,
      preferChampions: self.preferChampions,
      preferLines: self.preferLines,
      preferQueue: self.data[2]
    )
    
    guard
      let data = try? JSONEncoder().encode(data),
      let params = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    else { return }
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    self.presentIndicatorViewController()
    
    AF.request("http://52.79.197.237:8080/api/profiles",
               method: .post,
               parameters: params,
               encoding: JSONEncoding.default,
               headers: headers).response { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .failure(let error):
                  self.dismissIndicatorViewController()
                  self.alertBase(title: "error 01", message: error.localizedDescription, handler: nil)
                  
                case .success(let data):
                  guard
                    let temp = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: String],
                    let message = temp["message"]
                  else {
                    self.getProfile()
                    return
                  }
                  self.dismissIndicatorViewController()
                  self.alertBase(title: message, message: nil, handler: nil)
                }
               }
  }
  
  private func getProfile() {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    AF.request("http://52.79.197.237:8080/api/profiles",
               method: .get,
               headers: headers).response { [weak self] response in
                guard let self = self else { return }
                
                self.dismissIndicatorViewController()
                
                switch response.result {
                case .failure(let error):
                  self.alertBase(title: "error", message: error.localizedDescription, handler: nil)
                  
                case .success(let data):
                  guard
                    let temp = data,
                    let profileCards = try? JSONDecoder().decode([ProfileCardModel].self, from: temp)
                  else { return }
                  
                  let card = profileCards
                    .filter { $0.summonerName.lowercased() == self.data[0].lowercased() }
                    .first!
                  
                  let profileCard = ProfileCardModel(accountID: card.accountID,
                                                     username: card.username,
                                                     profileID: card.profileID,
                                                     summonerAccountID: card.summonerAccountID,
                                                     profileIconID: card.profileIconID,
                                                     summonerID: card.summonerID,
                                                     summonerName: card.summonerName,
                                                     preferQueue: card.preferQueue,
                                                     level: card.level,
                                                     queue: card.queue,
                                                     tier: card.tier,
                                                     tierLevel: card.tierLevel,
                                                     preferLines: card.preferLines,
                                                     certified: card.certified)
                  
                  let vc = ProfileAdd3ViewController()
                  vc.profileCard = profileCard
                  self.navigationController?.pushViewController(vc, animated: true)
                }
               }
  }
  
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    super.setAttribute()
    
    self.progressbar.progress = 2 / 3
    
    self.titleLabel.text = "2. 선호하는 챔피언을 선택해 주세요."
    self.titleLabel.textColor = .my878991
    self.titleLabel.font = UIFont.NotoSansKR.bold(size: 14)
    
    self.championStackView.alignment = .fill
    self.championStackView.axis = .horizontal
    self.championStackView.distribution = .fillEqually
    self.championStackView.spacing = 12
    
    self.intialCollectionView.register(IntialCollectionViewCell.self, forCellWithReuseIdentifier: IntialCollectionViewCell.identifier)
    self.listCollectionView.register(ChampionCollectionViewCell.self, forCellWithReuseIdentifier: ChampionCollectionViewCell.identifier)
    
    [self.intialCollectionView, self.listCollectionView].forEach {
      $0.backgroundColor = .white
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.dataSource = self
      $0.delegate = self
    }
    
    self.nextButton.backgroundColor = .my6540E9
    self.nextButton.setTitle("다음", for: .normal)
    self.nextButton.setTitleColor(.white, for: .normal)
    self.nextButton.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
    self.nextButton.layer.cornerRadius = 4
    self.nextButton.layer.masksToBounds = true
    self.nextButton.addTarget(self, action: #selector(self.nextDidTap(_:)), for: .touchUpInside)
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    [self.champion1, self.champion2, self.champion3].enumerated().forEach {
      self.championStackView.addArrangedSubview($1)
      $1.tag = $0
      $1.removeButton.addTarget(self, action: #selector(self.removeDidTap(_:)), for: .touchUpInside)
    }
    
    [self.titleLabel, self.championStackView, self.intialCollectionView, self.listCollectionView, self.nextButton].forEach {
      self.scrollView.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.leading.equalTo(20)
    }
    
    self.championStackView.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
      make.width.equalTo(self.view.frame.width - 40)
      make.height.equalTo((self.view.frame.width - 40 - 24) / 3)
    }
    
    self.intialCollectionView.snp.makeConstraints { make in
      make.top.equalTo(self.championStackView.snp.bottom).offset(48)
      make.leading.trailing.equalToSuperview()
      make.width.equalTo(self.view.frame.width)
      make.height.equalTo(36)
    }
    
    self.listCollectionView.snp.makeConstraints { make in
      make.top.equalTo(self.intialCollectionView.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview()
      make.width.equalTo(self.view.frame.width)
      make.height.equalTo(280)
    }
    
    self.nextButton.snp.makeConstraints { make in
      make.top.equalTo(self.listCollectionView.snp.bottom).offset(12)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(24)
      make.width.equalTo(self.view.frame.width - 40)
      make.height.equalTo(54)
    }
  }
  
}




extension ProfileAdd2ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case self.intialCollectionView:
      return self.intial.count
      
    default:
      return self.championList.count
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    switch collectionView {
    case self.intialCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntialCollectionViewCell.identifier, for: indexPath) as! IntialCollectionViewCell
      
      cell.titleLabel.text = self.intial[indexPath.row]
      
      return cell
      
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChampionCollectionViewCell.identifier, for: indexPath) as! ChampionCollectionViewCell
      
      let imageName = self.championList[indexPath.row].en
      cell.imageView.image = UIImage(named: imageName)
      
      return cell
    }
  }
}



extension ProfileAdd2ViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    case self.intialCollectionView:
      let intial = self.intial[indexPath.row]
      self.championList = ChampionManager.allData.filter { $0.intial == intial }
      self.listCollectionView.reloadData()
      
    default:
      let champion = self.championList[indexPath.row]
      guard !self.preferChampion.contains(where: { $0.en == champion.en}), self.preferChampion.count < 3 else { return }
      self.preferChampion.append(champion)
    }
  }
}



extension ProfileAdd2ViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    switch collectionView {
    case self.intialCollectionView:
      return UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
      
    default:
      return UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    switch collectionView {
    case self.intialCollectionView:
      return 8
      
    default:
      return 12
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    switch collectionView {
    case self.intialCollectionView:
      return 0
      
    default:
      return 12
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case self.intialCollectionView:
      return CGSize(width: 47, height: 36)
      
    default:
      let size = (collectionView.frame.width - (20 * 2) - (12 * 5)) / 6
      return CGSize(width: size, height: size)
    }
  }
}
