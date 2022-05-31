//
//  DetailsCell.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import UIKit

class OrderCell: UICollectionViewCell {
    
    lazy var startLabel: UILabel = {
        let startLabel = UILabel()
        startLabel.font = UIFont.boldSystemFont(ofSize: 17)
        startLabel.numberOfLines = 2
        startLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        endLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return startLabel
    }()
    
    lazy var endLabel: UILabel = {
        let endLabel = UILabel()
        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.numberOfLines = 2
        endLabel.font = UIFont.boldSystemFont(ofSize: 17)
        endLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        endLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return endLabel
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont.systemFont(ofSize: 17)
        dateLabel.numberOfLines = 1
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        return dateLabel
    }()
    
    lazy var priceLabel: UILabel = {
        var priceLabel = UILabel()
        priceLabel.font = UIFont.systemFont(ofSize: 17)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return priceLabel
    }()
        
    var viewModel: DetailsCellViewModelProtocol? {
        didSet {
            self.loadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(startLabel)
        contentView.addSubview(endLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func loadData() {
        
        startLabel.text = viewModel?.startAddress
        endLabel.text = viewModel?.endAddress
        dateLabel.text = viewModel?.date
        priceLabel.text = viewModel?.price

    }
    
    func setupConstraints() {

        NSLayoutConstraint.activate([
            
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            priceLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            priceLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16),
            
            dateLabel.leftAnchor.constraint(equalTo: priceLabel.leftAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -8),
            dateLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16),
            
            startLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            startLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            startLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16),
            
            endLabel.leftAnchor.constraint(equalTo: startLabel.leftAnchor),
            endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            endLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -16),
            endLabel.bottomAnchor.constraint(lessThanOrEqualTo: dateLabel.topAnchor, constant: -8)
            
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        startLabel.text = ""
        endLabel.text = ""
        priceLabel.text = ""
        dateLabel.text = ""
    }

}
