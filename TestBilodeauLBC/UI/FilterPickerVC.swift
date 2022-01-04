//
//  FilterPicker.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 22/12/2021.
//

import UIKit

protocol FilterPickerVCDelegate: AnyObject {
    func didPickCategory(_: Category?)
}

struct FilterPickerVCData {
    let categories: [Category]
}


class FilterPickerVC: UIViewController {
    
    var maskView: UIView?
    var data: FilterPickerVCData
    
    weak var delegate: FilterPickerVCDelegate?
    
    // MARK: - Views
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.setImage(UIImage(named: "delete-icon"), for: .normal)
        button.addTarget(self, action: #selector(closeButtonPressed(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var tableView: SelfSizingTableView = {
        let tableView = SelfSizingTableView()
        
        tableView.backgroundColor = .clear
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func roundContentViewCorners(radius: CGSize) {
        
        let path = UIBezierPath(roundedRect:self.contentView.bounds, byRoundingCorners:[.topLeft], cornerRadii: radius)
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        self.contentView.layer.mask = maskLayer
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        
        self.roundContentViewCorners(radius: CGSize(width: 35.0, height: 35.0))
    }
    
    // MARK: - Initializers
    
    init(with data: FilterPickerVCData) {
        self.data = data
        
        super.init(nibName: nil, bundle: nil)
        
        self.transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    private func setConstraints() {
        
        self.view.addSubview(self.contentView)
        NSLayoutConstraint.activate([
            self.contentView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.view.addSubview(self.closeButton)
        NSLayoutConstraint.activate([
            self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5.0),
            self.closeButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5.0),
            self.closeButton.heightAnchor.constraint(equalToConstant: 30.0),
            self.closeButton.widthAnchor.constraint(equalToConstant: 30.0),
        ])
        
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 40.0),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            self.tableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func closeButtonPressed(_: UIButton) {
        self.dismiss(animated: true) {
            self.delegate?.didPickCategory(nil)
        }
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension FilterPickerVC: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let mask = UIView(frame: presenting.view.bounds)
        
        mask.backgroundColor = UIColor.black
        mask.alpha = 0.0
        presenting.view.addSubview(mask)
        
        self.maskView = mask
        
        UIView.animate(withDuration: 0.3) {
            self.maskView!.alpha = 0.7
        }
        
        return nil
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if let mask = self.maskView {
            
            UIView.animate(withDuration: 0.3) {
                self.maskView!.alpha = 0.0
            } completion: { _ in
                mask.removeFromSuperview()
            }
        }
        
        return nil
    }
}

extension FilterPickerVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category") ?? UITableViewCell(style: .default, reuseIdentifier: "Category")
        
        cell.textLabel?.text = self.data.categories[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.dismiss(animated: true) {
            if indexPath.row < self.data.categories.count {
                self.delegate?.didPickCategory(self.data.categories[indexPath.row])
            }
        }
    }
}
