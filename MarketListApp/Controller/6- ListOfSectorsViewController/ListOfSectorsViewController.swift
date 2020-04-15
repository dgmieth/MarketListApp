//
//  ListOfSectorsViewController.swift
//  MarketListApp
//
//  Created by Diego Mieth on 11/04/20.
//  Copyright © 2020 dgmieth. All rights reserved.
//

import UIKit
import CoreData

class ListOfSectorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var dataController : DataController!
    var marketsArray : [Market]?
    var sectorsArray = [Sector]()
    var searchBarArray = [Sector]()
    var searchingOn = false
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sectorsTableView: UITableView!
    @IBOutlet weak var newSectorBtn: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectorsTableView.tableFooterView = UIView()
        sectorsTableView.separatorColor = .black
        
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
        sectorsArray = [Sector]()
        searchBarArray = [Sector]()
    }
}
//MARK:- TABLE VIEW
extension ListOfSectorsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchingOn {    return searchBarArray.count    }
        if marketsArray == nil { return 1 }
        return sectorsArray.count > 0 ? sectorsArray.count : 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchingOn {
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "sectorSearchCell", for: indexPath)
            searchCell.textLabel!.text = searchBarArray[indexPath.row].getName()
            return searchCell
        }
        if marketsArray == nil {
            tableView.separatorStyle = .none
            return tableView.dequeueReusableCell(withIdentifier: "emptyMarketsCell", for: indexPath)
        }
        if sectorsArray.count == 0 {
            tableView.separatorStyle = .none
            return tableView.dequeueReusableCell(withIdentifier: "noSectors", for: indexPath)
        }
        tableView.separatorStyle = .singleLine
        let sCell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath)
        sCell.textLabel!.text = sectorsArray[indexPath.row].getName()
        sCell.detailTextLabel!.text = "\(sectorsArray[indexPath.row].market!.getName()) / \(sectorsArray[indexPath.row].getQttOfItems()) item(s)"
        return sCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sectorsArray.count > 0 ? CGFloat(44) : tableView.bounds.height
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchingOn {
            var foundMatch = false
            var counter = 0
            endSearchMode()
            while foundMatch == false {
                for s in 0..<sectorsArray.count {
                    if sectorsArray[s] == searchBarArray[indexPath.row]{
                        foundMatch = true
                        break
                    }
                    counter += 1
                }   }
            DispatchQueue.main.async {
                tableView.selectRow(at: IndexPath(row: counter, section: 0), animated: true, scrollPosition: .middle)
            }
        } else {
            let alert = UIAlertController(title: sectorsArray[indexPath.row].getName(), message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { (delete) in
                let alert2 = UIAlertController(title: "Deletar \(self.sectorsArray[indexPath.row].getName())", message: "Você tem certeza que dseja deletar o setor \(self.sectorsArray[indexPath.row].getName()) do \(self.sectorsArray[indexPath.row].market!.getName())? Esta ação deletará o(s) item(s) vinculado(s) a este mercado e não poderá ser desfeita.", preferredStyle: .actionSheet)
                let sim = UIAlertAction(title: "Sim", style: .destructive) { (action) in
                    let sector = self.sectorsArray[indexPath.row]
                    self.delete(item: sector)
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
                        self.sectorsArray[indexPath.row].setName(sectorName: textfield.text!)
                        self.saveData()
                        self.loadData()
                        tableView.reloadData()
                    }
                }
                alert3.addTextField { (text) in
                    text.text = self.sectorsArray[indexPath.row].getName()
                    text.autocapitalizationType = .sentences
                    textfield = text
                }
                alert3.addAction(save)
                alert3.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                self.present(alert3, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
            let change = UIAlertAction(title: "Alterar mercado", style: .default) { (action) in
                let vc = UIViewController()
                vc.preferredContentSize = CGSize(width: 250,height: 75)
                let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 75))
                pickerView.delegate = self
                pickerView.dataSource = self
                vc.view.addSubview(pickerView)
                for m in 0..<self.marketsArray!.count {
                    if self.marketsArray![m] == self.sectorsArray[indexPath.row].market! {
                        pickerView.selectRow(m, inComponent: 0, animated: false)
                    }
                }
                let alert4 = UIAlertController(title: "Alterar mercado", message: "Altere o mercado ao qual o setor \(self.sectorsArray[indexPath.row].getName()) está vinculado. Esta acao alterará o(s) item(s) cadastrado no setor", preferredStyle: .alert)
                let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
                    if self.marketsArray![pickerView.selectedRow(inComponent: 0)] != self.sectorsArray[indexPath.row].market! {
                        self.sectorsArray[indexPath.row].market = self.marketsArray![pickerView.selectedRow(inComponent: 0)]
                    }
                    tableView.reloadData()
                }
                alert4.setValue(vc, forKey: "contentViewController")
                alert4.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                alert4.addAction(save)
                self.present(alert4, animated: true, completion: nil)
            }
            alert.addAction(delete)
            alert.addAction(edit)
            alert.addAction(change)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                tableView.deselectRow(at: indexPath, animated: true)
            }))
            present(alert, animated: true, completion: nil)
        }
    }
}
//MARK:- PICKERVIEW
extension ListOfSectorsViewController{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return marketsArray != nil ? 1 : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return marketsArray != nil ? marketsArray!.count : 0
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let ary = marketsArray {
            let pLabel = UILabel()
            pLabel.textAlignment = .center
            pLabel.textColor = .white
            pLabel.text = ary[row].getName()
            return pLabel
        }
        return UILabel()
    }
}
//MARK:- LAYOUT
extension ListOfSectorsViewController{
    func enableUserInterface() {
        newSectorBtn.isEnabled = searchingOn ? false : true
        searchBar.isHidden = sectorsArray.count == 0 ? true : false
    }
}
//MARK:- BUTTONS
extension ListOfSectorsViewController {
    @IBAction func newSectorPressed(_ sender: Any) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 75)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 75))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        var textField = UITextField()
        let alert = UIAlertController(title: "Novo Setor", message: "Escolha o mercado no qual o setor será cadastrado e digite o nome do novo setor", preferredStyle: .alert)
        let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
            if !textField.text!.isEmpty {
                let sector = Sector(context: self.dataController.viewContext)
                sector.setName(sectorName: textField.text!)
                sector.market = self.marketsArray![pickerView.selectedRow(inComponent: 0)]
                sector.setOredringId(setAt: self.setOrderingInSectors(inSector: sector))
                self.saveData()
                self.loadData()
                self.sectorsTableView.reloadData()
            }
        }
        alert.addTextField { (field) in
            field.placeholder = "Alterar: escreva e salve"
            field.autocapitalizationType = .sentences
            textField = field
        }
        alert.addAction(save)
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}
//MARK:- DATA MANIPUlATION
extension ListOfSectorsViewController{
    func setOrderingInSectors(inSector sector : Sector) -> Int{
        let sectors = sector.market!.getSector()
        var index = 0
        for s in 0..<sectors.count {
            if sectors[s].getOrderingID() != s {
                sectors[s].setOredringId(setAt: s)
            }
            index += 1
        }
        return index
    }
}
//MARK:- COREDATA
extension ListOfSectorsViewController{
    func saveData(){
        do {
            try dataController.viewContext.save()
            print("saved")
        } catch { print("notSaved")     }
    }
    func loadData(){
        let fetchRequest = NSFetchRequest<Sector>(entityName: "Sector")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            sectorsArray = results     }
        let fetchRequest1 = NSFetchRequest<Market>(entityName: "Market")
        fetchRequest1.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest1){
            marketsArray = results.count > 0 ? results : nil    }
        let fetchRequest2 = NSFetchRequest<Sector>(entityName: "Sector")
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        if let results = try? dataController.viewContext.fetch(fetchRequest2){
            searchBarArray = results     }
        enableUserInterface()
    }
    
    func delete(item: Sector){
        dataController.viewContext.delete(item)
        saveData()
        loadData()
        sectorsTableView.reloadData()
    }
}
//MARK:- SEARCH BAR
extension ListOfSectorsViewController{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        showCanceButton()
        loadData()
        if searchText.isEmpty {
            searchBarArray = [Sector]()
            sectorsTableView.reloadData()
            return
        } else {
            let myFilter = searchText.lowercased()
            searchBarArray = searchBarArray.filter({ $0.name?.lowercased().range(of: myFilter, options: [.diacriticInsensitive]) != nil})
        }
        sectorsTableView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarArray = [Sector]()
        showCanceButton()
        sectorsTableView.reloadData()
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
            self.sectorsTableView.keyboardDismissMode = .onDrag
            self.sectorsTableView.reloadData()
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sectorsTableView.keyboardDismissMode = .onDrag
        searchingOn ? showCanceButton() : nil
    }
}
