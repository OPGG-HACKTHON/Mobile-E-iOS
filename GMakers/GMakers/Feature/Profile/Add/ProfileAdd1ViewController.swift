//
//  ProfileAdd1ViewController.swift
//  GMakers
//
//  Created by Lee on 2021/08/06.
//

import UIKit

final class ProfileAdd1ViewController: ProfileBaseViewController {
  
  enum PickerType {
    case position1
    case position2
    case rank
  }
  
  private let titleLabel = UILabel()
  private let nameTextField = MyTextField()
  private let descriptionTextField = MyTextField()
  
  private let styleLabel = UILabel()
  private let styleSubLabel = UILabel()
  private var keywordButtons = [UIButton]()
  
  private let positionLabel = UILabel()
  private let position1Label = UILabel()
  private let position1Select = SelectView()
  private let position2Label = UILabel()
  private let position2Select = SelectView()
  
  private let rankLabel = UILabel()
  private let rankSelect = SelectView()
  
  private let nextButton = UIButton()
  
  private var pickerType = PickerType.position1
  private let positions = ["탑", "정글", "미드", "원딜", "서폿"]
  private let ranks = ["솔로랭크", "자유랭크", "선택안함"]
  private var pickerList = [String]()
  private var pick = String()
  private var position1 = String() {
    didSet {
      self.position1Select.titleLabel.text = self.position1
    }
  }
  private var position2 = String() {
    didSet {
      self.position2Select.titleLabel.text = self.position2
    }
  }
  private var rank = "솔로랭크" {
    didSet {
      self.rankSelect.titleLabel.text = self.rank
    }
  }
  
  private var styleButtons = [UIButton]() {
    didSet{
      self.styleSubLabel.text = "(\(self.styleButtons.count) / 3)"
    }
  }
  
  
  
  // MARK: - Action
  
  @objc private func styleDidTap(_ sender: UIButton) {
    self.view.endEditing(true)
    
    switch self.styleButtons.contains(sender) {
    case true:
      let index = self.styleButtons.firstIndex(of: sender)
      self.styleButtons.remove(at: index!)
      
      sender.setTitleColor(.my2A292B, for: .normal)
      sender.layer.borderColor = UIColor.myA9ACB3.cgColor
      
    case false:
      guard self.styleButtons.count < 3 else { return }
      self.styleButtons.append(sender)
      
      sender.setTitleColor(.my6540E9, for: .normal)
      sender.layer.borderColor = UIColor.my6540E9.cgColor
    }
  }
  
  @objc private func selectDidTap(_ sender: UITapGestureRecognizer) {
    self.view.endEditing(true)
    
    switch sender.name! {
    case "tap1":
      self.pickerType = .position1
      self.pickerList = self.positions
      self.pick = self.positions[0]
      
    case "tap2":
      self.pickerType = .position2
      self.pickerList = self.positions
      self.pick = self.positions[0]
      
    case "tap3":
      self.pickerType = .rank
      self.pickerList = self.ranks
      self.pick = self.ranks[0]
      
    default:
      return
    }
    
    let alert = UIAlertController(title: nil, message: "\n\n\n\n\n\n", preferredStyle: .alert)
    let picker = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
    alert.view.addSubview(picker)
    picker.delegate = self
    picker.dataSource = self
    picker.reloadAllComponents()
    
    alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
      guard let self = self else { return }
      
      switch self.pickerType {
      case .position1:
        self.position1 = self.pick
        
      case .position2:
        self.position2 = self.pick
        
      case .rank:
        self.rank = self.pick
      }
      
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  @objc private func nextDidTap(_ sender: UIButton) {
    self.view.endEditing(true)
    
    guard let name = nameTextField.textField.text, name.count > 1 else {
      self.alertBase(title: "소환사명을 입력해주세요", message: nil, handler: nil)
      return
    }
    
    guard let description = descriptionTextField.textField.text, !description.isEmpty else {
      self.alertBase(title: "간단소개를 입력해주세요", message: nil, handler: nil)
      return
    }
    
    let keyword = styleButtons.compactMap { Keyword.allCases[$0.tag].key }
    guard keyword.count == 3 else {
      self.alertBase(title: "성향을 3개 선택해주세요", message: nil, handler: nil)
      return
    }
    
    guard !position1.isEmpty, let line1 = Line(rawValue: self.position1) else {
      self.alertBase(title: "1순위 포지션을 선택해주세요", message: nil, handler: nil)
      return
    }
    
    guard !position2.isEmpty, let line2 = Line(rawValue: self.position2) else {
      self.alertBase(title: "2순위 포지션을 선택해주세요", message: nil, handler: nil)
      return
    }
    
    guard self.position1 != self.position2 else {
      self.alertBase(title: "1순위와 2순위를 다르게 선택해주세요", message: nil, handler: nil)
      return
    }
    
    guard !rank.isEmpty, let queue = Queue(rawValue: rank) else {
      self.alertBase(title: "표시 할 랭크를 선택해주세요", message: nil, handler: nil)
      return
    }
    
    let data = [name, description, queue.key]
    let preferLines = [
      AddPreferLine(priority: 1, line: line1.key, nullable: false),
      AddPreferLine(priority: 2, line: line2.key, nullable: false)
    ]
    
    let vc = ProfileAdd2ViewController()
    vc.data = data
    vc.keyword = keyword
    vc.preferLines = preferLines
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  
  // MARK: - UI
  
  override func setAttribute() {
    super.setAttribute()
    
    self.progressbar.progress = 1 / 3
    
    self.titleLabel.text = "1. 기본 정보를 입력해 주세요."
    
    self.nameTextField.titleLabel.text = "소환사명"
    
    self.descriptionTextField.titleLabel.text = "간단소개"
    
    self.styleLabel.text = "성향 키워드"
    
    self.styleSubLabel.text = "(0 / 3)"
    self.styleSubLabel.textColor = .my878991
    self.styleSubLabel.font = UIFont.NotoSansKR.medium(size: 12)
    
    self.keywordButtons = Keyword.allCases.enumerated().map { index, key in
      let button = UIButton()
      button.tag = index
      button.setTitle(key.rawValue, for: .normal)
      button.setTitleColor(.my2A292B, for: .normal)
      button.titleLabel?.font = UIFont.NotoSansKR.medium(size: 12)
      button.addTarget(self, action: #selector(self.styleDidTap(_:)), for: .touchUpInside)
      button.layer.cornerRadius = 16
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.myA9ACB3.cgColor
      self.scrollView.addSubview(button)
      return button
    }
    
    self.positionLabel.text = "포지션"
    
    self.position1Label.text = "1순위"
    self.position1Select.titleLabel.text = "Select"
    let tap1 = UITapGestureRecognizer()
    tap1.name = "tap1"
    tap1.addTarget(self, action: #selector(self.selectDidTap(_:)))
    self.position1Select.addGestureRecognizer(tap1)
    
    self.position2Label.text = "2순위"
    self.position2Select.titleLabel.text = "Select"
    let tap2 = UITapGestureRecognizer()
    tap2.name = "tap2"
    tap2.addTarget(self, action: #selector(self.selectDidTap(_:)))
    self.position2Select.addGestureRecognizer(tap2)
    
    [self.position1Label, self.position2Label].forEach {
      $0.textColor = UIColor.myA9ACB3
      $0.font = UIFont.NotoSansKR.medium(size: 12)
    }
    
    self.rankLabel.text = "표시 할 랭크"
    
    self.rankSelect.titleLabel.text = "솔로랭크"
    let tap3 = UITapGestureRecognizer()
    tap3.name = "tap3"
    tap3.addTarget(self, action: #selector(self.selectDidTap(_:)))
    self.rankSelect.addGestureRecognizer(tap3)
    
    self.nextButton.backgroundColor = .my6540E9
    self.nextButton.setTitle("다음", for: .normal)
    self.nextButton.setTitleColor(.white, for: .normal)
    self.nextButton.titleLabel?.font = UIFont.NotoSansKR.bold(size: 14)
    self.nextButton.layer.cornerRadius = 4
    self.nextButton.layer.masksToBounds = true
    self.nextButton.addTarget(self, action: #selector(self.nextDidTap(_:)), for: .touchUpInside)
    
    [self.titleLabel, self.styleLabel, self.positionLabel, self.rankLabel].forEach {
      $0.textColor = .my878991
      $0.font = UIFont.NotoSansKR.bold(size: 14)
    }
  }
  
  override func setConstraint() {
    super.setConstraint()
    
    [self.titleLabel, self.nameTextField, self.descriptionTextField, self.styleLabel, self.styleSubLabel, self.positionLabel, self.position1Label, self.position1Select, self.position2Label, self.position2Select, self.rankLabel, self.rankSelect, self.nextButton].forEach {
      self.scrollView.addSubview($0)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.leading.equalTo(20)
    }

    self.nameTextField.snp.makeConstraints { make in
      make.top.equalTo(self.titleLabel.snp.bottom).offset(36)
      make.leading.trailing.equalToSuperview().inset(20)
      make.width.equalTo(self.view.frame.width - 40)
      make.height.equalTo(62)
    }

    self.descriptionTextField.snp.makeConstraints { make in
      make.top.equalTo(self.nameTextField.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(20)
      make.width.equalTo(self.view.frame.width - 40)
      make.height.equalTo(62)
    }

    self.styleLabel.snp.makeConstraints { make in
      make.top.equalTo(self.descriptionTextField.snp.bottom).offset(24)
      make.leading.equalTo(20)
    }

    self.styleSubLabel.snp.makeConstraints { make in
      make.leading.equalTo(self.styleLabel.snp.trailing).offset(16)
      make.bottom.equalTo(self.styleLabel)
    }

    self.keywordButtons[0].snp.makeConstraints { make in
      make.top.equalTo(self.styleLabel.snp.bottom).offset(12)
      make.leading.equalTo(20)
      make.width.equalTo(80)
      make.height.equalTo(32)
    }

    self.keywordButtons[1].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[0])
      make.leading.equalTo(self.keywordButtons[0].snp.trailing).offset(8)
      make.width.equalTo(80)
      make.height.equalTo(32)
    }

    self.keywordButtons[2].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[0])
      make.leading.equalTo(self.keywordButtons[1].snp.trailing).offset(8)
      make.width.equalTo(70)
      make.height.equalTo(32)
    }

    self.keywordButtons[3].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[0])
      make.leading.equalTo(self.keywordButtons[2].snp.trailing).offset(8)
      make.width.equalTo(70)
      make.height.equalTo(32)
    }

    self.keywordButtons[4].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[0].snp.bottom).offset(8)
      make.leading.equalTo(20)
      make.width.equalTo(110)
      make.height.equalTo(32)
    }

    self.keywordButtons[5].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[4])
      make.leading.equalTo(self.keywordButtons[4].snp.trailing).offset(8)
      make.width.equalTo(70)
      make.height.equalTo(32)
    }
    
    self.keywordButtons[6].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[4])
      make.leading.equalTo(self.keywordButtons[5].snp.trailing).offset(8)
      make.width.equalTo(80)
      make.height.equalTo(32)
    }

    self.keywordButtons[7].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[4].snp.bottom).offset(8)
      make.leading.equalTo(20)
      make.width.equalTo(80)
      make.height.equalTo(32)
    }
    
    self.keywordButtons[8].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[7])
      make.leading.equalTo(self.keywordButtons[7].snp.trailing).offset(8)
      make.width.equalTo(80)
      make.height.equalTo(32)
    }

    self.keywordButtons[9].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[7])
      make.leading.equalTo(self.keywordButtons[8].snp.trailing).offset(8)
      make.width.equalTo(90)
      make.height.equalTo(32)
    }
    
    self.keywordButtons[10].snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[7].snp.bottom).offset(8)
      make.leading.equalTo(20)
      make.width.equalTo(90)
      make.height.equalTo(32)
    }
    
    self.positionLabel.snp.makeConstraints { make in
      make.top.equalTo(self.keywordButtons[10].snp.bottom).offset(24)
      make.leading.equalTo(20)
    }

    self.position1Label.snp.makeConstraints { make in
      make.top.equalTo(self.positionLabel.snp.bottom).offset(21)
      make.leading.equalTo(20)
    }
    
    self.position1Select.snp.makeConstraints { make in
      make.centerY.equalTo(self.position1Label).offset(-2)
      make.leading.equalTo(self.position1Label.snp.trailing).offset(8)
      make.width.equalTo(104)
      make.height.equalTo(34)
    }
    
    self.position2Label.snp.makeConstraints { make in
      make.top.equalTo(self.position1Label)
      make.leading.equalTo(self.position1Select.snp.trailing).offset(24)
    }
    
    self.position2Select.snp.makeConstraints { make in
      make.centerY.equalTo(self.position1Label).offset(-2)
      make.leading.equalTo(self.position2Label.snp.trailing).offset(8)
      make.width.equalTo(104)
      make.height.equalTo(34)
    }

    self.rankLabel.snp.makeConstraints { make in
      make.top.equalTo(self.position1Label.snp.bottom).offset(31)
      make.leading.equalTo(20)
    }

    self.rankSelect.snp.makeConstraints { make in
      make.top.equalTo(self.rankLabel.snp.bottom).offset(12)
      make.leading.equalTo(20)
      make.width.equalTo(104)
      make.height.equalTo(34)
    }
    
    self.nextButton.snp.makeConstraints { make in
      make.top.equalTo(self.rankSelect.snp.bottom).offset(60)
      make.leading.trailing.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(24)
      make.width.equalTo(self.view.frame.width - 40)
      make.height.equalTo(54)
    }
  }
  
}


extension ProfileAdd1ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerList.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerList[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.pick = self.pickerList[row]
  }
}
