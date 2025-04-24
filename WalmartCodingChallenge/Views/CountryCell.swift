//
//  CountryCell.swift
//  WalmartCodingChallenge
//
//  Created by Sahil ChowKekar on 4/23/25.
//

import UIKit

// Custom table view cell with light gray background and rounded corners
final class CountryCell: UITableViewCell {

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let trailingLabel = UILabel()
    private let backgroundCard = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Sets up the layout, styling, and constraints for subviews
    private func setupUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        backgroundCard.backgroundColor = .systemGray6
        backgroundCard.layer.cornerRadius = 12
        backgroundCard.layer.masksToBounds = true
        backgroundCard.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.textColor = .label

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .secondaryLabel

        trailingLabel.font = .systemFont(ofSize: 14)
        trailingLabel.textColor = .secondaryLabel
        trailingLabel.setContentHuggingPriority(.required, for: .horizontal)

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2

        let horizontalStack = UIStackView(arrangedSubviews: [textStack, trailingLabel])
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.spacing = 12
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        backgroundCard.addSubview(horizontalStack)
        contentView.addSubview(backgroundCard)

        NSLayoutConstraint.activate([
            backgroundCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            backgroundCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            backgroundCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            backgroundCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            horizontalStack.topAnchor.constraint(equalTo: backgroundCard.topAnchor, constant: 12),
            horizontalStack.bottomAnchor.constraint(equalTo: backgroundCard.bottomAnchor, constant: -12),
            horizontalStack.leadingAnchor.constraint(equalTo: backgroundCard.leadingAnchor, constant: 12),
            horizontalStack.trailingAnchor.constraint(equalTo: backgroundCard.trailingAnchor, constant: -12)
        ])
    }

    // Populates the cell UI with country data
    func configure(with country: Country) {
        let name = country.name ?? "Unknown"
        let region = country.region ?? "N/A"
        titleLabel.text = "\(name), \(region)"
        subtitleLabel.text = country.capital ?? "N/A"
        trailingLabel.text = country.code ?? "-"
        self.accessibilityLabel = "Country Name is \(country.name ?? "" )and capital is \(country.capital ?? "")"
    }
}
