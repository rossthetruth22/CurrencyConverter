//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 4/28/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, CurrencyDelegate {
    
    var currencies = [Currency]()
    let dataClient = NetworkClient.sharedInstance()

    private var fromCurrency: Currency?
    private var toCurrency: Currency?
    
    @IBOutlet weak var fromImage: UIImageView?
    @IBOutlet weak var fromCurrCode: UILabel!
    @IBOutlet weak var fromCurrSign: UILabel!
    @IBOutlet weak var fromCurrAmount: UILabel!
    
    
    @IBOutlet weak var toImage: UIImageView?
    @IBOutlet weak var toCurrCode: UILabel!
    @IBOutlet weak var toCurrSign: UILabel!
    @IBOutlet weak var toCurrAmount: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    
    @IBAction func fromTapped(_ sender: Any) {
        handleTapWithNetwork("from")
    }
    @IBAction func toTapped(_ sender: Any) {
        handleTapWithNetwork("to")
    }
    
    func handleTapWithNetwork(_ sender: Any){
        
        let dataClient = NetworkClient.sharedInstance()
        dataClient.getCurrenciesWithFlag { (currencies, success) in
            if success{
                self.currencies = currencies
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "pickCurrencySegue", sender: sender)
                }
            }
//            if let error = error{
//                print(error)
//            }else{
//
//                self.currencies =
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "pickCurrencySegue", sender: sender)
//                }
//            }
        }
        
    }
    
    func setupFromCurrency(_ currency: Currency){
        let imageName = currency.flag ?? " "
        fromImage?.image = UIImage(named: imageName)
        fromCurrCode.text = currency.currencyCode
        fromCurrSign.text = currency.currencySymbol
    }
    
    func setupToCurrency(_ currency: Currency){
        let imageName = currency.flag ?? " "
        toImage?.image = UIImage(named: imageName)
        toCurrCode.text = currency.currencyCode
        toCurrSign.text = currency.currencySymbol
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("sending")
        //print(sender)

        if segue.identifier == "pickCurrencySegue"{
            
            if let destination = segue.destination as? PickCurrencyViewController{
                destination.currencies = self.currencies
                destination.sender = sender as? String
                destination.delegate = self
            }
        }
    }

    func returnFromCurrency(_ currency: Currency) {
        fromCurrency = currency
        print("from currency is \(currency.currencyName)")
        print(currency.flag)
        setupFromCurrency(fromCurrency!)
    }
    
    func returnToCurrency(_ currency: Currency) {
        toCurrency = currency
        print("to currency is \(currency.currencyName)")
        setupToCurrency(toCurrency!)
    }
    
    @IBAction func numberPressed(_ sender: UIButton){
        
        fromCurrAmount?.text! += "\(sender.tag)"
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton){
        if let text = fromCurrAmount.text{
            if text.count > 0{
                var textArray = Array(text)
                textArray.removeLast()
                fromCurrAmount.text = String(textArray)
            }
        }
    }
    
    @IBAction func convertPressed(_ sender: UIButton){
        dataClient.convertCurrency(from: fromCurrency!.currencyCode, to: toCurrency!.currencyCode, convertAmount: Double(fromCurrAmount.text!)!) { (amount, error) in
            if let error = error{
                print(error)
            }else{
                DispatchQueue.main.async {
                    self.toCurrAmount.text = String(amount)
                }
            }
        }
        
    }

}



