//
//  BreedListViewController.swift
//  TheCatApi
//
//  Created by Dmitry Khalitov on 3/30/25.
//

import Cocoa


class BreedListViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var breeds: [CatBreed] = []
    
    var presenter: BreedListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
}

extension BreedListViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }
        
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("CellID"), owner: self) as? NSTableCellView {
            cell.textField?.stringValue = breeds[row].name
            return cell
        }
        
        return nil
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let selectedRow = tableView.selectedRow
        guard selectedRow >= 0 else { return }
        
        let selectedBreed = breeds[selectedRow]
        print("Выбрана порода: \(selectedBreed.name)")
        
        presenter?.didSelectBreed(selectedBreed)
    }
}
    
extension BreedListViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        breeds.count
    }
}

extension BreedListViewController: BreedListDisplayLogic {
    func didLoadBreeds(_ breeds: [CatBreed]) {
        self.breeds = breeds
        self.tableView.reloadData()
    }
}
