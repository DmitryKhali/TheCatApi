//
//  BreedDetailPresenter.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 4/7/25.
//

import Foundation

protocol BreedDetailPresenter: AnyObject {
    func present(breed: CatBreed, withImage imageData: Data?)
    func showPhotoGalary()
    func currentBreed() -> CatBreed?
    func currentBreedImage() -> Data?
}

final class BreedDetailPresenterImpl: BreedDetailPresenter {
    
    weak var view: BreedDetailView?
    weak var router: Router?
    private var breed: CatBreed?
    private var breedImage: Data?
    
    func present(breed: CatBreed, withImage imageData: Data?) {
        self.breed = breed
        self.breedImage = imageData
        
        view?.update()
    }
    
    func currentBreed() -> CatBreed? {
        breed
    }
    
    func currentBreedImage() -> Data? {
        breedImage
    }
    
    func showPhotoGalary() {
        guard let id = breed?.id else { return }
        router?.showBreedsPhotoGalary(for: id)
    }
    
}
