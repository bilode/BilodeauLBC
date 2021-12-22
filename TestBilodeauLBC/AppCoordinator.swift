//
//  AppCoordinator.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation
import UIKit

class AppCoordinator {
    
    let navigationController: UINavigationController
    
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
        
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    func didSelectOffer(_ offer: Offer) {
        let viewModel = OfferDetailsViewModel(from: offer)
    }
}
