//
//  OffersViewModel.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 17/12/2021.
//

import Foundation
import Combine

struct OffersSorter {
    
    private let comparator: (Offer, Offer) -> Bool = { first, second in
        if first.isUrgent != second.isUrgent {
            return first.isUrgent
        }
        
        return first.creationDate > second.creationDate
    }
    
    func sort(_ offers: [Offer]) -> [Offer] {
        return offers.sorted(by: self.comparator)
    }
}


class OffersViewModel: ObservableObject {
    
    let offersRepository: OffersRepository
    let categoriesRepository: CategoriesRepository
    let offersSorter: OffersSorter

    @Published private(set) var categories: [Category]
    @Published private(set) var dataSource: [Offer]
    @Published private(set) var isLoading: Bool
    @Published private(set) var categoryFilter: Category? {
        didSet {
            self.setupDataSource(from: self.offers)
        }
    }
    
    private var offers: [Offer] {
        didSet {
            self.setupDataSource(from: self.offers)
        }
    }
    
    var subscriptions: Set<AnyCancellable> = []
    
    convenience init() {
        self.init(with: OffersRepository(apiClient: APIClient()), CategoriesRepository(apiClient: APIClient()))
    }
    
    init(with offersRepository: OffersRepository, _ categoriesRepository: CategoriesRepository) {
        self.offersRepository = offersRepository
        self.categoriesRepository = categoriesRepository
        self.categories = []
        self.dataSource = []
        self.isLoading = false
        self.offers = []
        
        self.offersSorter = OffersSorter()
    }
    
    //MARK: - Network
    
    public func fetchAll() {
        
        self.isLoading = true
        Publishers.Zip(self.offersRepository.getOffers(),
                       self.categoriesRepository.getCategories())
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error fetching offers: \(error.localizedDescription)")
                case .finished:
                    self.isLoading = false
                }} receiveValue: { offers, categories in
                    self.categories = categories
                    self.offers = offers
                }
                .store(in: &self.subscriptions)
    }
    
    // MARK: - Data
    
    private func setupDataSource(from offers: [Offer]) {
        
        let filteredOffers: [Offer] = {
            if let filter = self.categoryFilter {
                return offers.filter { $0.categoryId == filter.id }
            } else {
                return offers
            }
        }()
        
        print("setup data source")
        
        self.dataSource = self.offersSorter.sort(filteredOffers)
    }
    
    private func refreshData() {
        self.fetchAll()
    }
    
    // MARK: - View events
    
    func didSelectCategoryFilter(_ category: Category) {
        self.categoryFilter = category
    }
    
    // This prevents reused cells from stacking up multiple datatasks from unrelated offers
    // Note that glitches still remain with the image loading when network conditions are poor
    func cellDidDisappear(_ cell: OfferCell) {
        cell.cancelDownload()
    }
    
    func refreshControlDidTrigger() {
        self.refreshData()
    }
    
    func filterDeletionButtonPressed() {
        self.categoryFilter = nil
    }
    
    // MARK: - Data source

    func dataForCell(atIndex index: Int) -> OfferCellData? {
        
        guard index < self.dataSource.count else {
            return nil
        }
        
        let offer = self.dataSource[index]
        let offerCategory = self.categories.first { $0.id == offer.categoryId }
        
        return OfferCellData(thumbURL: offer.imagesURL.thumb,
                             description: offer.description,
                             price: String(format: "%.2f €", offer.price),
                             category: offerCategory?.name ?? "",
                             isUrgent: offer.isUrgent)
    }
    
    func numberOfItems() -> Int {
        return self.dataSource.count
    }
}
