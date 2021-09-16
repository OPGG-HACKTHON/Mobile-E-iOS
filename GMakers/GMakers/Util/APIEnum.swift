//
//  APIEnum.swift
//  GMakers
//
//  Created by Lee on 2021/09/13.
//

import Foundation

enum Queue: String, CaseIterable {
  
  case 솔로랭크
  case 자유랭크
  case 선택안함
  
  var key: String {
    switch self {
    case .솔로랭크: return "RANKED_SOLO"
    case .자유랭크: return "RANKED_FLEX"
    case .선택안함: return "NONE"
    }
  }
}

enum Line: String, CaseIterable {
  
  case 탑
  case 정글
  case 미드
  case 원딜
  case 서폿
  
  var key: String {
    switch self {
    case .탑: return "TOP"
    case .정글: return "JUNGLE"
    case .미드: return "MID"
    case .원딜: return "AD"
    case .서폿: return "SUP"
    }
  }
}

enum Keyword: String, CaseIterable {
  
  case 망나니
  case 스플릿
  case 탱커
  case 갱킹
  case 오브젝트지향
  case 로밍
  case 암살자
  case 성장형
  case 유틸형
  case 전투민족
  case 한타지향
  
  var key: String {
    switch self {
    case .망나니  : return "HEADSMAN"
    case .스플릿  : return "SPLIT"
    case .탱커  : return "TANKER"
    case .갱킹  : return "GANKING"
    case .오브젝트지향  : return "ORIENTED_OBJECT"
    case .로밍  : return "ROAMING"
    case .암살자  : return "ASSASSIN"
    case .성장형  : return "GROWTH_TYPE"
    case .유틸형  : return "UTILITY_TYPE"
    case .전투민족  : return "BATTLE_NATION"
    case .한타지향  : return "ORIENTED_TOWARDS_FIGHTING"
    }
  }
}
