//
//  Queue.swift
//  SeSAC-Friends
//
//  Created by sookim on 2022/02/10.
//

import Foundation

struct OnQueue: Codable {
    let region: Int
    let lat: Double
    let long: Double
}

// MARK: - Post
struct Post: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}
