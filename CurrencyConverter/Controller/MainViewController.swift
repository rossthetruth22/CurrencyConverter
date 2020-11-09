//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Royce Reynolds on 4/28/20.
//  Copyright © 2020 Royce Reynolds. All rights reserved.
//

import UIKit
import CoreData

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
                }else{
                    convertButton.isEnabled = false
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
                 }else{
                    convertButton.isEnabled = false
                }
            }
        }
    }
    
    @IBOutlet weak var fromImage: UIImageView?
    @IBOutlet weak var fromCurrCode: UILabel!
    @IBOutlet weak var fromCurrSign: UILabel!
    @IBOutlet weak var fromCurrAmount: UILabel!
    @IBOutlet weak var fromCurrName: UILabel!
    
    
    @IBOutlet weak var toImage: UIImageView?
    @IBOutlet weak var toCurrCode: UILabel!
    @IBOutlet weak var toCurrSign: UILabel!
    @IBOutlet weak var toCurrAmount: UILabel!
    @IBOutlet weak var toCurrName: UILabel!
    
    @IBOutlet weak var reverseButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
//    var container: NSPersistentContainer!
    var container: CurrencyData!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        convertButton.isEnabled = false
        //reverseButton.isEnabled = false
        container = CurrencyData.shared
        guard container != nil else{
            print("container is not available")
            return
        }
        
    }
    
    
    @IBAction func fromTapped(_ sender: Any) {
        handleTapWithNetwork("from")
    }
    @IBAction func toTapped(_ sender: Any) {
        handleTapWithNetwork("to")
    }
    
    func handleTapWithNetwork(_ sender: Any){
        
        let dataClient = NetworkClient.sharedInstance()
        dataClient.getCurrenciesWithFlag { [weak self] (currencies, success, error) in
            if success{
//                self!.currencies = currencies
//                let backgroundContext = self!.container.backgroundContext
//                for currency in self!.currencies{
//                    let current = Currency(context: backgroundContext)
//                    current.currencyCode = currency.currencyCode
//                    current.currencyID = currency.currencyID
//                    current.currencyName = currency.currencyName
//                    current.currencySymbol = currency.currencySymbol
//                    current.flag = currency.flag
//                }
//                (UIApplication.shared.delegate as? AppDelegate)?.saveContext(backgroundContext: backgroundContext)
//                self!.container.saveContext(backgroundContext: backgroundContext)
                DispatchQueue.main.async {
                    self!.performSegue(withIdentifier: "pickCurrencySegue", sender: sender)
                }
            }else{
                if let error = error as? NetworkError{
                    
                    DispatchQueue.main.async {
                        self!.setupAlert(error)
                    }
                }
                
            }
        }
        
    }
    
    func setupFromCurrency(_ currency: Currency?){
//        let imageName = currency?.flag ?? " "
//        fromImage?.image = UIImage(named: imageName)
        if let imageName = currency?.flag{
            fromImage?.image = UIImage(named: imageName)
        }else{
            fromImage?.image = UIImage(systemName: "plus.circle")
        }
        fromCurrCode.text = currency?.currencyCode
        fromCurrSign.text = currency?.currencySymbol
        fromCurrName.text = currency?.currencyName
    }
    
    func setupToCurrency(_ currency: Currency?){
//        let imageName = currency?.flag ?? " "
//        toImage?.image = UIImage(named: imageName)
        if let imageName = currency?.flag{
            toImage?.image = UIImage(named: imageName)
        }else{
            toImage?.image = UIImage(systemName: "plus.circle")
        }
        toCurrCode.text = currency?.currencyCode
        toCurrSign.text = currency?.currencySymbol
        toCurrAmount.text = ""
        toCurrName.text = currency?.currencyName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //print("sending")
        //print(sender)

        if segue.identifier == "pickCurrencySegue"{
            
            if let destination = segue.destination as? PickCurrencyViewController{
                //destination.currencies = self.currencies
                destination.sender = sender as? String
                destination.container = self.container
                destination.delegate = self
            }
        }
    }

    func returnFromCurrency(_ currency: Currency) {
        fromCurrency = currency
        //print("from currency is \(currency.currencyName)")
        //print(currency.flag)
        setupFromCurrency(fromCurrency!)
    }
    
    func returnToCurrency(_ currency: Currency) {
        toCurrency = currency
        //print("to currency is \(currency.currencyName)")
        setupToCurrency(toCurrency!)
    }
    
    @IBAction func numberPressed(_ sender: UIButton){
        
        if var fromText = fromCurrAmount.text, fromText.count == 1, fromText.first == "0" as Character{
            if sender.tag != 0{
                fromText = "\(sender.tag)"
                fromCurrAmount.text? = fromText
                
            }
            return
        }
        
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
                if text.count == 1{
                    convertButton.isEnabled = false
                }
            }
        }
    }
    
    @IBAction func convertPressed(_ sender: UIButton){
        
        if fromCurrAmount.text?.last == "."{
            fromCurrAmount.text?.removeLast()
        }
        guard let fromCode = fromCurrency?.currencyCode, let toCode = toCurrency?.currencyCode else{
            return
        }
        dataClient.convertCurrency(from: fromCode, to: toCode, convertAmount: Double(fromCurrAmount.text!)!) { (amount, error) in
            if let error = error as? NetworkError{
                print(error)
                DispatchQueue.main.async {
                    self.setupAlert(error)
                }
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
        
        //print("In reverse")
        
        let toAmount = toCurrAmount.text
        let holdCurrency = toCurrency
        toCurrency = fromCurrency
        fromCurrency = holdCurrency
        
        setupFromCurrency(fromCurrency)
        setupToCurrency(toCurrency)
        
        guard let fromText = fromCurrAmount.text, fromText.count > 0, let toText = toAmount, toText.count > 0 else{
            fromCurrAmount.text = ""
            //toCurrAmount.text = ""
            return
        }
        
        let holdText = toText
        toCurrAmount.text = fromCurrAmount.text
        fromCurrAmount.text = holdText
        
    }
    
    
    @IBAction func clearPressed(_ sender: UIButton){
        
        fromCurrAmount.text = ""
        toCurrAmount.text = ""
        convertButton.isEnabled = false
        
    }
    
    @IBAction func decimalPressed(_ sender: UIButton){
        
        if var fromText = fromCurrAmount.text{
            if fromText.isEmpty{
                fromText += "0."
            }else{
                let textSet = Set(fromText)
                if !textSet.contains("." as Character){
                    fromText += "."
                    //fromCurrAmount.text? = fromText
                }
            }
            fromCurrAmount.text? = fromText
        }
    }
    
    private func setupAlert(_ error: NetworkError){
        let alert = UIAlertController(title: nil, message: error.errorDescription(), preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
            }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }

}



