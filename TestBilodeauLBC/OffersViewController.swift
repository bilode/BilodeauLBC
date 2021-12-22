//
//  OffersViewController.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import UIKit
import Combine

protocol OffersViewControllerDelegate: AnyObject {
    func didSelectOffer(_: Offer)
}

class OffersViewController: UIViewController {

    let viewModel: OffersViewModel
    
    private var subscriptions = Set<AnyCancellable>()
    
    // Views
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryPickerView: UILabel = {
        let label = UILabel()
        
        label.text = "Categories"
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        
        label.layer.cornerRadius = 15
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.masksToBounds = true
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryPickerTapped))
//
//        label.addGestureRecognizer(tapGesture)
//        label.isUserInteractionEnabled = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowIconView: UIImageView = {
        let iconView = UIImageView()
        
        iconView.image = UIImage(named: "bottom-arrow-icon")
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "delete-icon"), for: .normal)
        button.addTarget(self, action: #selector(filterDeletionButtonPressed(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var offersCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        collectionView.register(OfferCell.self, forCellWithReuseIdentifier: "OfferCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action:
                                                    #selector(handleRefreshControl),
                                                 for: .valueChanged)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        
        indicator.hidesWhenStopped = true
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.bind()
        self.setupConstraints()
        self.setCategoryPickerTapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.fetchAll()
    }
    
    // MARK: - Initializers

    init(with viewModel: OffersViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.subscriptions.forEach { $0.cancel() }
    }
    
    private func setCategoryPickerTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(categoryPickerTapped))
        
        self.categoryPickerView.addGestureRecognizer(tapGesture)
        self.categoryPickerView.isUserInteractionEnabled = true
    }
    
    // MARK: - Binding
    
    private func bind() {
        
        self.viewModel.$categories.sink { categories in
            print("categories, count = \(categories.count)")
        }.store(in: &self.subscriptions)
        
        self.viewModel.$dataSource.sink { [weak self] offers in
            print("offers: count = \(offers.count)")
            self?.offersCollectionView.reloadData()
        }.store(in: &self.subscriptions)
        
        self.viewModel.$isLoading.sink { isLoading in
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
                self.offersCollectionView.refreshControl?.endRefreshing()
            }
        }.store(in: &self.subscriptions)
        
        self.viewModel.$categoryFilter.sink { [weak self] filter in
            
            if let filter = filter {
                self?.filterLabel.text = filter.name
            }
            
            self?.filterLabel.isHidden = (filter == nil)
        }.store(in: &self.subscriptions)
    }
    
    // MARK: - Constraints
    
    func setupConstraints() {
        
        self.view.addSubview(self.categoryPickerView)
        NSLayoutConstraint.activate([
            self.categoryPickerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20.0),
            self.categoryPickerView.widthAnchor.constraint(equalToConstant: 150),
            self.categoryPickerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.categoryPickerView.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        self.categoryPickerView.addSubview(self.arrowIconView)
        NSLayoutConstraint.activate([
            self.arrowIconView.centerYAnchor.constraint(equalTo: self.categoryPickerView.centerYAnchor),
            self.arrowIconView.widthAnchor.constraint(equalToConstant: 20.0),
            self.arrowIconView.heightAnchor.constraint(equalToConstant: 20.0),
            self.arrowIconView.trailingAnchor.constraint(equalTo: self.categoryPickerView.trailingAnchor, constant: -10)
        ])
        
        self.view.addSubview(self.filterLabel)
        NSLayoutConstraint.activate([
            self.filterLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20.0),
            self.filterLabel.trailingAnchor.constraint(greaterThanOrEqualTo: self.categoryPickerView.leadingAnchor, constant: 15.0),
            self.filterLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.filterLabel.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        self.view.addSubview(self.offersCollectionView)
        NSLayoutConstraint.activate([
            self.offersCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.offersCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.offersCollectionView.topAnchor.constraint(equalTo: self.categoryPickerView.bottomAnchor, constant: 15),
            self.offersCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        self.view.addSubview(self.activityIndicator)
        NSLayoutConstraint.activate([
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 75.0),
            self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.offersCollectionView.centerYAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc func handleRefreshControl() {
        
        self.viewModel.refreshControlDidTrigger()
    }
    
    @objc func filterDeletionButtonPressed(_ sender: UIButton!) {
        
        viewModel.filterDeletionButtonPressed()
    }
    
    @objc func categoryPickerTapped() {
        
    }
}

 
// MARK: - UICollectionViewDelegateFlowLayout / UICollectionViewDataSource

extension OffersViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData = viewModel.dataForCell(atIndex: indexPath.row)
        
        if let offerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OfferCell", for: indexPath) as? OfferCell {
            
            offerCell.data = cellData
            
            return offerCell
        }
        
        return OfferCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = (collectionView.bounds.width - 30) / 2
        
        return CGSize(width: width, height: 300.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? OfferCell {
            viewModel.cellDidDisappear(cell)
        }
    }
}
