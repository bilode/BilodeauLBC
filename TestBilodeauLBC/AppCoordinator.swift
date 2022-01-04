//
//  AppCoordinator.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation
import UIKit

class AppCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.presentOffersViewController()
    }
    
}

extension AppCoordinator: OffersViewControllerDelegate {
    
    private func presentOffersViewController() {
        let vc = OffersViewController(with: OffersViewModel())
        
        vc.delegate = self
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func didSelectOffer(_ offer: Offer, ofCategory category: Category) {
        let viewModel = OfferDetailsViewModel(from: offer, ofCategory: category)
        
        self.presentOfferDetails(withModel: viewModel)
    }
}

extension AppCoordinator: OfferDetailsViewControllerDelegate {
    
    private func presentOfferDetails(withModel model: OfferDetailsViewModel) {
        
        let vc = OfferDetailsViewController(with: model)
        vc.delegate = self
        
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    
    func didTapCloseButton() {
        self.navigationController.popViewController(animated: true)
    }
}
