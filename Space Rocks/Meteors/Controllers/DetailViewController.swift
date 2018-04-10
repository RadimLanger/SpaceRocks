//
//  DetailViewController.swift
//  Space Rocks
//
//  Created by Radim Langer on 08/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func detailViewControllerDidTapDismissButton(_ controller: DetailViewController)
}

final class DetailViewController: ScrollableSheetViewController, DateComponentsAccessing {

    weak var delegate: DetailViewControllerDelegate?

    private enum CellType {
        case fallInfo(String)
        case fallYearDate(String)
        case id(String)
        case longitudeAndLatitude(String)
        case mass(String)
        case name(String)
        case recClass(String)

        var titleText: String {
            switch self {
                case .fallInfo:              return "Fall Info:"
                case .fallYearDate:          return "Fall year date:"
                case .id:                    return "ID:"
                case .longitudeAndLatitude:  return "Coordinates:"
                case .mass:                  return "Mass:"
                case .name:                  return "Name:"
                case .recClass:              return "Class:"
            }
        }
        var detailText: String {
            switch self {
                case let .fallInfo(detail):             return detail
                case let .fallYearDate(detail):         return detail
                case let .id(detail):                   return detail
                case let .longitudeAndLatitude(detail): return detail
                case let .mass(detail):                 return detail
                case let .name(detail):                 return detail
                case let .recClass(detail):             return detail
            }
        }
    }

    private var cellsConfiguration = [CellType]()

    var meteorite: Meteorite? {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet var tableView: UITableView! {
        didSet {
            scrollableContentView = tableView
        }
    }

    @IBAction func dismissButton(_ sender: UIButton) {
        delegate?.detailViewControllerDidTapDismissButton(self)
        animateSheetView(direction: .bottomHiddden)
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        let identifier = String(describing: DetailTableViewCell.self)

        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: identifier)
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBlurEffectView()
    }
}

extension DetailViewController: UITableViewDataSource {

    private func numberOfRows(for meteorite: Meteorite) -> Int {

        return 2
    }

    private func setupCells() {
        guard let meteorite = meteorite else { return }

        cellsConfiguration = []

        if let fallInfo = meteorite.fallInfo {
            cellsConfiguration.append(.fallInfo(fallInfo))
        }
        if let mass = meteorite.mass {
            cellsConfiguration.append(.mass(mass))
        }
        if let name = meteorite.name {
            cellsConfiguration.append(.name(name))
        }
        if let recClass = meteorite.recClass {
            cellsConfiguration.append(.recClass(recClass))
        }

        if let fallDate = meteorite.fallYearDate {
            dateFormatter.dateFormat = "yyyy"
            let stringFallDate = dateFormatter.string(from: fallDate)

            cellsConfiguration.append(.fallYearDate(stringFallDate))
        }

        cellsConfiguration.append(.id(String(meteorite.id)))

        if meteorite.latitude != 0.0 && meteorite.longitude != 0.0 {
            let latitude = meteorite.latitude.rounded(toPlaces: 3)
            let longitude = meteorite.longitude.rounded(toPlaces: 3)

            cellsConfiguration.append(.longitudeAndLatitude("\(latitude), \(longitude)"))
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        setupCells()

        return cellsConfiguration.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = String(describing: DetailTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? DetailTableViewCell
                    ?? DetailTableViewCell()

        let config = cellsConfiguration[indexPath.row]

        cell.titleLabel.text = config.titleText
        cell.detailLabel.text = config.detailText

        return cell
    }
}
