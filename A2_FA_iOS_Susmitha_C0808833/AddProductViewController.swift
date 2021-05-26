//
//  AddProductViewController.swift
// A2_FA_iOS_Susmitha_C0808833
//
// Created by Susmitha on 23/05/21.
//

import UIKit
import CoreData
class AddProductViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var providerLabel: UITextField!
    @IBOutlet weak var priceLabel: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var productId: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var product : ProductItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.descriptionTextView.dropShadow()
        
        }
        if let produ = product{
            self.nameTextField.text = produ.productName
            self.providerLabel.text = produ.productProvider
            self.priceLabel.text = "\(produ.productPrice)"
            self.descriptionTextView.text = produ.productDescription
            self.productId.text = produ.productId
            self.title  = (produ.productName)?.capitalized
            self.saveButton.title = "Update"
        }
    }
    
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let productItem = ProductItem(context: self.context)
      
       
        
        if let text = nameTextField.text{
            let name = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !name.isEmpty{
                productItem.productName = name
            }else{
                self.showAlert(msg_title: "Alert", msg_desc: "Name is required", action_title: "Dismiss")
                return
            }
        }
        
        if let text = productId.text{
            let productId = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !productId.isEmpty{
                productItem.productId = productId
            }else{
                self.showAlert(msg_title: "Alert", msg_desc: "ID is required", action_title: "Dismiss")
                return
            }
        }
        
        if let text = providerLabel.text{
            let provider = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !provider.isEmpty{
                productItem.productProvider = provider
            }else{
                self.showAlert(msg_title: "Alert", msg_desc: "Provider is required", action_title: "Dismiss")
                return
            }
        }
        
        if let text = priceLabel.text{
            let price = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !price.isEmpty{
                if let dbprice = Double(price){
                    productItem.productPrice = dbprice
                }
            }else{
                self.showAlert(msg_title: "Alert", msg_desc: "Price is required", action_title: "Dismiss")
                return
            }
        }
        
        if let text = descriptionTextView.text{
            let description = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if !description.isEmpty{
                productItem.productDescription = description
            }else{
                self.showAlert(msg_title: "Alert", msg_desc: "Description is required", action_title: "Dismiss")
                return
            }
        }
        
        if let product = self.product{
            self.context.delete(product)
        }
        
        do{
            try context.save()
            self.navigationController?.popViewController(animated: true)
        }catch let error {
            print(error.localizedDescription)
        }
        
        
        
        
        
    }
    
    func showAlert(msg_title : String , msg_desc : String ,action_title : String){
        let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: action_title, style: .default)
        {
            (result : UIAlertAction) -> Void in
            // _ = self.navigationController?.popViewController(animated: true)
        })
        present(ac, animated: true)
    }
    
    
    
    
}

extension Date {
    var unixTimestamp: Int64 {
        return Int64(self.timeIntervalSince1970 * 1_000)
    }
}
