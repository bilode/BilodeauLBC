//
//  OffersViewController.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import UIKit

protocol OffersViewControllerDelegate: AnyObject {
    func didSelectOffer(_: Offer)
}

class OffersViewController: UIViewController {

    let viewModel: OffersViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.fetchOffers()
    }

    init(with viewModel: OffersViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

