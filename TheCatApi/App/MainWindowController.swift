//
//  MainWindowController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa

protocol Router: AnyObject {
    func setBreedDetailsPresenter(presenter: BreedDetailPresenter)
    func showBreedDetails(_ breed: CatBreed, withImage dataImage: Data?)
    func showBreedsPhotoGalary(for breedId: String)
}

class MainWindowController: NSWindowController {

    let factory = FactoryImpl()
    
    weak var detailViewPresenter: BreedDetailPresenter?
    private var photoGalaryWindow: NSWindow?
    
    convenience init() {
        self.init(windowNibName: "MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        window?.title = "Cat Breeds"
        window?.styleMask.remove([.resizable, .fullScreen])
        
        setupContent()
    }
    
    private func setupContent() {
        let splitVC = NSSplitViewController()
        
        // Left side
        let listItem = NSSplitViewItem(viewController: factory.createBreedList(router: self))
        listItem.minimumThickness = 200
        
        // Right side
        let detailItem = NSSplitViewItem(viewController: factory.createBreedDetails(router: self))
        detailItem.minimumThickness = 400
        
        // Добавляем в splitVC
        splitVC.addSplitViewItem(listItem)
        splitVC.addSplitViewItem(detailItem)
        
        window?.contentViewController = splitVC
    }
}

extension MainWindowController: Router {
    func setBreedDetailsPresenter(presenter: BreedDetailPresenter) {
        self.detailViewPresenter = presenter
    }
    
    func showBreedDetails(_ breed: CatBreed, withImage dataImage: Data? = nil) {
        detailViewPresenter?.present(breed: breed, withImage: dataImage)
    }
    
    func showBreedsPhotoGalary(for breedId: String) {
        
//        photoGalaryWindow?.close()
//        photoGalaryWindow = nil
        
        let window = factory.createBreedPhotoGalaryWindow()
//        window.delegate = self
        
        let viewController = factory.createBreedPhotoGalary(breedId: breedId)
        window.contentViewController = viewController
        
        photoGalaryWindow = window
    }
}

//extension MainWindowController: NSWindowDelegate {
//    func windowWillClose(_ notification: Notification) {
//        // Когда окно закрывается системой (например, кликом на крестик)
//        photoGalaryWindow = nil
//    }
//}
