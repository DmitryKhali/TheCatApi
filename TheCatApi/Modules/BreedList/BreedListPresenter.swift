//
//  BreedListPresenter.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Foundation




protocol BreedListPresenter {
    func breedsCount() -> Int
    func loadBreeds()
    func loadBreedsImages()
    func didSelectBreed(_ breed: CatBreed, withImage imageData: Data?)
    func getBreed(at index: Int) -> CatBreed?
    func getBreedImage(for: String) -> Data?
}

class BreedListPresenterImpl {
    weak var view: BreedListView?
    weak var router: Router?
    private var networkService: NetworkService
    private var breeds: [CatBreed] = []
    private var breedsImages: [String: Data] = [:]
    private var lock: NSLock = NSLock()
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
      
    private func selectFirstRow() {
        DispatchQueue.main.async { self.view?.selectFirstRow() }
    }
    
    private func requestViewUpdate() {
        DispatchQueue.main.async { self.view?.reloadTableView() }
    }
    
    private func requestUpdateCellView(with index: Int) {
        DispatchQueue.main.async { self.view?.reloadTableViewCell(withIndex: index) }
    }
}

extension BreedListPresenterImpl: BreedListPresenter {
    
    func breedsCount() -> Int {
        breeds.count
    }
    
    func loadBreeds() {
        networkService.fetchBreeds { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let breeds):
                    self?.breeds = breeds
                    self?.requestViewUpdate()
                    self?.selectFirstRow()
                    self?.loadBreedsImages()
                case .failure(let error):
                    print("Ошибка при загрузке: \(error)")
                }
            }
        }
    }
    
    func loadBreedsImages() {
        breeds.map(\.id).forEach { breedId in
            networkService.fetchBreedImage(forBreedId: breedId) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageData):
//                        print("1 - string before self.lock.withLock")
                        self.lock.withLock {
//                            print("2 - start self.lock.withLock")
                            self.breedsImages[breedId] = imageData
//                            print("3 - count of elements\(self.breedsImages.count)")
//                            self.requestViewUpdate()
                            if let index = self.breeds.firstIndex(where: { $0.id == breedId }) {
                                self.requestUpdateCellView(with: index)
                            }
//                            print("4 - finish self.lock.withLock")
                        }
                    case .failure(let error):
                        print("Ошибка при загрузке: \(error)")
                    }
                
                }
            }
        }
    }
    
    func getBreedImage(for breedId: String) -> Data? {
        guard let imageData = breedsImages[breedId] else { return nil }
        return imageData
    }
    
    func getBreed(at index: Int) -> CatBreed? {
        breeds[index]
    }
    
    func didSelectBreed(_ breed: CatBreed, withImage imageData: Data? = nil) {
        router?.showBreedDetails(breed, withImage: imageData)
    }
}
