//
//  PickCurrencyViewController.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 5/20/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class PickCurrencyViewController: UIViewController {
    
    var currencies = [Currency]()
    var delegate: CurrencyDelegate?
    var sender: String!

    @IBOutlet weak var tableView: UITableView!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        

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
        cell.flag?.image = UIImage(named: currentCurrency.flag ?? "")
        
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
            if self.sender == "from"{
                self.delegate?.returnFromCurrency(self.currencies[indexPath.row])

            }else if self.sender == "to"{
                self.delegate?.returnToCurrency(self.currencies[indexPath.row])
            }
        }
    }
    
    
    func getCurrencyData() ->[Currency]{
        
        var currencies = [Currency]()
        
        
        return currencies
        
    }
    
    
}

extension PickCurrencyViewController: UISearchBarDelegate{
    
}


    
    


