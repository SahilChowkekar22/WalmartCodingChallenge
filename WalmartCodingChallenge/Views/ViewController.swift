//
//  ViewController.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/23/25.
//

import UIKit
import Combine

final class ViewController: UIViewController {

    // UI
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)

    // ViewModel
    private let countriesViewModel = CountriesViewModel()
    private var cancellables = Set<AnyCancellable>()

    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupSearchController()
        bindViewModel()
        countriesViewModel.getCountries()
    }

    // Setup
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CountryCell.self, forCellReuseIdentifier: "CountryCell")

        tableView.separatorStyle = .none // Remove default lines
        tableView.backgroundColor = .white // Background stays white for spacing

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search countries"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    // Binding
    private func bindViewModel() {
        countriesViewModel.$filteredCountries
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesViewModel.numberOfCountries()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryCell else {
            return UITableViewCell()
        }

        let country = countriesViewModel.country(at: indexPath.row)
        cell.configure(with: country)
        return cell
    }
}

// UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let country = countriesViewModel.country(at: indexPath.row)
        print("Selected: \(country.name ?? "Unknown")")
    }
}

// UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        countriesViewModel.searchText = text
    }
}

