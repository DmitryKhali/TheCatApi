//
//  Factory.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 4/3/25.
//

import Cocoa

protocol Factory {
    func createBreedList(router: Router) -> NSViewController
    func createBreedDetails(router: Router) -> NSViewController
    func createBreedPhotoGalaryWindow() -> NSWindow
    func createBreedPhotoGalary(breedId: String) -> NSViewController
}

final class FactoryImpl: Factory {
    private let networkService = NetworkServiceImpl()
    
    func createBreedList(router: Router) -> NSViewController {
        let presenter = BreedListPresenterImpl(networkService: networkService)
        presenter.router = router
        let viewController = BreedListViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    func createBreedDetails(router: Router) -> NSViewController {
        let presenter = BreedDetailPresenterImpl()
        presenter.router = router
        router.setBreedDetailsPresenter(presenter: presenter)
        let viewController = BreedDetailViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    func createBreedPhotoGalaryWindow() -> NSWindow {
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 630, height: 400),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Breeds photo library"
        window.center()
        
        window.makeKeyAndOrderFront(nil)
        
        return window
    }
    
    func createBreedPhotoGalary(breedId: String) -> NSViewController {
        let presenter = BreedPhotoGalaryPresenterImpl(networkService: networkService, breedId: breedId)
        let viewController = BreedPhotoGalaryViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
