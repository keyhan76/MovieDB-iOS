//
//  TableViewDataSource.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-28.
//

import UIKit

protocol TableViewCell: UITableViewCell {
    func configureCell(with item: ListViewModelable, indexPath: Int)
}


final class TableViewDataSourceProvider<T: ListViewModelable, Cell: TableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    
    // MARK: - Variables
    private var tableView: UITableView
    private var viewModel: T
    
    public var didSelectItem: ((_ indexPath: Int) -> Void)?
    
    // Reuse identifier
    private let cellID = String(describing: Cell.self)
    
    // MARK: - Init
    init(tableView: UITableView, viewModel: T) {
        self.tableView = tableView
        self.viewModel = viewModel
        super.init()
        
        setupTableView()
    }
    
    // MARK: - Public methods
    public func append() {
        guard viewModel.totalCount != viewModel.itemsCount else { return }
        
        if viewModel.totalCount == 0 {
            viewModel.totalCount = viewModel.itemsCount
            tableView.reloadData()
        } else {
            let startIndex = viewModel.totalCount
            let endIndex = viewModel.itemsCount
            let indexPathsToAdd = (startIndex..<endIndex).map {IndexPath(row: $0, section: 0)} as [IndexPath]
            viewModel.totalCount = viewModel.itemsCount
            
            self.tableView.performBatchUpdates({
                self.tableView.insertRows(at: indexPathsToAdd, with: .none)
            }, completion: nil)
            
        }
    }
    
    public func refresh() {
        tableView.reloadData()
    }
    
    // MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectItem?(indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - UITableView DataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = generateCell(Cell.self, indexPath: indexPath)

        cell.configureCell(with: viewModel, indexPath: indexPath.row)

        return cell
    }
    
    // MARK: - UITableView DataSource Prefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: viewModel.isLoadingCell) && !viewModel.isFinished {
            print("==========get new data======")
            Task {
                await viewModel.prefetchData()
                
                append()
            }
        }
    }
}

// MARK: - Helpers
private extension TableViewDataSourceProvider {
    func generateCell<T: UITableViewCell>(_ cell: T.Type, indexPath: IndexPath) -> T {
        let identifier = String(describing: T.self)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
    func setupTableView() {
        tableView.register(Cell.self, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
    }
}
