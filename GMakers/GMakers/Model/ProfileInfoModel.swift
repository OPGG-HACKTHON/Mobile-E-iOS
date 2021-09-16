//
//  ProfileInfoModel.swift
//  GMakers
//
//  Created by Lee on 2021/09/15.
//

import Foundation

struct ProfileInfoModel: Codable {
  
  let accountID: Int
  let username: String
  let profileID: Int
  let summonerAccountID: String
  let preferQueue: String
  let profileIconID: Int
  let summonerID: String
  let summonerName: String
  let level: Int
  let queue: String
  let tier: String
  let tierLevel: Int
  let leaguePoint: Int
  let loseGames: Int
  let winGames: Int
  let winRate: Int
  let description: String
  let preferChampions: [PreferChampions]
  let preferLines: [PreferLine]
  let preferKeywords: [String]
  let certified: Bool
  
  enum CodingKeys: String, CodingKey {
    case accountID = "accountId"
    case username
    case profileID = "profileId"
    case summonerAccountID = "summonerAccountId"
    case preferQueue
    case profileIconID = "profileIconId"
    case summonerID = "summonerId"
    case summonerName
    case level
    case queue
    case tier
    case tierLevel
    case leaguePoint
    case loseGames
    case winGames
    case winRate
    case description
    case preferChampions
    case preferLines
    case preferKeywords
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


struct PreferChampions: Codable {
  
  let championName: String
  let championID: Int
  let championPoints: Int
  let preferChampionPriority: Int
  let championLevel: Int
  
  enum CodingKeys: String, CodingKey {
    case championName
    case championID = "championId"
    case championPoints
    case preferChampionPriority
    case championLevel
  }
}
