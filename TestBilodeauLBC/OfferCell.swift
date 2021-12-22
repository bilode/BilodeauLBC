//
//  OfferCell.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 21/12/2021.
//

import UIKit
import Combine

class OfferCell: UICollectionViewCell {
    
    var subscriptions: Set<AnyCancellable> = []
    
    public var data: OfferCellData? {
        didSet {
            self.fillData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // MARK: - Subviews
    let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "placeholder")
        
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .natural
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .natural
        label.font = .boldSystemFont(ofSize: 15.0)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .natural
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let urgencyLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 15.0)
        label.text = "Urgent"
        label.textAlignment = .center
        label.backgroundColor = .white
        
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.red.cgColor
        label.layer.masksToBounds = true
        
        label.isHidden = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupSubviews() {
        self.addSubview(self.imageView)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.priceLabel)
        self.addSubview(self.categoryLabel)
        self.addSubview(self.urgencyLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6),
            self.imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        self.descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
            self.descriptionLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        self.priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        self.priceLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor),
            self.priceLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.priceLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        ])
        
        self.categoryLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        self.categoryLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor),
            self.categoryLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.categoryLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            // Ugly but greaterThanOrEqual doesn't seem to work and I couldn't figure out why
            self.categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            self.urgencyLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 8),
            self.urgencyLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 8),
            self.urgencyLabel.heightAnchor.constraint(equalToConstant: 20),
            self.urgencyLabel.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func fillData() {
        guard let data = self.data else { return }
        
        self.descriptionLabel.text = data.description
        self.priceLabel.text = data.price
        self.categoryLabel.text = data.category
        self.urgencyLabel.isHidden = !data.isUrgent
        
        self.imageView.image = UIImage(named: "placeholder")
        
        if let thumbURL = data.thumbURL {
            APIClient.downloadImage(url: thumbURL).sink { _ in
                
            } receiveValue: { [weak self] data in
                self?.imageView.image = UIImage(data: data)
            }
            .store(in: &self.subscriptions)
        }
    }
    
    func cancelDownload() {
        self.subscriptions.forEach { $0.cancel() }
    }
}
