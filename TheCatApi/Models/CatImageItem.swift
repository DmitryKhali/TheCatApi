//
//  CatImageItem.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 4/5/25.
//

import Foundation

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}
