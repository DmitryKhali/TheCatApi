//
//  BreedDetailViewController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa

protocol BreedDetailView: AnyObject {
//    func present(breed: CatBreed, imageData: Data?)
    func update()
}

class BreedDetailViewController: NSViewController {
    
    @IBOutlet weak var breedImage: NSImageView!
    @IBOutlet weak var breedNameLabel: NSTextField!
    @IBOutlet weak var breedEnergyLevelLabel: NSTextField!
    @IBOutlet weak var breedIntelligenceLabel: NSTextField!
    @IBOutlet weak var breedWikiLinkLabel: NSTextField!
    @IBOutlet weak var showMoreImagesButton: NSButton!
    @IBOutlet weak var breedDescriptionLabel: NSTextView!
    
    @IBAction func showPhotoGalaryAction(_ sender: Any) {
        presenter.showPhotoGalary()
    }
    
    let presenter: BreedDetailPresenter
    
    init(presenter: BreedDetailPresenter) {
        self.presenter = presenter
        super.init(nibName: "BreedDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        breedWikiLinkLabel.allowsEditingTextAttributes = true
        breedWikiLinkLabel.isSelectable = true
    }
}

extension BreedDetailViewController: BreedDetailView {
    
    func update() {
        if let imageData = presenter.currentBreedImage(),
           let image = NSImage(data: imageData) {
            breedImage.image = image
        }
        else {
            breedImage.image = nil
        }
        
        guard let breed = presenter.currentBreed() else { return }
    
        breedNameLabel.stringValue = breed.name
        
        breedDescriptionLabel.string = breed.description
        breedDescriptionLabel.isEditable = false
                
        breedEnergyLevelLabel.stringValue = breed.energyLevel != nil ? "\(breed.energyLevel!) / 5" : "-"
        breedIntelligenceLabel.stringValue = breed.intelligence != nil ? "\(breed.intelligence!) / 5" : "-"
        
        if let wikiUrl = breed.wikipediaUrl {
            let mutableAttributedString = NSMutableAttributedString(string: breedWikiLinkLabel.stringValue)
            mutableAttributedString.addAttribute(.link, value: wikiUrl, range: NSMakeRange(0, mutableAttributedString.length))
            breedWikiLinkLabel.attributedStringValue = mutableAttributedString
        }
        else {
            breedWikiLinkLabel.stringValue = "-"
        }
    }
}
