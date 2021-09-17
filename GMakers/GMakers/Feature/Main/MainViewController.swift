//
//  MainViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

import Alamofire

final class MainViewController: BaseViewController {
  
  // MARK: - Property
  
  private let naviView = UIView()
  private let logoLabel = UILabel()
  private let plusButton = UIButton()
  private let searchLabel = UILabel()
  private let searchImageView = UIImageView()
  private let myCardButton = UIButton()
  private let bookmarkButton = UIButton()
  private let indicatorView = UIView()
  private let scrollView = UIScrollView()
  private let cardCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()
  private let bookmarkLabel = UILabel()
  
  private var profiles = [ProfileCardModel]()
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("\n [ \(UserDefaultsManager.id!) ] ")
    print("\n [ \(UserDefaultsManager.token!) ] ")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.getProfile()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    self.view.endEditing(true)
  }
  
  
  
  // MARK: - Interface
  
  private func getProfile() {
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    AF.request(
      "http://52.79.197.237:8080/api/profiles",
      method: .get,
      headers: headers).response { [weak self] response in
        guard let self = self else { return }
        
        switch response.result {
        case .failure(let error):
          self.alertBase(title: "error get", message: error.localizedDescription, handler: nil)
          
        case .success(let data):
          guard
            let temp = data,
            let profileCard = try? JSONDecoder().decode([ProfileCardModel].self, from: temp)
          else { return }
          self.profiles = profileCard
          self.cardCollectionView.reloadData()
        }
       }
  }
  
  private func getProfileInfo(index: Int) {
    let id = self.profiles[index].profileID
    
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(UserDefaultsManager.token!)",
      "Content-Type": "application/json"
    ]
    
    self.presentIndicatorViewController()
    
    AF.request(
      "http://52.79.197.237:8080/api/profiles/\(id)",
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
            let profileInfo = try? JSONDecoder().decode(ProfileInfoModel.self, from: temp)
          else {
            self.alertBase(title: "error", message: nil, handler: nil)
            return
          }
          
          let vc = ProfileViewController(data: profileInfo)
          self.navigationController?.pushViewController(vc, animated: true)
        }
       }
  }
  
  
  
  // MARK: - Action
  
  @objc private func longPress(_ sender: UILongPressGestureRecognizer) {
    UserDefaultsManager.token = nil
    WindowManager.set(.splash)
  }
  
  @objc private func addDidTap(_ sender: UIButton) {
    self.view.endEditing(true)
    let vcAdd1Profile = ProfileAdd1ViewController()
    self.navigationController?.pushViewController(vcAdd1Profile, animated: true)
  }
  
  @objc private func buttonDidTap(_ sender: UIButton) {
    self.myCardButton.isSelected = self.myCardButton == sender
    self.bookmarkButton.isSelected = self.bookmarkButton == sender
    
    let indicatorOffset = self.myCardButton == sender ? 0 : 60
    let scrollViewOffset = self.myCardButton == sender ? 0 : self.view.frame.width
    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self = self else { return }
      
      self.indicatorView.snp.updateConstraints { make in
        make.leading.equalTo(self.myCardButton).offset(indicatorOffset)
      }
      
      let point = CGPoint(x: scrollViewOffset, y: 0)
      self.scrollView.setContentOffset(point, animated: true)
      
      self.view.layoutIfNeeded()
    }
  }
  
  @objc private func searchDidTap(_ sender: UITapGestureRecognizer) {
    let vc = SearchViewController()
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  
  
  // MARK: - UI
  
  override func setNavigation() {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func setAttribute() {
    self.logoLabel.text = "G-MAKERS"
    self.logoLabel.font = UIFont.Azonix.base(size: 16)
    self.logoLabel.textColor = UIColor.my6540E9
    self.logoLabel.isUserInteractionEnabled = true
    let longPress = UILongPressGestureRecognizer()
    longPress.addTarget(self, action: #selector(self.longPress(_:)))
    self.logoLabel.addGestureRecognizer(longPress)
    
    self.plusButton.setImage(UIImage(named: "main_add"), for: .normal)
    self.plusButton.addTarget(self, action: #selector(self.addDidTap(_:)), for: .touchUpInside)
    
    self.searchLabel.text = "      소환사검색"
    self.searchLabel.textColor = .myA9ACB3
    self.searchLabel.font = UIFont.NotoSansKR.medium(size: 12)
    self.searchLabel.backgroundColor = .myEAEDEF
    self.searchLabel.layer.cornerRadius = 4
    self.searchLabel.layer.masksToBounds = true
    self.searchLabel.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(self.searchDidTap(_:)))
    self.searchLabel.addGestureRecognizer(tap)
    
    self.searchImageView.image = UIImage(named: "main_search")
    
    self.myCardButton.setTitle("내 카드", for: .normal)
    self.myCardButton.isSelected = true
    
    self.bookmarkButton.setTitle("북마크", for: .normal)
    
    [self.myCardButton, self.bookmarkButton].forEach {
      $0.titleLabel?.font = UIFont.NotoSansKR.black(size: 16)
      $0.setTitleColor(.black, for: .selected)
      $0.setTitleColor(.lightGray, for: .normal)
      $0.addTarget(self, action: #selector(self.buttonDidTap(_:)), for: .touchUpInside)
    }
    
    self.indicatorView.backgroundColor = UIColor.my6540E9
    
//    self.scrollView.isScrollEnabled = false
    self.scrollView.isPagingEnabled = true
    self.scrollView.delegate = self
    
    self.cardCollectionView.backgroundColor = .white
    self.cardCollectionView.alwaysBounceVertical = true
    self.cardCollectionView.register(GCardCollectionViewCell.self, forCellWithReuseIdentifier: GCardCollectionViewCell.identifier)
    self.cardCollectionView.dataSource = self
    self.cardCollectionView.delegate = self
    
    self.bookmarkLabel.text = "준비 중입니다"
    self.bookmarkLabel.textAlignment = .center
    self.bookmarkLabel.font = UIFont.NotoSansKR.bold(size: 40)
  }
  
  override func setConstraint() {
    [self.naviView, self.searchLabel, self.searchImageView, self.myCardButton, self.bookmarkButton, self.indicatorView, self.scrollView].forEach {
      self.view.addSubview($0)
    }
    
    [self.cardCollectionView, self.bookmarkLabel].forEach {
      self.scrollView.addSubview($0)
    }
    
    self.naviView.snp.makeConstraints { make in
      make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
      make.height.equalTo(60)
    }
    
    [self.logoLabel, self.plusButton].forEach {
      self.naviView.addSubview($0)
    }
    
    self.logoLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalTo(20)
    }
    
    self.plusButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.trailing.equalTo(-20)
    }
    
    self.searchLabel.snp.makeConstraints { make in
      make.top.equalTo(self.naviView.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(20)
      make.height.equalTo(44)
    }
    
    self.searchImageView.snp.makeConstraints { make in
      make.centerY.equalTo(self.searchLabel)
      make.trailing.equalTo(self.searchLabel.snp.trailing).offset(-20)
    }
    
    self.myCardButton.snp.makeConstraints { make in
      make.top.equalTo(self.searchLabel.snp.bottom).offset(32)
      make.leading.equalTo(20)
      make.width.equalTo(60)
      make.height.equalTo(28)
    }
    
    self.bookmarkButton.snp.makeConstraints { make in
      make.top.equalTo(self.searchLabel.snp.bottom).offset(32)
      make.leading.equalTo(self.myCardButton.snp.trailing)
      make.width.equalTo(60)
      make.height.equalTo(28)
    }
    
    self.indicatorView.snp.makeConstraints { make in
      make.top.equalTo(self.myCardButton.snp.bottom)
      make.leading.equalTo(self.myCardButton.snp.leading)
      make.width.equalTo(60)
      make.height.equalTo(2)
    }
    
    self.scrollView.snp.makeConstraints { make in
      make.top.equalTo(self.indicatorView.snp.bottom).offset(8)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
    self.cardCollectionView.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.width.equalTo(self.view)
      make.height.equalToSuperview()
    }
    
    self.bookmarkLabel.snp.makeConstraints { make in
      make.top.trailing.bottom.equalToSuperview()
      make.leading.equalTo(self.cardCollectionView.snp.trailing)
      make.width.equalTo(self.view)
      make.height.equalToSuperview()
    }
  }
}


extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    self.profiles.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GCardCollectionViewCell.identifier, for: indexPath) as! GCardCollectionViewCell
    
    cell.bind(data: self.profiles[indexPath.row])
    
    return cell
  }
}



extension MainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.getProfileInfo(index: indexPath.row)
  }
}



extension MainViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    UIEdgeInsets(top: 8, left: 20, bottom: 24, right: 20)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    24
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



extension MainViewController: UIScrollViewDelegate {
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let isFirst = scrollView.contentOffset.x < 1
    
    self.myCardButton.isSelected = isFirst
    self.bookmarkButton.isSelected = !isFirst
    
    let indicatorOffset = isFirst ? 0 : 60
    UIView.animate(withDuration: 0.2) { [weak self] in
      guard let self = self else { return }
      
      self.indicatorView.snp.updateConstraints { make in
        make.leading.equalTo(self.myCardButton).offset(indicatorOffset)
      }
      
      self.view.layoutIfNeeded()
    }
  }
}
