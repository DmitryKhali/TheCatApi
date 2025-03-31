//
//  BreedDetailViewController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa


class BreedDetailViewController: NSViewController {
    @IBOutlet var breedNameLabel: NSTextField!
    
    func update(breed: CatBreed) {
        breedNameLabel.stringValue = breed.name
    }
}
