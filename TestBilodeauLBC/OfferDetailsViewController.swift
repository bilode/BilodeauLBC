//
//  OfferDetailsViewController.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import UIKit

class OfferDetailsViewController: UIViewController {
    
    let viewModel: OfferDetailsViewModel
    
    init(with viewModel: OfferDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
