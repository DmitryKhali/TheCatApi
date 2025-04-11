//
//  CatBreed.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Foundation


struct CatBreed: Decodable {
    let id: String
    let name: String
    let description: String
    let energyLevel: Int?
    let intelligence: Int?
    let wikipediaUrl: String?
    var imageUrl: String?
}
