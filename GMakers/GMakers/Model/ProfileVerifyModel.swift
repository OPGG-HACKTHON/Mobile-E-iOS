//
//  ProfileVerifyModel.swift
//  GMakers
//
//  Created by Lee on 2021/09/13.
//

import Foundation

struct ProfileVerifyModel: Codable {
  
  let level, profileIconID: Int
  let summonerID, summonerName: String
  let leaguePoint: Int
  let tier, tierLevel, queue: String
  
  enum CodingKeys: String, CodingKey {
    case level
    case profileIconID = "profileIconId"
    case summonerID = "summonerId"
    case summonerName, leaguePoint, tier, tierLevel, queue
  }
  
  var timerImageName: String {
    return "emblem_" + self.tier.lowercased()
  }
}

//{
//    "level": 113,
//    "profileIconId": 4833,
//    "summonerId": "Pje-tT0mcRPQe-1vQ2kY6I1_YPWiCsoa2mffRBf8KXtRDNo",
//    "summonerName": "티 모",
//    "leaguePoint": 12,
//    "tier": "GOLD",
//    "tierLevel": "III",
//    "queue": "RANKED_SOLO"
//}
