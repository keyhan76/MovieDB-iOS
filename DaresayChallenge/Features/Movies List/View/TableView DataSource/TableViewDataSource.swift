//
//  TableViewDataSource.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import UIKit

public protocol DiffableTableViewCell: UITableViewCell {
    
    associatedtype CellViewModel: Hashable
    
    func configureCellWith(_ item: CellViewModel)
}

enum Section: CaseIterable {
    case main
}

final class TableViewDataSource<Cell: DiffableTableViewCell, T: ListViewModelable>: UITableViewDiffableDataSource<Section, Cell.CellViewModel>, UITableViewDataSourcePrefetching, UITableViewDelegate {
    
    private let viewModel: T
    
    public var didSelectItem: ((_ indexPath: Int) -> Void)?
    
    private var snapShot: NSDiffableDataSourceSnapshot<Section, Cell.CellViewModel>!
    
    init(_ tableView: UITableView, viewModel: T) {
        
        self.viewModel = viewModel
        
        tableView.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
        
        super.init(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let identifier = String(describing: Cell.self)
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! Cell
            
            cell.configureCellWith(itemIdentifier)
            
            return cell
        }
    }
    
    func append(new items: [Cell.CellViewModel]) {
        snapShot = NSDiffableDataSourceSnapshot<Section, Cell.CellViewModel>()
        
        snapShot.appendSections([.main])
        snapShot.appendItems(items, toSection: .main)
        
        apply(snapShot, animatingDifferences: false)
    }
    
    func reload(items: [Cell.CellViewModel]) {
        snapShot.reloadItems(items)
        applySnapshotUsingReloadData(snapShot)
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableView DataSource Prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) && !viewModel.isFinished {
            print("==========get new data======")
            Task {
                let movies = await viewModel.prefetchData() as! [Cell.CellViewModel]
                
                append(new: movies)
            }
        }
    }
}
