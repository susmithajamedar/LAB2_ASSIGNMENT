//
//  ProductListViewController.swift
//  A2_FA_iOS_Susmitha_C0808833
//
//  Created by Susmitha on 24/05/21.
//

import UIKit


class ProductListViewController: UIViewController {
    
    @IBOutlet weak var productListTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products = [ProductItem]()
    var filtredProducts = [ProductItem]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllItems()
    }
    
    func getAllItems(){
        do{
            self.products = try context.fetch(ProductItem.fetchCoreRequest())
            self.filtredProducts = self.products
            self.productListTableView.reloadData()
            
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func addNewButtonTapped(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    
    
    
}


extension ProductListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        vc.product = self.filtredProducts[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.filtredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        cell.productView.isHidden = false
        cell.providerView.isHidden = true
        cell.product = self.filtredProducts[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = self.filtredProducts[indexPath.row]
            self.context.delete(item)
            do{
                try context.save()
            }catch let error {
                print(error.localizedDescription)
            }
            self.getAllItems()
            
            
            
            
            
        }
    }
    
    
}

extension ProductListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty{
            self.filtredProducts = self.products
        }else{
            self.filtredProducts = self.products.filter{$0.productName!.lowercased().contains(searchText.lowercased()) ||  $0.productDescription!.lowercased().contains(searchText.lowercased())}
            
        }
        self.productListTableView.reloadData()
    }
}


extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
