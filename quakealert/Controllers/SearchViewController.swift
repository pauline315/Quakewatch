//
//  SearchViewController.swift
//  quakealert
//
//  Created by EMTECH MAC on 18/07/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    
    var viewModel: EarthquakeViewModel
    private let disposeBag = DisposeBag()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search earthquakes"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(viewModel: EarthquakeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.fetchAPI.onNext(())
        view.backgroundColor = .systemRed
    }
    
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        let searchTextObservable = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
        
        let filteredDataObservable = Observable.combineLatest(viewModel.data, searchTextObservable) { earthquakes, searchText in
            return earthquakes.filter { earthquake in
                searchText.isEmpty || earthquake.place.lowercased().contains(searchText.lowercased())
            }
        }
        
        filteredDataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { row, element, cell in
                cell.textLabel?.numberOfLines = 0 // Allow multiline text in cell
                cell.textLabel?.text = """
                Magnitude: \(element.mag)
                Place: \(element.place)
                Time: \(element.time)
                Coordinates: \(element.latitude), \(element.longitude)
                """
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Earthquake.self)
            .subscribe(onNext: { [weak self] earthquake in
                self?.showMapForEarthquake(earthquake)
            })
            .disposed(by: disposeBag)
    }
    
    private func showMapForEarthquake(_ earthquake: Earthquake) {
        let mapViewController = MapViewController()
        mapViewController.selectedEarthquake = earthquake
        mapViewController.earthquakes = viewModel.data.value
        navigationController?.pushViewController(mapViewController, animated: true)
    }
}


