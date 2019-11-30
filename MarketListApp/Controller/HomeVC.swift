//
//  HomeVC.swift
//  MarketListApp
//
//  Created by Diego Mieth on 15/09/19.
//  Copyright © 2019 dgmieth. All rights reserved.
//

import UIKit

class HomeVC: UIViewController, updateMainItemsArray {
    var mainMarketsArray = [Market]()
    
    override func viewDidLoad() {
        if mainMarketsArray.isEmpty {
            loadItems()
        }
    }
    
    func loadItems(){
        let item1 = Item(itemName: "Pao Frances", itsBrandIs: "sem marca", itIsCold: false)
        item1.getFormOfSale().setUnitMeasure(howItIsSold: .single)
        item1.getFormOfSale().setItemPrice(howMuchIsIt: "1,50")
        item1.getFormOfSale().setStandarWeightValue()
        item1.setAddToBuyList(changeBoolValue: true)
        let item2 = Item(itemName: "Rapid 10", itsBrandIs: "sem marca", itIsCold: false)
        item2.getFormOfSale().setUnitMeasure(howItIsSold: .gram)
        item2.getFormOfSale().setItemPrice(howMuchIsIt: "3,33")
        item2.getFormOfSale().setStandarWeightValue()
        let item3 = Item(itemName: "Pao australiano", itsBrandIs: "sem marca", itIsCold: false)
        item3.getFormOfSale().setUnitMeasure(howItIsSold: .liter)
        item3.getFormOfSale().setItemPrice(howMuchIsIt: "3,45")
        item3.getFormOfSale().setStandarWeightValue()
        let item4 = Item(itemName: "Iogurte Diego", itsBrandIs: "Frimesa", itIsCold: true)
        item4.getFormOfSale().setUnitMeasure(howItIsSold: .mililiter)
        item4.getFormOfSale().setItemPrice(howMuchIsIt: "3,45")
        item4.getFormOfSale().setStandarWeightValue()
        let item5 = Item(itemName: "Manteiga", itsBrandIs: "presidente", itIsCold: true)
        item5.getFormOfSale().setUnitMeasure(howItIsSold: .averageWeight)
        item5.getFormOfSale().setItemPrice(howMuchIsIt: "10,00")
        item5.getFormOfSale().setStandarWeightValue(standarWeightIs: 333.33)
        let item12 = Item(itemName: "sabonete", itsBrandIs: "Dove", itIsCold: false)
        let item13 = Item(itemName: "pasta de dente", itsBrandIs: "Colgate", itIsCold: false)
        let item14 = Item(itemName: "detergente", itsBrandIs: "Limpol", itIsCold: false)
        let item6 = Item(itemName: "Maca", itsBrandIs: "sem marca", itIsCold: false)
        let item7 = Item(itemName: "mix Salada", itsBrandIs: "Strpasoldi", itIsCold: true)
        let item8 = Item(itemName: "Orange", itsBrandIs: "sem marca", itIsCold: false)
        let item9 = Item(itemName: "Carrot", itsBrandIs: "sem marca", itIsCold: false)
        let item10 = Item(itemName: "Presunto", itsBrandIs: "sem marca", itIsCold: true)
        let item11 = Item(itemName: "Queijo Chedar", itsBrandIs: "sem marca", itIsCold: true)
        
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
    //MARK: - segue for ItmesMercadoVC
    @IBAction func goToItemsMercadoVC(_ sender: Any) {
        performSegue(withIdentifier: "goToItemsMercadoVC", sender: self)
    }
    @IBAction func goToWeeklyShoppingList(_ sender: Any) {
        performSegue(withIdentifier: "goToWeeklyShoppingListVC", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWeeklyShoppingListVC" {
            let weeklyShoppingList = segue.destination as! WeeklyShoppingList
            weeklyShoppingList.weeklyVCMarketsArray = mainMarketsArray
        } else if segue.identifier == "goToItemsMercadoVC" {
            let itemsMercadoVCAsDestination = segue.destination as! ItemsMercadoVC
            itemsMercadoVCAsDestination.marketsArray = mainMarketsArray
            itemsMercadoVCAsDestination.delegateHomeVC = self
        }
    }
    func updatingMainItemsArraySaveInHomeVC(withArray ary: [Market]) {
        mainMarketsArray = ary
    }
}
