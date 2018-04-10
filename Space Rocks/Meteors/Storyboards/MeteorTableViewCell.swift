//
//  MeteorTableViewCell.swift
//  Space Rocks
//
//  Created by Radim Langer on 07/04/2018.
//  Copyright © 2018 Radim Langer. All rights reserved.
//

import UIKit

final class MeteorTableViewCell: UITableViewCell {

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
        label.backgroundColor = .clear
        label.alpha = 0.9
        label.textColor = .white
        return label
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addAutolayoutSubviews(titleLabel, detailLabel)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.contentView.backgroundColor = highlighted ? UIColor.white.withAlphaComponent(0.2) : .clear
        }
    }

    private func setupConstraints() {

        let padding: CGFloat = 10

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),

            detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
            detailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            detailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])

    }
}
