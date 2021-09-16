//
//  ProfileCardModel.swift
//  GMakers
//
//  Created by Lee on 2021/09/12.
//

import Foundation

struct ProfileCardModel: Codable {
  
  let accountID: Int
  let username: String
  let profileID: Int
  let summonerAccountID: String
  let profileIconID: Int
  let summonerID: String
  let summonerName: String
  let preferQueue: String
  let level: Int
  let queue: String
  let tier: String
  let tierLevel: Int
  let preferLines: [PreferLine]
  let certified: Bool
  
  enum CodingKeys: String, CodingKey {
    case accountID = "accountId"
    case username
    case profileID = "profileId"
    case summonerAccountID = "summonerAccountId"
    case profileIconID = "profileIconId"
    case summonerID = "summonerId"
    case summonerName
    case preferQueue
    case level
    case queue
    case tier
    case tierLevel
    case preferLines
    case certified
  }
  
  var timerImageName: String {
    return "emblem_" + self.tier.lowercased()
  }
  
  var preferLineImageNames: [String] {
    return self.preferLines.map {
      let line = $0.line.lowercased()
      var temp = ""
      switch line {
      case "ad": temp = "bot"
      case "sup": temp = "support"
      default: temp = line
      }
      return "position_" + self.tier.lowercased() + "-" + temp
    }
  }
}

struct PreferLine: Codable {
  
  let line: String
  let preferLinePriority: Int
}
