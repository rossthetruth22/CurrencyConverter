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

    private var fromCurrency: Currency?{
        didSet{
            if let _ = toCurrency{
                //button needs to be enabled.
                if let text = fromCurrAmount.text{
                    if !text.isEmpty{
                        convertButton.isEnabled = true
                        //reverseButton.isEnabled = true
                    }
                }
                
            }
        }
    }
    private var toCurrency: Currency?{
        didSet{
            if let _ = fromCurrency{
                //button needs to be enabled.
                 if let text = fromCurrAmount.text{
                    if !text.isEmpty{
                        convertButton.isEnabled = true
                        //reverseButton.isEnabled = true
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var fromImage: UIImageView?
    @IBOutlet weak var fromCurrCode: UILabel!
    @IBOutlet weak var fromCurrSign: UILabel!
    @IBOutlet weak var fromCurrAmount: UILabel!
    
    
    @IBOutlet weak var toImage: UIImageView?
    @IBOutlet weak var toCurrCode: UILabel!
    @IBOutlet weak var toCurrSign: UILabel!
    @IBOutlet weak var toCurrAmount: UILabel!
    
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        convertButton.isEnabled = false
        //reverseButton.isEnabled = false
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

        }
        
    }
    
    func setupFromCurrency(_ currency: Currency?){
        let imageName = currency?.flag ?? " "
        fromImage?.image = UIImage(named: imageName)
        fromCurrCode.text = currency?.currencyCode
        fromCurrSign.text = currency?.currencySymbol
    }
    
    func setupToCurrency(_ currency: Currency?){
        let imageName = currency?.flag ?? " "
        toImage?.image = UIImage(named: imageName)
        toCurrCode.text = currency?.currencyCode
        toCurrSign.text = currency?.currencySymbol
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
        
        if let _ = fromCurrency, let _ = toCurrency{
            if !convertButton.isEnabled{
                convertButton.isEnabled = true
                //reverseButton.isEnabled = true
            }
        }
        
    }
    
    @IBAction func deletePressed(_ sender: UIButton){
        if let text = fromCurrAmount.text{
            if text.count > 0{
                var textArray = Array(text)
                textArray.removeLast()
                fromCurrAmount.text = String(textArray)
            }else{
                convertButton.isEnabled = false
                //reverseButton.isEnabled = false
            }
        }
    }
    
    @IBAction func convertPressed(_ sender: UIButton){
        dataClient.convertCurrency(from: fromCurrency!.currencyCode, to: toCurrency!.currencyCode, convertAmount: Double(fromCurrAmount.text!)!) { (amount, error) in
            if let error = error{
                print(error)
            }else{
                let formatter = NumberFormatter()
                formatter.formatterBehavior = .default
                //formatter.numberStyle = .currency
                formatter.maximumFractionDigits = 2
                formatter.minimumFractionDigits = 0
                DispatchQueue.main.async {
                    self.toCurrAmount.text = formatter.string(from: amount as NSNumber)
                }
            }
        }
        
    }
    
    
    @IBAction func reversePressed(_ sender: UIButton) {
        
        print("In reverse")
        
        let holdCurrency = fromCurrency
        fromCurrency = toCurrency
        toCurrency = holdCurrency
        
        setupFromCurrency(fromCurrency)
        setupToCurrency(toCurrency)
        
        guard let fromText = fromCurrAmount.text, fromText.count > 0, let toText = toCurrAmount.text, toText.count > 0 else{
            fromCurrAmount.text = ""
            toCurrAmount.text = ""
            return
        }
        
        let holdText = fromText
        fromCurrAmount.text = toCurrAmount.text
        toCurrAmount.text = holdText
        
    }
    
    
    @IBAction func clearPressed(_ sender: UIButton){
        
        fromCurrAmount.text = ""
        toCurrAmount.text = ""
        
    }
    

}



