//
//  ListOfMarketsViewController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 11/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit
import CoreData

class ListOfMarketsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    
    var listOfMarkets = [Market]()
    var searchBarArray = [Market]()
    var dataController : DataController!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var marketsTableView: UITableView!
    @IBOutlet weak var newMarketBtn: UIBarButtonItem!
    var searchingOn = false
    var aryHasItems = false
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        marketsTableView.tableFooterView = UIView()
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor.black
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor.black
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        listOfMarkets = [Market]()
        searchBarArray = [Market]()
    }
}
//MARK:- TABLE VIEW
extension ListOfMarketsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aryHasItems {
            if searchingOn {
                return searchBarArray.count > 0 ? searchBarArray.count : 0
            } else {
                return listOfMarkets.count > 0 ? listOfMarkets.count : 0
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if aryHasItems {
            if searchingOn {
                let sCell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
                sCell.textLabel!.text = searchBarArray[indexPath.row].getName()
                tableView.separatorStyle = .singleLine
                return sCell
            } else {
                tableView.separatorStyle = .singleLine
                let mCell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath)
                mCell.textLabel!.text = listOfMarkets[indexPath.row].getName()
                mCell.detailTextLabel!.text = "\(listOfMarkets[indexPath.row].getSector().count) setor(es)/ \(listOfMarkets[indexPath.row].getQttOfItems()) item(s)"
                return mCell
            }
        }
        let cellOne = tableView.dequeueReusableCell(withIdentifier: "emptyArray", for: indexPath)
        tableView.separatorStyle = .none
        return cellOne
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return aryHasItems ? CGFloat(44) : CGFloat(tableView.bounds.height)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchingOn {
            var foundMatch = false
            var counter = 0
            endSearchMode()
            while foundMatch == false {
                for m in 0..<listOfMarkets.count {
                    if listOfMarkets[m] == searchBarArray[indexPath.row]{
                        foundMatch = true
                        break
                    }
                    counter += 1
                }       }
            DispatchQueue.main.async {
                tableView.selectRow(at: IndexPath(row: counter, section: 0), animated: true, scrollPosition: .middle)
            }
        } else {
            let alert = UIAlertController(title: listOfMarkets[indexPath.row].getName(), message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
                let alert2 = UIAlertController(title: "Deletar \(self.listOfMarkets[indexPath.row].getName())", message: "Você tem certeza que dseja deletar o mercado \(self.listOfMarkets[indexPath.row].getName())? Esta ação deletará o(s) setor(es)/item(s) vinculado(s) a este mercado e não poderá ser desfeita", preferredStyle: .actionSheet)
                let sim = UIAlertAction(title: "Sim", style: .destructive) { (action) in
                    let market = self.listOfMarkets[indexPath.row]
                    self.delete(item: market)
                    self.saveData()
                    self.loadData()
                    tableView.reloadData()
                }
                alert2.addAction(sim)
                alert2.addAction(UIAlertAction(title: "Não", style: .cancel, handler: nil))
                self.present(alert2, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            let edit = UIAlertAction(title: "Editar", style: .default) { (action) in
                var textfield = UITextField()
                let alert3 = UIAlertController(title: "Editar", message: "Altere ou renomeie o nome do mercado.", preferredStyle: .alert)
                let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
                    if !textfield.text!.isEmpty {
                        self.listOfMarkets[indexPath.row].setName(marketName: textfield.text!)
                        self.saveData()
                        self.loadData()
                        tableView.reloadData()
                    }
                }
                alert3.addTextField { (text) in
                    text.text = self.listOfMarkets[indexPath.row].getName()
                    textfield = text
                }
                alert3.addAction(save)
                alert3.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                self.present(alert3, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            alert.addAction(delete)
            alert.addAction(edit)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
//MARK:- BUTTON
extension ListOfMarketsViewController{
    @IBAction func newMarketPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Novo Mercado", message: "Insira o nome do novo mercado", preferredStyle: .alert)
        let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if !textField.text!.isEmpty {
                let market = Market(context: self.dataController.viewContext)
                market.setName(marketName: textField.text!)
                market.setOredringId(setAt: self.setOrderingInMarkets())
                self.saveData()
                self.loadData()
                self.marketsTableView.reloadData()
            }
        }
        alert.addTextField { (field) in
            field.placeholder = "Alterar: escreva e salve"
            textField = field
        }
        alert.addAction(save)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
//MARK:- COREDATA
extension ListOfMarketsViewController{
    func saveData(){
        do {
            try dataController.viewContext.save()
            print("saved")
        } catch { print("notSaved")     }
    }
    func loadData(){
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            listOfMarkets = results     }
        let fetchRequest1 = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            searchBarArray = results     }
        enableUserInterface()
        aryHasItems = listOfMarkets.count > 0 ? true : false
    }
    
    func delete(item: Market){
        dataController.viewContext.delete(item)
        saveData()
        loadData()
        marketsTableView.reloadData()
    }
}
//MARK:- DATA MANIPUlATION
extension ListOfMarketsViewController{
    func setOrderingInMarkets() -> Int{
        var orderedMarketsList = [Market]()
        var index = 0
        let fetchRequest = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            orderedMarketsList = results     }
        for i in 0..<orderedMarketsList.count {
            if orderedMarketsList[i].getOrderingID() != i {
                orderedMarketsList[i].setOredringId(setAt: i)
            }
            index = i
        }
        return index
    }
}
//MARK:- USER INTERFACE
extension ListOfMarketsViewController {
    func enableUserInterface(){
        searchBar.isHidden = listOfMarkets.count == 0 ? true : false
        newMarketBtn.isEnabled = searchingOn ? false : true
    }
}
//MARK:- SEARCH BAR
extension ListOfMarketsViewController{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showCanceButton()
        loadData()
        if searchText.isEmpty {
            searchBarArray = [Market]()
            marketsTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            searchBarArray = searchBarArray.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        marketsTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarArray = [Market]()
        showCanceButton()
        marketsTableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        endSearchMode()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        showCanceButton()
    }
    func showCanceButton(){
        searchingOn = true
        searchBar.showsCancelButton = true
        enableUserInterface()
        let cancel = searchBar.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = .black
        cancel.isEnabled = true
    }
    func endSearchMode(){
        DispatchQueue.main.async {
            self.searchBar.endEditing(true)
            self.searchBar.showsCancelButton = false
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
            self.searchingOn = false
            self.loadData()
            self.marketsTableView.keyboardDismissMode = .onDrag
            self.marketsTableView.reloadData()
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        marketsTableView.keyboardDismissMode = .onDrag
        searchingOn ? showCanceButton() : nil
    }
}
