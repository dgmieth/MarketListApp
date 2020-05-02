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
    var marketsName : MarketNames?
    var sectorsArray = [Sector]()
    var searchBarArray = [Sector]()
    var filterArray = [Sector]()
    var searchingOn = false
    var filterOn = false
    var filterValue : String?
    private var myReorderImage : UIImage? = nil;
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sectorsTableView: UITableView!
    @IBOutlet weak var newSectorBtn: UIBarButtonItem!
    @IBOutlet weak var filters: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        sectorsTableView.setEditing(false, animated: true)
        loadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sectorsTableView.tableFooterView = UIView()
        sectorsTableView.separatorColor = UIColor(named: "textColor")
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.init(named: "tableViewColor")
            textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black])
            textfield.textColor = UIColor(named: "textColor")
            
            if let leftView = textfield.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = UIColor(named: "textColor")
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        sectorsArray = [Sector]()
        searchBarArray = [Sector]()
        sectorsTableView.setEditing(false, animated: true)
    }
}
//MARK:- TABLE VIEW
extension ListOfSectorsViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if marketsArray == nil { return 1 }
        if searchingOn {    return searchBarArray.count    }
        if filterOn {
            if filterArray.count > 0 {    return filterArray.count  }
            return 1
        }
        if sectorsArray.count > 0 {     return sectorsArray.count    }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.isEditing == true ? rightNavigationBarButton(text: "Concluir") : nil
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        if marketsArray == nil {
            return tableView.dequeueReusableCell(withIdentifier: "emptyMarketsCell", for: indexPath)
        }
        if sectorsArray.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "noSectors", for: indexPath)
        }
        tableView.separatorStyle = .singleLine
        tableView.allowsSelection = true
        tableView.isScrollEnabled = true
        if searchingOn {
            if sectorsArray.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "noSectors", for: indexPath)
            }
            let searchCell = tableView.dequeueReusableCell(withIdentifier: "sectorSearchCell", for: indexPath)
            searchCell.textLabel!.text = searchBarArray[indexPath.row].getName()
            return searchCell
        }
        if filterOn {
            if filterArray.count == 0 {
                tableView.separatorStyle = .none
                tableView.allowsSelection = false
                tableView.isScrollEnabled = false
                return tableView.dequeueReusableCell(withIdentifier: "noSectors", for: indexPath)
            }
            let filterCell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath)
            filterCell.textLabel!.text = "\(filterArray[indexPath.row].getOrderingID())- \(filterArray[indexPath.row].getName())"
            filterCell.detailTextLabel!.text = "\(filterArray[indexPath.row].market!.getName()) / \(filterArray[indexPath.row].getQttOfItems()) item(s)"
            return filterCell
        }
        if tableView.isEditing == true {
            let eCell = tableView.dequeueReusableCell(withIdentifier: "editingCell", for: indexPath)
            eCell.textLabel!.text = sectorsArray[indexPath.row].getName()
            return eCell
        }
        let sCell = tableView.dequeueReusableCell(withIdentifier: "sectorCell", for: indexPath)
        sCell.textLabel!.text = "\(sectorsArray[indexPath.row].getOrderingID())- \(sectorsArray[indexPath.row].getName())"
        sCell.detailTextLabel!.text = "\(sectorsArray[indexPath.row].market!.getName()) / \(sectorsArray[indexPath.row].getQttOfItems()) item(s)"
        return sCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if filterOn {
            return filterArray.count > 0 ? CGFloat(44) : CGFloat((tableView.bounds.height-47))
        }
        return sectorsArray.count > 0 ? CGFloat(44) : CGFloat((tableView.bounds.height-47))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var ary = [Sector]()
        ary = filterOn ? filterArray : sectorsArray
        if searchingOn {
            var foundMatch = false
            var counter = 0
            endSearchMode()
            while foundMatch == false {
                for s in 0..<ary.count {
                    if ary[s] == searchBarArray[indexPath.row]{
                        foundMatch = true
                        break
                    }
                    counter += 1
                }   }
            DispatchQueue.main.async {
                tableView.selectRow(at: IndexPath(row: counter, section: 0), animated: true, scrollPosition: .middle)
            }
        } else {
            let alert = UIAlertController(title: ary[indexPath.row].getName(), message: nil, preferredStyle: .actionSheet)
            let delete = UIAlertAction(title: "Deletar setor", style: .destructive) { (delete) in
                let alert2 = UIAlertController(title: "Deletar \(ary[indexPath.row].getName())", message: "Você tem certeza que dseja deletar o setor \(ary[indexPath.row].getName()) do \(ary[indexPath.row].market!.getName())? Esta ação deletará o(s) item(s) vinculado(s) a este mercado e não poderá ser desfeita.", preferredStyle: .actionSheet)
                let sim = UIAlertAction(title: "Sim", style: .destructive) { (action) in
                    let sector = ary[indexPath.row]
                    ary.remove(at: indexPath.row)
                    ary.count > 0 ? self.reorderingSectors(withSectorArray: ary) : nil
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
            let edit = UIAlertAction(title: "Editar nome", style: .default) { (action) in
                var textfield = UITextField()
                let alert3 = UIAlertController(title: "Editar", message: "Altere ou renomeie o nome do mercado.", preferredStyle: .alert)
                let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
                    if !textfield.text!.isEmpty {
                        ary[indexPath.row].setName(sectorName: textfield.text!)
                        self.saveData()
                        self.loadData()
                        tableView.reloadData()
                    }
                }
                alert3.addTextField { (text) in
                    text.text = ary[indexPath.row].getName()
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
                pickerView.tintColor = UIColor(named: "textColor")
                vc.view.addSubview(pickerView)
                for m in 0..<self.marketsArray!.count {
                    if self.marketsArray![m] == ary[indexPath.row].market! {
                        pickerView.selectRow(m, inComponent: 0, animated: false)
                    }
                }
                let alert4 = UIAlertController(title: "Alterar mercado", message: "Altere o mercado ao qual o setor \(ary[indexPath.row].getName()) está vinculado. Esta acao alterará o(s) item(s) cadastrado no setor", preferredStyle: .alert)
                let save = UIAlertAction(title: "Salvar", style: .default) { (action) in
                    if self.marketsArray![pickerView.selectedRow(inComponent: 0)] != ary[indexPath.row].market! {
                        let items = ary[indexPath.row].getQttOfItems()
                        ary[indexPath.row].market!.addSubctractItems(qttyToAddOrSubctract: -items)
                        self.marketsArray![pickerView.selectedRow(inComponent: 0)].addSubctractItems(qttyToAddOrSubctract: items)
                        ary[indexPath.row].market = self.marketsArray![pickerView.selectedRow(inComponent: 0)]
                        ary[indexPath.row].setOredringId(setAt: ary[indexPath.row].market!.getSector().count)
                        ary.remove(at: indexPath.row)
                        let newAry = self.marketsArray![pickerView.selectedRow(inComponent: 0)].getSector()
                        ary.count > 0 ? self.reorderingSectors(withSectorArray: ary) : nil
                        self.reorderingSectors(withSectorArray: newAry)
                        self.saveData()
                        self.loadData()
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
            pLabel.textColor = UIColor(named: "textColor")
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
        newSectorBtn.isEnabled = marketsArray == nil ? false : true
        searchBar.isHidden = marketsArray == nil ? true : false
        filters.isHidden = marketsArray == nil ? true : false
    }
    func rightNavigationBarButton(value : Bool = true, text : String = "Editar"){
        if value {
            if filterArray.count > 1 {
                print(filterArray.count)
                self.navigationItem.rightBarButtonItems?.removeAll()
                let button = UIBarButtonItem(title: text, style: .plain, target: self, action: #selector(reorderSectors(sender:)))
                self.navigationItem.rightBarButtonItem  = button
            } else {
                if self.navigationItem.rightBarButtonItems?.count != 0 {
                    self.navigationItem.rightBarButtonItems?.remove(at: 0)
                }
            }
        } else {
            if self.navigationItem.rightBarButtonItems?.count != 0 {
                self.navigationItem.rightBarButtonItems?.remove(at: 0)
            }
        }
    }
}
//MARK:- TARGETS
extension ListOfSectorsViewController{
    @objc func reorderSectors(sender: UIBarButtonItem){
        if sectorsTableView.isEditing {
            rightNavigationBarButton()
            sectorsTableView.setEditing(false, animated: true)
        } else {
            rightNavigationBarButton(text: "Concluir")
            sectorsTableView.setEditing(true, animated: true)
        }
        sectorsTableView.reloadData()
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
        return sectors.count - 1
    }
    func reorderingSectors(withSectorArray ary : [Sector]){
        for s in 0..<ary.count{
            if s != ary[s].getOrderingID() {
                ary[s].setOredringId(setAt: s)
            }   }
    }
}
//MARK:- COREDATA
extension ListOfSectorsViewController{
    func saveData(){
        do {
            try dataController.viewContext.save()
            print("saved")
        } catch {   print("notSaved")     }
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
        if searchingOn && !filterOn {
            let fetchRequest2 = NSFetchRequest<Sector>(entityName: "Sector")
            fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            if let results = try? dataController.viewContext.fetch(fetchRequest2){
                searchBarArray = results     }
            enableUserInterface()
        } else if filterOn  {
            guard let value = filterValue else { return filterOn = false }
            let fetchRequest3 = NSFetchRequest<Sector>(entityName: "Sector")
            fetchRequest3.predicate = NSPredicate(format: "market.name == %@", value)
            fetchRequest3.sortDescriptors = [NSSortDescriptor(key: "orderingID", ascending: true)]
            if let results = try? dataController.viewContext.fetch(fetchRequest3) {
                filterArray = results
            }
            searchBarArray = searchingOn ? filterArray : [Sector]()
        } else {
            if let ary = marketsArray {
                marketsName = MarketNames(markets: ary)
            }       }
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
        sectorsTableView.setEditing(false, animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
        sectorsTableView.setEditing(false, animated: true)
        filterOn ? rightNavigationBarButton(value: false) : nil
        enableUserInterface()
        let cancel = searchBar.value(forKey: "cancelButton") as! UIButton
        cancel.tintColor = UIColor(named: "textColor")
        cancel.isEnabled = true
    }
    func endSearchMode(){
        DispatchQueue.main.async {
            self.searchBar.endEditing(true)
            self.searchBar.showsCancelButton = false
            self.searchBar.resignFirstResponder()
            self.searchBar.text = ""
            self.searchingOn = false
            self.filterOn ? self.rightNavigationBarButton() : nil
            self.loadData()
            self.enableUserInterface()
            self.sectorsTableView.keyboardDismissMode = .onDrag
            self.sectorsTableView.reloadData()
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        sectorsTableView.keyboardDismissMode = .onDrag
        searchingOn ? showCanceButton() : nil
    }
}
//MARK:- COLLECTION VIEW
extension ListOfSectorsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let markets = marketsName {
            return markets.getArray().count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let vCell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewMain", for: indexPath) as! CollectionViewCell
        if let markets = marketsName {
            vCell.layer.borderWidth = 1
            vCell.name.text = markets.getArray()[indexPath.row].name
            if markets.getArray()[indexPath.row].isSelected {
                vCell.view.backgroundColor = UIColor.lightGray
                vCell.name.textColor = .black
                vCell.layer.borderColor = UIColor.black.cgColor
            } else {
                vCell.view.backgroundColor = nil
                vCell.name.textColor = .white
                vCell.layer.borderColor = UIColor.white.cgColor
            }
            return vCell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let markets = marketsName {
            markets.setIsSelected(index: indexPath.row)
            collectionView.reloadData()
            if indexPath.row == 0 {
                filterOn = false
            } else {
                filterOn = true
                filterValue = markets.getArray()[indexPath.row].name
            }   }
        filterOn ? loadData() : nil
        filterOn ? rightNavigationBarButton() : rightNavigationBarButton(value: false)
        endSearchMode()
        sectorsTableView.setEditing(false, animated: true)
        sectorsTableView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let markets = marketsName {
            let item = markets.getArray()[indexPath.row].name
            let size = item.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
            return CGSize(width: CGFloat(size.width + 10), height: CGFloat(30))
        }
        return CGSize()
    }
}
//MARK:- TABLEVIEW EDITING MODE
extension ListOfSectorsViewController{
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sector = filterArray[sourceIndexPath.row]
        filterArray.remove(at: sourceIndexPath.row)
        filterArray.insert(sector, at: destinationIndexPath.row)
        reorderingSectors(withSectorArray: filterArray)
        saveData()
        loadData()
        tableView.reloadData()
    }
}

