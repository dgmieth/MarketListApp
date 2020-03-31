//
//  HomeVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit
import CoreData

class HomeVC: UIViewController {

    var mainMarketsArray = [Market]()
    var dataController:DataController!
    var purchasedItemsArray = [PurchasedList]()
    //MARK:- VIEW LOADING
    override func viewDidLoad() {
//        loadData()
    }
    //MARK: - BUTTONS
    @IBAction func goToItemsMercadoVC(_ sender: Any) {
            performSegue(withIdentifier: "goToItemsMercadoVC", sender: self)
    }
    @IBAction func goToWeeklyShoppingList(_ sender: Any) {
        performSegue(withIdentifier: "goToWeeklyShoppingListVC", sender: self)
    }
    @IBAction func goToFinishedShoppingListsVC(_ sender: Any) {
        performSegue(withIdentifier: "goToFinishedListsVC", sender: self)
    }
    //MARK:- SEGUEWAYS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemsMercadoVC" {
            let destination = segue.destination as! ItemsMercadoVC
            destination.dataController = dataController
       } else if segue.identifier == "goToWeeklyShoppingListVC" {
            let destination = segue.destination as! WeeklyShoppingList
            destination.dataController = dataController
        } else if segue.identifier == "goToFinishedListsVC" {
            let destination = segue.destination as! FinishedShoppingListsVC
            destination.dataController = dataController
        }
    }
    //MARK:-CORE DATA
    func loadData(){
         let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
         fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
         if let results = try? dataController.viewContext.fetch(fetchRequest){
             mainMarketsArray = results
         }
        let fetchRequest1 = NSFetchRequest<PurchasedList>(entityName: "PurchasedList")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "boughDate", ascending: false)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            purchasedItemsArray = results
        }
    }
}
