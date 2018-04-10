//
//  ResultsTableViewController.swift
//  Space Rocks
//
//  Created by Radim Langer on 04/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit
import MapKit

protocol ResultsTableViewControllerDelegate: AnyObject {
    func tableViewControllerDidSelectMeteorite(_ controller: ResultsTableViewController, _ meteorite: Meteorite)
}

final class ResultsTableViewController: ScrollableSheetViewController {

    weak var delegate: ResultsTableViewControllerDelegate?

    var allMeteorites = [Meteorite]() {
        didSet {
            meteoritesToShow = allSortedMeteoritesByMass
        }
    }

    var meteoritesToShow = [Meteorite]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    private var allSortedMeteoritesByMass: [Meteorite] {
        return allMeteorites.sorted(by: { Double($0.mass) ?? 0 > Double($1.mass) ?? 0 })
    }

    @IBOutlet var searchBar: UISearchBar!

    @IBOutlet var tableView: UITableView! {
        didSet {
            scrollableContentView = tableView
        }
    }

    private var isEditingSearchBar = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        addBlurEffectView()
        animateSheetView(direction: .down, duration: 0.5)
    }

    private func setupTableView() {
        let cellType = MeteorTableViewCell.self
        tableView.register(cellType, forCellReuseIdentifier: String(describing: cellType))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }

    func resetMeteoritesToAll() {
        meteoritesToShow = allSortedMeteoritesByMass
    }
}

extension ResultsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedMeteorite = meteoritesToShow[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: false)

        searchBar.endEditing(true)
        animateSheetView(direction: .bottomHiddden)
        delegate?.tableViewControllerDidSelectMeteorite(self, selectedMeteorite)
    }

}

extension ResultsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteoritesToShow.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = String(describing: MeteorTableViewCell.self)
        let meteorite = meteoritesToShow[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? MeteorTableViewCell ??
                    MeteorTableViewCell()

        let massString = meteorite.mass.firstThreeCharactersAfterDot() + " (g)"

        cell.titleLabel.text = meteorite.name
        cell.detailLabel.text = massString
        
        return cell
    }
}

extension ResultsTableViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        animateSheetView(direction: .up)
        isEditingSearchBar = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        animateSheetView(direction: .down)
        meteoritesToShow = allSortedMeteoritesByMass
        searchBar.text = ""
        isEditingSearchBar = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        let toShow = searchText.isEmpty ? allMeteorites : allMeteorites.filter { $0.name.contains(searchText) }

        meteoritesToShow = toShow
    }

}
