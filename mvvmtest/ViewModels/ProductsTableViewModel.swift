//
//  ProductsTableViewModel.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-03-20.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result
import enum Result.NoError

protocol ProductsViewModel: class {
    var buttonAction: Action<Bool, Void, NoError> { get }
    
    
}
    
final class ProductsTableViewModel: ProductsViewModel {
   private let dataProvider: ProductDataProviderType
    
    private var products: MutableProperty<[Product]>
    private let productsObserver = Observer<[Product], NSError>()
    
    // Inputs
    var buttonAction: Action<Bool, Void, NoError>
    
    // Outputs 
    var productCellViewModels: SignalProducer<[ProductCellViewModel], NSError>
    
    init(dataProvider: ProductDataProviderType) {
        
        self.dataProvider = dataProvider
        self.products = MutableProperty([Product]())
    
        buttonAction = Action<Bool, Void, NoError>() { value in
        print("test action before returning signal producer")
        return SignalProducer<Void, NoError> { observer, _ in
            dataProvider.addNewTestProduct()
        print("test action after returning signal producer")
            observer.sendNext()
            observer.sendCompleted()
        }
    }
        let signalProducer = dataProvider.fetchProducts()
        
        // We need to map a SignalProducer from Products (from the model)
        // to ProductCellViewModels
       
        // As far as i can see this and 2// are equal
        productCellViewModels =
        signalProducer.flatMap(FlattenStrategy.Latest) { (products) -> SignalProducer<[ProductCellViewModel], NSError> in
            
            
            let viewModels = products.map({ product -> ProductCellViewModel in
                return ProductCellViewModel(title: product.title, description: product.description, price: product.price)
            })
            
            return SignalProducer<[ProductCellViewModel], NSError>(value: viewModels)
        }
        
        /*
        
        
        // Equal to above?
        productCellViewModels = signalProducer.map { products -> [ProductCellViewModel] in
           
            return products.map({ product -> ProductCellViewModel in
                return ProductCellViewModel(title: product.title, description: product.description, price: product.price)
            })
        }
 
 */
        

    }
    
    
    // This is not in use as part of hte app, but just a way to test things
    func bindViewModel() {
        
        // Get signal producer
        let signalProducer = dataProvider.fetchProducts()
        // start it and update observer
        signalProducer.start(productsObserver)
        
        
        productCellViewModels = signalProducer.map { products -> [ProductCellViewModel] in
           
            return products.map({ product -> ProductCellViewModel in
                return ProductCellViewModel(title: product.title, description: product.description, price: product.price)
            })
        }

        // We need to use flatMapError to remove the NSError as mutableproperty 
        // cant be bound to a SignalProducer that emits errors
        let signalProducerWithoutError = signalProducer.flatMapError { error in
            return SignalProducer<[Product], NoError>.empty
        }
       
        // bind products property
        self.products <~ signalProducerWithoutError
        products.producer.startWithNext { _ in
            // Reload data
        }
        
    }
    
    
}