//
//  OrderDetailController.swift
//  taxi
//
//  Created by Viacheslav Yakymenko on 24.05.2022.
//

import UIKit


class OrderDetailController: UIViewController {
    var viewModel: OrderDetailViewModelProtocol?
    
    let containerView = UIView()
    var vehicleImage: UIImage?
    
    lazy var addressesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var vehicleImageView: UIImageView = { () -> UIImageView in
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var startLabel: UILabel = {
        let startLabel = UILabel()
        startLabel.attributedText = viewModel?.departureSpot
        startLabel.numberOfLines = 0
        startLabel.translatesAutoresizingMaskIntoConstraints = false

        return startLabel
    }()
    
    lazy var endLabel: UILabel = {
        let endLabel = UILabel()
        endLabel.attributedText = viewModel?.destination

        endLabel.translatesAutoresizingMaskIntoConstraints = false
        endLabel.numberOfLines = 0
        
        return endLabel
    }()
    
    lazy var timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = viewModel?.time

        timeLabel.font = UIFont.systemFont(ofSize: 17)
        timeLabel.numberOfLines = 1
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        return timeLabel
    }()
    
    lazy var priceLabel: UILabel = {
        var priceLabel = UILabel()
        priceLabel.text = viewModel?.price
        priceLabel.font = UIFont.boldSystemFont(ofSize: 20)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return priceLabel
    }()
    
    lazy var vehicleDataLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.attributedText = viewModel?.vehicle
        return label
    }()
    
    lazy var driverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = viewModel?.driver
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Поездка"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.addSubview(containerView)
        view.addSubview(vehicleImageView)
        addressesView.addSubview(startLabel)
        addressesView.addSubview(endLabel)
        view.addSubview(addressesView)
        view.addSubview(timeLabel)
        view.addSubview(priceLabel)
        view.addSubview(vehicleDataLabel)
        view.addSubview(driverLabel)
        
        viewModel?.fetchImage(completion: { [weak self] image in
            DispatchQueue.main.async {
                self?.vehicleImage = image
                self?.view.setNeedsLayout()
            }
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraints()
    }
    
    func setupConstraints() {

        let guide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            
            addressesView.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: 16),
            addressesView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
            addressesView.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -16),
            
            startLabel.leftAnchor.constraint(equalTo: addressesView.leftAnchor, constant: 8),
            startLabel.topAnchor.constraint(equalTo: addressesView.topAnchor, constant: 8),
            startLabel.rightAnchor.constraint(lessThanOrEqualTo: addressesView.rightAnchor, constant: -8),

            endLabel.leftAnchor.constraint(equalTo: startLabel.leftAnchor),
            endLabel.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 8),
            endLabel.rightAnchor.constraint(lessThanOrEqualTo: addressesView.rightAnchor, constant: -8),
            
            addressesView.bottomAnchor.constraint(equalTo: endLabel.bottomAnchor, constant: 8),
            
            timeLabel.topAnchor.constraint(equalTo: addressesView.bottomAnchor, constant: 16),
            timeLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),

            priceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16),
            priceLabel.centerXAnchor.constraint(equalTo: guide.centerXAnchor),

            vehicleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vehicleImageView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16),

        ])
        
        if let image = vehicleImage {
            let ratio: CGFloat = image.size.width / image.size.height
            vehicleImageView.translatesAutoresizingMaskIntoConstraints = false
            vehicleImageView.image = image
            
            NSLayoutConstraint.activate([
                vehicleImageView.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor, constant: 16),
                vehicleImageView.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -16),
                vehicleImageView.heightAnchor.constraint(equalTo: vehicleImageView.widthAnchor, multiplier: 1/ratio)
            ])
        } else {
            NSLayoutConstraint.activate([
                vehicleImageView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
                vehicleImageView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),
                vehicleImageView.heightAnchor.constraint(equalToConstant: 100),
                vehicleImageView.widthAnchor.constraint(lessThanOrEqualTo: guide.widthAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            
            vehicleDataLabel.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            vehicleDataLabel.topAnchor.constraint(equalTo: vehicleImageView.bottomAnchor, constant: 16),
            vehicleDataLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -16),
            
            driverLabel.topAnchor.constraint(equalTo: vehicleDataLabel.bottomAnchor, constant: 16),
            driverLabel.leadingAnchor.constraint(equalTo: startLabel.leadingAnchor),
            driverLabel.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -16),
        ])
    }

}
