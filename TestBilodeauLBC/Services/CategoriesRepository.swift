//
//  CategoriesRepository.swift
//  TestBilodeauLBC
//
//  Created by Timothée Bilodeau on 20/12/2021.
//

import Foundation
import Combine

struct CategoriesRepository {
    
    let apiClient: Requestable
    private let url = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json")!
    
    func getCategories() -> AnyPublisher<[Category], Error> {
        return apiClient.make(URLRequest(url: self.url), JSONDecoder())
    }
}
