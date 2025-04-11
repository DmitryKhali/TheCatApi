//
//  BreedListViewController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa

protocol BreedListView: AnyObject {
    func selectFirstRow()
    func reloadTableView()
    func reloadTableViewCell(withIndex: Int)
}

class BreedListViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    private var presenter: BreedListPresenter
    
    init(presenter: BreedListPresenter) {
        self.presenter = presenter
        super.init(nibName: "BreedListViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.loadBreeds()
    }
}

extension BreedListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("CellID"), owner: self) as? NSTableCellView,
              let breed = presenter.getBreed(at: row)
        else {
            return nil
        }
        
        cell.textField?.stringValue = breed.name
        
//        print("!!! A: breed.id \(breed.id)")
        if let breedImage = presenter.getBreedImage(for: breed.id) {
            cell.imageView?.image = nil
            cell.imageView?.image = NSImage(data: breedImage)
//            print("!!! B: breed.id \(breed.id)")
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0,
              let selectedBreed = presenter.getBreed(at: selectedRow)
        else {
            return
        }
        
        var imageOfSelectedBreed: Data? = nil
        if let imageOfSelectedBreedData = presenter.getBreedImage(for: selectedBreed.id) {
            imageOfSelectedBreed = imageOfSelectedBreedData
        }
        
//        print("Выбрана порода: \(selectedBreed.name)")
        
        presenter.didSelectBreed(selectedBreed, withImage: imageOfSelectedBreed)
    }
}
    
extension BreedListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        presenter.breedsCount()
    }
}

extension BreedListViewController: BreedListView {
    func selectFirstRow() {
        tableView.selectRowIndexes(IndexSet(integer: 0), byExtendingSelection: false)
    }
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
    func reloadTableViewCell(withIndex index: Int) {
        tableView.reloadData(forRowIndexes: IndexSet(integer: index), columnIndexes: IndexSet(integer: 0))
    }
}
