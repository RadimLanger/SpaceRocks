//
//  DetailTableViewCell.swift
//  Space Rocks
//
//  Created by Radim Langer on 08/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0.9
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: label.font.fontName, size: 14)
        label.alpha = 0.9
        label.backgroundColor = .clear
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addAutolayoutSubviews(titleLabel, detailLabel)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupConstraints()
    }
    

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    private func setupConstraints() {

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor, constant: padding),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),

            detailLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
            ])
    }
}
