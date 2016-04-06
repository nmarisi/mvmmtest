//
//  ProductTableViewCell.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-03-20.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    func configure(viewModel: ProductCellViewModel) {
        
        productTitle.text = viewModel.title
        descriptionLabel.text = viewModel.description
        priceLabel.text = String(viewModel.price)
    }
    
    

}
