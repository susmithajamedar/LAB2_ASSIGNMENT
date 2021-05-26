//
// ViewController.swift
// A2_FA_iOS_Susmitha_C0808833
//
//  Created by Susmitha on 23/05/21.
//

import UIKit

struct Provider {
    var name: String?
    var products = [ProductItem]()
}

class ProductListViewController: UIViewController {

    @IBOutlet weak var productListTableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var products = [ProductItem]()
    var filtredProducts = [ProductItem]()
    var isProvider = false
    var providers = [Provider]()
    
    var filtredProviders = [Provider]()
    
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
    
    @IBAction func productSegmentSwitched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1{
            self.isProvider = true
            self.title = "Providers"
            let providers = self.products.map({$0.productProvider!}).uniqued()
            for provider in providers{
                let products = self.products.filter{$0.productProvider?.lowercased() == provider.lowercased()}
                let pro = Provider(name: provider, products: products)
                self.providers.append(pro)
            }
            self.filtredProviders = self.providers
        }else{
            self.title = "Products"
            providers = [Provider]()
            filtredProviders = [Provider]()
            self.isProvider = false
        }
        
        self.productListTableView.reloadData()
    }
    
    
    


}


extension ProductListViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isProvider{
            let vc = storyboard?.instantiateViewController(identifier: "ProviderProductListViewController") as! ProviderProductListViewController
            vc.provider = self.filtredProviders[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
            vc.product = self.filtredProducts[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.isProvider ? self.filtredProviders.count : self.filtredProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell") as! ProductTableViewCell
        if isProvider{
            cell.productView.isHidden = true
            cell.providerView.isHidden = false
            cell.provider = self.filtredProviders[indexPath.row]
        }else{
            cell.productView.isHidden = false
            cell.providerView.isHidden = true
            cell.product = self.filtredProducts[indexPath.row]
        }
        
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if isProvider{
                let provider = self.filtredProviders[indexPath.row]
                
                for product in provider.products{
                    self.context.delete(product)
                }
                if let index = self.filtredProviders.firstIndex(where: {$0.name == provider.name}){
                    self.filtredProviders.remove(at: index)
                }
                
                if let index = self.providers.firstIndex(where: {$0.name == provider.name}){
                    self.providers.remove(at: index)
                }
                
            }else{
                let item = self.filtredProducts[indexPath.row]
                self.context.delete(item)
                
            }
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
            self.filtredProviders = self.providers
        }else{
            if isProvider{
                self.filtredProviders = self.providers.filter{$0.name!.lowercased().contains(searchText.lowercased())}
            }else{
                self.filtredProducts = self.products.filter{$0.productName!.lowercased().contains(searchText.lowercased()) ||  $0.productDescription!.lowercased().contains(searchText.lowercased())}
            }
           
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
