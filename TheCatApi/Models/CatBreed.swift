//
//  CatBreed.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Foundation


struct CatBreed: Decodable {
    let id: String?
    let name: String?
    let description: String?
    let energyLevel: String?
    let intelligence: String?
    let wikipediaUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case energyLevel = "energy_level"
        case intelligence
        case wikipediaUrl = "wikipedia_url"
    }
}
