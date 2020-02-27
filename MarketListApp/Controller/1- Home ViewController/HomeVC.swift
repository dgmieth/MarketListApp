//
//  HomeVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, updateMainItemsArray, UpdateBoughItemsArrayFromWeeklyShoppingListVC {

    
    var mainMarketsArray = [Market]()
    var purchasedItemsArray = [PurchasedItemsList]()
    
    override func viewDidLoad() {
        if mainMarketsArray.isEmpty {
            loadItems()
        }
    }
    
    func loadItems(){
        let item1 = Item(itemName: "Pao Frances")
        item1.getFormOfSale().setUnitMeasure(howItIsSold: .single)
        item1.getFormOfSale().setItemPrice(howMuchIsIt: "1,50")
        item1.getFormOfSale().setStandarWeightValue()
        item1.setAddToBuyList(changeBoolValue: true)
        item1.setItemInformation(information: "comprar mais escuros e assados")
        let item2 = Item(itemName: "Rapid 10")
        item2.getFormOfSale().setUnitMeasure(howItIsSold: .gram)
        item2.getFormOfSale().setItemPrice(howMuchIsIt: "3,33")
        item2.getFormOfSale().setStandarWeightValue()
        let item3 = Item(itemName: "Pao australiano")
        item3.getFormOfSale().setUnitMeasure(howItIsSold: .liter)
        item3.getFormOfSale().setItemPrice(howMuchIsIt: "3,45")
        item3.getFormOfSale().setStandarWeightValue()
        let item4 = Item(itemName: "Iogurte Diego")
        item4.getFormOfSale().setUnitMeasure(howItIsSold: .mililiter)
        item4.getFormOfSale().setItemPrice(howMuchIsIt: "3,45")
        item4.getFormOfSale().setStandarWeightValue()
        item4.setItemTemp(isItCold: true)
        let item5 = Item(itemName: "Manteiga")
        item5.getFormOfSale().setUnitMeasure(howItIsSold: .averageWeight)
        item5.getFormOfSale().setItemPrice(howMuchIsIt: "10,00")
        item5.getFormOfSale().setStandarWeightValue(standarWeightIs: 333.33)
        item5.setItemTemp(isItCold: true)
        let item12 = Item(itemName: "sabonete")
        let item13 = Item(itemName: "pasta de dente")
        let item14 = Item(itemName: "detergente")
        let item6 = Item(itemName: "Maca")
        let item7 = Item(itemName: "mix Salada")
        item7.setItemTemp(isItCold: true)
        let item8 = Item(itemName: "Orange")
        let item9 = Item(itemName: "Carrot")
        let item10 = Item(itemName: "Presunto")
        item10.setItemTemp(isItCold: true)
        let item11 = Item(itemName: "Queijo Chedar")
        item11.setItemTemp(isItCold: true)
        
        let sector1 = Sector(sectorName: "Padaria")
        let sector2 = Sector(sectorName: "Laticinios")
        let sector3 = Sector(sectorName: "Verduras e Frutas")
        let sector4 = Sector(sectorName: "Fiamberia")
        let sector5 = Sector(sectorName: "Higiene")
        let sector6 = Sector(sectorName: "Limpeza")
        
        let condor = Market(marketName: "Condor")
        let angeloni = Market(marketName: "Angeloni")
        
        sector1.setItem(item: item1)
        sector1.setItem(item: item2)
        sector1.setItem(item: item3)
        sector2.setItem(item: item4)
        sector2.setItem(item: item5)
        sector5.setItem(item: item12)
        sector5.setItem(item: item13)
        sector6.setItem(item: item14)
        sector3.setItem(item: item6)
        sector3.setItem(item: item7)
        sector3.setItem(item: item8)
        sector3.setItem(item: item9)
        sector4.setItem(item: item10)
        sector4.setItem(item: item11)
        
        condor.setSector(sector: sector1)
        condor.setSector(sector: sector2)
        condor.setSector(sector: sector5)
        condor.setSector(sector: sector6)
        angeloni.setSector(sector: sector3)
        angeloni.setSector(sector: sector4)

        mainMarketsArray.append(condor)
        mainMarketsArray.append(angeloni)
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
        if segue.identifier == "goToWeeklyShoppingListVC" {
            let weeklyShoppingList = segue.destination as! WeeklyShoppingList
            weeklyShoppingList.weeklyVCMarketsArray = mainMarketsArray
            weeklyShoppingList.purchasedItemsArrayWSLVC = purchasedItemsArray
            weeklyShoppingList.delegate = self
        } else if segue.identifier == "goToItemsMercadoVC" {
            let itemsMercadoVCAsDestination = segue.destination as! ItemsMercadoVC
            itemsMercadoVCAsDestination.marketsArray = mainMarketsArray
            itemsMercadoVCAsDestination.delegateHomeVC = self
        } else if segue.identifier == "goToFinishedListsVC" {
            let finishedShoppingListsVC = segue.destination as! FinishedShoppingListsVC
            finishedShoppingListsVC.purchasedItemsArrayFSLVC = purchasedItemsArray
        }
    }
    
    //MARK:- DELEGATE FUNC
    func updatingMainItemsArraySaveInHomeVC(withArray ary: [Market]) {
        mainMarketsArray = ary
    }
    func updateBoghtItemsArray(withArray ary: [PurchasedItemsList]) {
        print("called 10000123")
        purchasedItemsArray = ary
    }
}
