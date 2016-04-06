//
//  ProductsViewController.swift
//  mvvmtest
//
//  Created by Nahuel Marisi on 2016-04-05.
//  Copyright © 2016 TechBrewers. All rights reserved.
//

import UIKit
import ReactiveCocoa
import enum Result.NoError

class ProductsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
   
    var viewModel: ProductsTableViewModel?
    var cellViewModels = MutableProperty([ProductCellViewModel]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = ProductsTableViewModel(dataProvider: TestProductDataProvider())
        guard let vm = viewModel else {
            return
        }
        
        // we use flatmap error to remove NSError and get a SignalProducer with NoError
        // This is neccesarry to bind it to the property
        let signalProducerWithoutError = vm.productCellViewModels.flatMapError { _ in
            return SignalProducer<[ProductCellViewModel], NoError>.empty
        }
        
        // Bind CellViewModels to our signal producer, any value will get updated
        cellViewModels <~ signalProducerWithoutError
        
        // observer cellViewModel and reload data when it changes
        cellViewModels.producer.startWithNext { _ in
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - UITableViewDatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellViewModels.value.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductTableViewCell))
        as! ProductTableViewCell
        
            cell.configure(cellViewModels.value[indexPath.row])
       
        // TODO: Configure Cell
        return cell
        
    }

   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
