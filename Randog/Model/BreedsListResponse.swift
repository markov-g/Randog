//
//  BreedsListResponse.swift
//  Randog
//
//  Created by Georgi Markov on 8/15/21.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String:[String]]
}
