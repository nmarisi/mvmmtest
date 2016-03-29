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

protocol ProductsViewModel: class {
    var buttonAction: Action<Bool, Void, NoError> { get }
    
    
}
    
final class ProductsTableViewModel: ProductsViewModel {
    
    // Inputs
    //let newDummyProductObserver: Observer<Void, NoError>
    
    
    let buttonAction = Action<Bool, Void, NoError> { value in
        print("test action before returning signal producer")
        return SignalProducer<Void, NoError> { observer, _ in
        print("test action after returning signal producer")
            observer.sendCompleted()
        }
    }
    
    
    private let dataProvider: ProductDataProviderType
    
    init(dataProvider: ProductDataProviderType) {
        
        self.dataProvider = dataProvider
        
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
    
    
}