//
//  BreedListPresenter.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Foundation


protocol BreedListDisplayLogic: AnyObject {
    func didLoadBreeds(_ breeds: [CatBreed])
    
}

protocol BreedListRoutingLogic: AnyObject {
    func showBreedDetails(_ breed: CatBreed)
}

class BreedListPresenter {
    weak var view: BreedListDisplayLogic?
    weak var router: BreedListRoutingLogic?
    
    private var networkService = NetworkService()
    
    func loadBreeds() {
        networkService.fetchBreeds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let breeds):
                    self?.view?.didLoadBreeds(breeds)
                case .failure(let error):
                    print("Ошибка при загрузке: \(error)")
                }
            }
        }
    }
    
    func didSelectBreed(_ breed: CatBreed) {
        router?.showBreedDetails(breed)
    }
}
