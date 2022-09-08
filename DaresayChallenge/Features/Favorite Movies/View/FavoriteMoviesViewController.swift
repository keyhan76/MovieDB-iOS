//
//  FavoriteMoviesViewController.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-29.
//

import UIKit

final class FavoriteMoviesViewController: UIViewController {

    // MARK: - Variables
    private let viewModel: FavoriteMoviesViewModel
    private var dataSourceProvider: TableViewDataSourceProvider<FavoriteMoviesViewModel, MovieTableViewCell>!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Init
    init(viewModel: FavoriteMoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .systemBlue
    }
}

// MARK: - Helpers
private extension FavoriteMoviesViewController {
    func setupUI() {
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Favorites"
        
        dataSourceProvider = TableViewDataSourceProvider(tableView: tableView, viewModel: viewModel)
        
        tableView.delegate = dataSourceProvider
        tableView.dataSource = dataSourceProvider
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        dataSourceProvider.append()
    }
}

extension FavoriteMoviesViewController: ReloadFavoritesDelegate {
    func refresh() {
        dataSourceProvider.refresh()
    }
}
