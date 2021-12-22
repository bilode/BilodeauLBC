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
    
    init(with viewModel: OfferDetailsViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        self.overrideUserInterfaceStyle = .light
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Views
}
