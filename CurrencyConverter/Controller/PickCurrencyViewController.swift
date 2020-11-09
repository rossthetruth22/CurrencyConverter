//
//  PickCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/20/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreData

class PickCurrencyViewController: UIViewController {
    
    var currencies = [Currency]()
    var delegate: CurrencyDelegate?
    var sender: String!
    var container: CurrencyData!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else{return}
        currencies = container.fetchCurrencies()
//        let fetch:NSFetchRequest = Currency.fetchRequest()
//        do{
//          currencies = try container.viewContext.fetch(fetch)
//        }catch{
//            print("problem")
//        }
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}


extension PickCurrencyViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as! CurrencyCell
        let currentCurrency = currencies[indexPath.row]
        cell.mainName.text = currentCurrency.currencyName
        cell.currencyName.text = currentCurrency.currencyName
        cell.currencyCode.text = currentCurrency.currencyCode
        cell.symbolLabel.text = currentCurrency.currencySymbol ?? " "
        //print(currentCurrency.flag)

        if let flag = currentCurrency.flag{
            cell.flag?.image = UIImage(named: flag)
        }else{
            cell.flag?.image = UIImage()
        }
//        cell.flag?.image = UIImage(named: currentCurrency.flag)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
//            let code = self.currencies[indexPath.row].currencyCode
//            let name = self.currencies[indexPath.row].currencyName
//            let symbol = self.currencies[indexPath.row].currencySymbol
//            let id = self.currencies[indexPath.row].currencyID
            let selectedCurrency = self.currencies[indexPath.row]
            //let vv = Currencies(code: code!, name: name!, symbol: symbol, id: id!)
            
            if self.sender == "from"{
                
                self.delegate?.returnFromCurrency(selectedCurrency)

            }else if self.sender == "to"{
                self.delegate?.returnToCurrency(selectedCurrency)
            }
        }
    }
    
    
//    func getCurrencyData() ->[Currency]{
//        
//        var currencies = [Currency]()
//        
//        
//        return currencies
//        
//    }
    
    
}

extension PickCurrencyViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currencies = container.fetchCurrencies(searchText)
        tableView.reloadData()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
}


    
    


