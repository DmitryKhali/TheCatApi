//
//  BreedPhotoGalaryPresenter.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 4/7/25.
//

import Foundation

protocol BreedPhotoGalaryPresenter: AnyObject {
    func presentPhotos()
}

final class BreedPhotoGalaryPresenterImpl: BreedPhotoGalaryPresenter {
    
    let networkService: NetworkService
    let breedId: String
    weak var view: BreedPhotoGalaryView?
    
    init(networkService: NetworkService, breedId: String) {
        self.networkService = networkService
        self.breedId = breedId
    }
    
    func presentPhotos() {
        
    }
    
    deinit {
        print("BreedPhotoGalaryPresenter deinit")
    }
}
