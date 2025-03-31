//
//  MainWindowController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa


class MainWindowController: NSWindowController {

    var detailViewController: BreedDetailViewController!
    
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
        
        let presenter = BreedListPresenter()
        presenter.router = self
        
        // Left side
        let breedListVC = BreedListViewController(nibName: "BreedListView", bundle: nil)
        breedListVC.presenter = presenter
        presenter.view = breedListVC
        presenter.loadBreeds()
        let listItem = NSSplitViewItem(viewController: breedListVC)
        listItem.minimumThickness = 200
        
        // Right side
        let breedsDetailVC = BreedDetailViewController(nibName: "BreedDetailView", bundle: nil)
        detailViewController = breedsDetailVC
        let detailItem = NSSplitViewItem(viewController: breedsDetailVC)
        detailItem.minimumThickness = 400
        
        // Добавляем в splitVC
        splitVC.addSplitViewItem(listItem)
        splitVC.addSplitViewItem(detailItem)
        
        window?.contentViewController = splitVC
    }
}

extension MainWindowController: BreedListRoutingLogic {
    func showBreedDetails(_ breed: CatBreed) {
        detailViewController.update(breed: breed)
    }
}
