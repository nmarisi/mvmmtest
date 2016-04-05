//
//  ProductCellViewModel.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-04-05.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import Foundation

struct ProductCellViewModel {
    let title: String
    let description: String
    let price: Float
    
    init(title: String, description: String, price: Float) {
        self.title = title
        self.description = description
        self.price = price
    }
}