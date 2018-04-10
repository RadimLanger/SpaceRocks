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

    var meteorites = [Meteorite]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            scrollableContentView = tableView
        }
    }

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
}

extension ResultsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedMeteorite = meteorites[indexPath.row]

        animateSheetView(direction: .bottomHiddden)
        delegate?.tableViewControllerDidSelectMeteorite(self, selectedMeteorite)
    }

}

extension ResultsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meteorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier = String(describing: MeteorTableViewCell.self)
        let meteorite = meteorites[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? MeteorTableViewCell ??
                    MeteorTableViewCell()

        cell.titleLabel.text = meteorite.name
        cell.detailLabel.text = (meteorite.mass ?? "") + " (g)"

        return cell
    }
}
