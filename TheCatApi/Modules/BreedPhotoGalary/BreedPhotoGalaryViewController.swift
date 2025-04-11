import Cocoa

protocol BreedPhotoGalaryView: AnyObject {
    func displayPhotos(_ images: [NSImage])
}


final class BreedPhotoCell: NSCollectionViewItem {
    private let customImageView = NSImageView()
    
    override func loadView() {
        view = NSView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.lightGray.cgColor
        
        configureImageView()
    }
    
    private func configureImageView() {
        customImageView.imageScaling = .scaleProportionallyDown

        view.addSubview(customImageView)
        
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customImageView.topAnchor.constraint(equalTo: view.topAnchor),
            customImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configure(with image: NSImage) {
        customImageView.image = image
    }
    
    override var isSelected: Bool {
        didSet {
            view.layer?.borderWidth = isSelected ? 2 : 0
            view.layer?.borderColor = NSColor.systemBlue.cgColor
        }
    }
}

final class BreedPhotoGalaryViewController: NSViewController {
    
    private let presenter: BreedPhotoGalaryPresenter
    private var photos: [NSImage] = []
    
    private lazy var collectionView: NSCollectionView = {
        let layout = NSCollectionViewFlowLayout()
        layout.itemSize = NSSize(width: 300, height: 300)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        layout.sectionInset = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = NSCollectionView(frame: .zero)
        collectionView.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColors = [.clear]
        collectionView.isSelectable = true
        collectionView.register(
            BreedPhotoCell.self,
            forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BreedPhotoCell")
        )
        return collectionView
    }()
    
    init(presenter: BreedPhotoGalaryPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
//        presenter.view = self 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: 630, height: 400))
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Тестовые данные
        let testImages = (1...10).compactMap { _ in
            NSImage(named: NSImage.Name("CatImage"))
        }
        
        self.displayPhotos(testImages)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        print("Collection view frame: \(collectionView.frame)")
    }
    
    private func setupCollectionView() {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.documentView = collectionView
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension BreedPhotoGalaryViewController: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
            withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "BreedPhotoCell"),
            for: indexPath
        ) as! BreedPhotoCell
        
        cell.configure(with: photos[indexPath.item])
        return cell
    }
}

extension BreedPhotoGalaryViewController: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let indexPath = indexPaths.first else { return }
        print("Selected photo at index: \(indexPath.item)")
    }
}

extension BreedPhotoGalaryViewController: BreedPhotoGalaryView {
    func displayPhotos(_ images: [NSImage]) {
        self.photos = images
        collectionView.reloadData()
    }
}
