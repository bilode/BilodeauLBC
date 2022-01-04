//
//  OfferDetailsViewModel.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation
import Combine

class OfferDetailsViewModel {
    
    let categoryName: String
    let creationDate: String
    let description: String
    let urgencyText: String?
    let price: String?
    @Published var imageData: Data?
    
    private let imageURL: String?
    
    var subscriptions: Set<AnyCancellable> = []
    
    init(from offer: Offer, ofCategory category: Category) {
        
        self.categoryName = category.name
        self.description = offer.description
        self.creationDate = Self.formatter.string(from: offer.creationDate)
        self.urgencyText = offer.isUrgent ? "Urgent" : nil
        self.price = String(format: "%.2f €", offer.price)
        self.imageURL = offer.imagesURL.thumb
    }
    
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.doesRelativeDateFormatting = true
        
        return formatter
    }()
    
    private func downloadImage() {
        guard let stringURL = self.imageURL else {
            return
        }
        
        APIClient.downloadImage(url: stringURL).sink { _ in
            
        } receiveValue: { data in
            self.imageData = data
        }.store(in: &self.subscriptions)
    }
    
    // MARK: - View events
    
    func viewDidAppear() {
        self.downloadImage()
    }
}
