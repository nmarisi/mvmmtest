//
//  ViewController.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-03-19.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    
    var viewModel: ProductsViewModel!
    var buttonCocoaAction: CocoaAction!
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let productDataProvider = TestProductDataProvider()
        viewModel = ProductsTableViewModel(dataProvider: productDataProvider)
        
       //switch.addTarget(cocoaAction, action: CocoaAction.selector, forControlEvents: .ValueChanged)
        
        buttonCocoaAction = CocoaAction(viewModel.buttonAction, {
            value in
            
            //let button = value as! UIButton
            return true
        })
        
        testButton.addTarget(buttonCocoaAction, action: CocoaAction.selector, forControlEvents: .TouchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

