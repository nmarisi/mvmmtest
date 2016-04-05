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
    
    // Inputs
    //let newDummyProductObserver: Observer<Void, NoError>
    
    // Change this to somewhere where it's not an instance property
    // http://stackoverflow.com/questions/30131492/how-to-implement-a-basic-uitextfield-input-uibutton-action-scenario-using-reac/30189155#30189155
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/2000
    
    lazy var buttonAction = Action<Bool, Void, NoError>(enabledIf: ConstantProperty(true)) { value in
        print("test action before returning signal producer")
        return SignalProducer<Void, NoError> { observer, _ in
        print("test action after returning signal producer")
            observer.sendCompleted()
        }
    }
    
    
    private let dataProvider: ProductDataProviderType
    
    private var products: MutableProperty<[Product]>
    private let productsObserver = Observer<[Product], NSError>()
    
    // Outputs 
    var productCellViewModels: SignalProducer<[ProductCellViewModel], NSError>
    
    init(dataProvider: ProductDataProviderType) {
        
        self.dataProvider = dataProvider
        self.products = MutableProperty([Product]())
        
        let signalProducer = dataProvider.fetchProducts()
       
        // As far as i can see this and 2// are equal
        productCellViewModels =
        signalProducer.flatMap(FlattenStrategy.Latest) { (products) -> SignalProducer<[ProductCellViewModel], NSError> in
            
            let viewModels = products.map({ product -> ProductCellViewModel in
                return ProductCellViewModel(title: product.title, description: product.description, price: product.price)
            })
            
            return SignalProducer<[ProductCellViewModel], NSError>(value: viewModels)
        }
        
        // Equal to above?
        productCellViewModels = signalProducer.map { products -> [ProductCellViewModel] in
           
            return products.map({ product -> ProductCellViewModel in
                return ProductCellViewModel(title: product.title, description: product.description, price: product.price)
            })
        }
        

        /*
        
        // Maybe it ought to be a pipe?
        let (newDummyProductSignal, newDummyProductObserver) = SignalProducer<Void, NoError>.buffer(1)
        self.newDummyProductObserver = newDummyProductObserver
        
        newDummyProductSignal
            .on()
            .flatMap(FlattenStrategy.Latest) { (Void) -> SignalProducer<Void, NoError> in
                //print("adding new item to data provider")
                
                // Return expects a signal producer, so maybe a newProductSignal is not the best way to 
                // add a new event
        }
        */
    }
    
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