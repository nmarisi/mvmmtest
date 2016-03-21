//
//  ProductDataProvider.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-03-20.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import Foundation
import ReactiveCocoa

// EXPLANATION:
// Make sure that you can use another data provider if neccesary
// Good for testing, changes, etc.

protocol ProductDataProviderType {
    func getListOfProducts() -> [Product]
    
    func fetchProducts() -> SignalProducer<[Product], NSError>
}

final class TestProductDataProvider: ProductDataProviderType {
    
    func getListOfProducts() -> [Product] {
        return generateDummyProduts()
    }
    
    func fetchProducts() -> SignalProducer<[Product], NSError> {
        return SignalProducer(value: generateDummyProduts())
    }
    
    private func generateDummyProduts() -> [Product] {
        
        let eggs = Product(
                  title: "Free range eggs (6)",
            description: "Organic, locally-sourced eggs",
                  price: 1.90,
              imageName: "eggs",
                   tags: nil)
        
        let asparagus = Product(
                  title: "Green asparagus bunch",
            description: "Organic, locally-sourced asparagus",
                  price: 2.10,
              imageName: "asparagus",
                   tags: nil)
        let chicken = Product(
                  title: "Chicken breats (500g)",
            description: "Organic, free range chichen breasts",
                  price: 5.40,
              imageName: "chicken",
                   tags: nil)
        let bread = Product(
                  title: "Sourdough, wholemeal loaf (400g)",
            description: "Freshly baked sourdough bread",
                  price: 1.25,
              imageName: "bread",
                   tags: nil)
        
        
        return [eggs, asparagus, chicken, bread]
       
        
        
        
        
    }
}