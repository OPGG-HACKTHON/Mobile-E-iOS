//
//  ProfileAddModel.swift
//  GMakers
//
//  Created by Lee on 2021/09/13.
//

import Foundation

struct ProfileAddModel: Codable {
  
  let summonerName, welcomeDescription: String
  let preferKeywords: [String]
  let preferChampions: [PreferChampion]
  let preferLines: [AddPreferLine]
  let preferQueue: String
  
  enum CodingKeys: String, CodingKey {
    case summonerName
    case welcomeDescription = "description"
    case preferKeywords, preferChampions, preferLines, preferQueue
  }
}

struct PreferChampion: Codable {
  let priority, championID: Int
  let nullable: Bool
  
  enum CodingKeys: String, CodingKey {
    case priority
    case championID = "championId"
    case nullable
  }
}

struct AddPreferLine: Codable {
  let priority: Int
  let line: String
  let nullable: Bool
}
