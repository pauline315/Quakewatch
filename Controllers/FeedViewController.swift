//
//  FeedViewController.swift
//  quakealert
//
//  Created by EMTECH MAC on 03/07/2024.
//

import UIKit

class FeedViewController: UIViewController {
    private let viewModel = EarthquakeViewModel()
    private let tableView = UITableView()
   


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        viewModel.fetchEarthquakeData()
    }

    private func setupView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
         
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.register(EarthquakeTableViewCell.self, forCellReuseIdentifier: EarthquakeTableViewCell.reuseIdentifier)
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfEarthquakes
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EarthquakeTableViewCell.reuseIdentifier, for: indexPath) as! EarthquakeTableViewCell
        let earthquake = viewModel.earthquake(at: indexPath.row)
        cell.configure(with: earthquake)
        return cell
    }
}
