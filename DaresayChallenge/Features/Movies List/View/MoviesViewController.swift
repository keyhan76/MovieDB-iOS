//
//  MoviesViewController.swift
//  DaresayChallenge
//
//  Created by Keihan Kamangar on 2022-06-27.
//

import UIKit

final class MoviesViewController: UIViewController {

    // MARK: - Variables
    private let viewModel: MoviesViewModel = MoviesViewModel(moviesService: MoviesService.shared)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = AccessibilityIdentifiers.moviesTableView.rawValue
        return tableView
    }()
    
    private var dataSource: TableViewDataSource<MovieTableViewCell, MoviesViewModel>!
    
    public var didSendEventClosure: ((MoviesViewController.Event) -> Void)?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        populate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - Helpers
private extension MoviesViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "MovieDB"
        
        let rightBarButton = UIBarButtonItem(title: "Favorites", primaryAction: UIAction(handler: { [weak self] _ in
            guard let self = self else { return }
            self.didSendEventClosure?(.favorites)
        }))
        
        navigationItem.rightBarButtonItem = rightBarButton
        rightBarButton.accessibilityIdentifier = AccessibilityIdentifiers.favoriteBarButton.rawValue
    }
    
    func populate() {
        view.animateActivityIndicator()
        
        Task {
            let movies = await viewModel.populate()
            setupTableView()
            dataSource.append(new: movies)
            
            if !viewModel.isLoading {
                view.removeActivityIndicator()
            }
        }
    }
    
    func setupTableView() {
        dataSource = TableViewDataSource(tableView, viewModel: viewModel)
        
        tableView.delegate = dataSource
        tableView.prefetchDataSource = dataSource
        
        view.addSubview(tableView)
        
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        setupTableViewBindings()
    }
    
    func setupTableViewBindings() {
        dataSource.didSelectItem = { [weak self] indexPath in
            guard let self = self else { return }

            let item = self.viewModel.didSelect(itemAt: indexPath)

            self.didSendEventClosure?(.movieDetail(item))
        }
    }
}

// MARK: - Events
extension MoviesViewController {
    enum Event {
        case movieDetail(_ selectedMovie: MoviesModel)
        case favorites
    }
}

// MARK: - ReloadFavorites Delegate
extension MoviesViewController: ReloadFavoritesDelegate {
    func refresh(item: MoviesModel) {
        dataSource.reload(items: [item])
    }
}
