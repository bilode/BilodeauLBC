//
//  OfferDetailsViewController.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import UIKit
import Combine

protocol OfferDetailsViewControllerDelegate: AnyObject {
    func didTapCloseButton()
}

class OfferDetailsViewController: UIViewController {
    
    let viewModel: OfferDetailsViewModel
    weak var delegate: OfferDetailsViewControllerDelegate?
    
    var subscriptions: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(with viewModel: OfferDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.fillUI()
        self.bind()
        self.setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.viewDidAppear()
    }
    
    // MARK: - Views
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let urgencyLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func fillUI() {
        
        if let isUrgent = viewModel.urgencyText {
            self.urgencyLabel.text = isUrgent
        } else {
            self.urgencyLabel.isHidden = true
        }
        
        self.imageView.image = UIImage(named:"placeholder")
        self.descriptionLabel.text = viewModel.description
        self.categoryLabel.text = viewModel.categoryName
        self.dateLabel.text = viewModel.creationDate
        self.urgencyLabel.text = viewModel.urgencyText
        self.priceLabel.text = viewModel.price
    }
    
    // MARK: - Constraints
    
    private func setConstraints() {
        
        self.view.addSubview(self.imageView)
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.imageView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5)
        ])
        
        self.descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        self.view.addSubview(self.descriptionLabel)
        NSLayoutConstraint.activate([
            self.descriptionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20.0),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20.0),
        ])
        
        self.view.addSubview(self.priceLabel)
        NSLayoutConstraint.activate([
            self.priceLabel.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10.0),
            self.priceLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20.0),
        ])
        
        self.view.addSubview(self.dateLabel)
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.priceLabel.bottomAnchor, constant: 10.0),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20.0),
        ])
        
        self.view.addSubview(self.categoryLabel)
        NSLayoutConstraint.activate([
            self.categoryLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10.0),
            self.categoryLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.categoryLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.view.trailingAnchor, constant: -20.0),
            self.categoryLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -20.0),
        ])
    }
    
    // MARK: - Binding
    
    private func bind() {
        viewModel.$imageData.sink { data in
            guard let data = data else { return }
            self.imageView.image = UIImage(data: data)
        }.store(in: &self.subscriptions)
    }
}
