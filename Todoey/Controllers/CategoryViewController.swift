//
//  CategoryViewController.swift
//  Todoey
//
//  Created by zainab on 03/10/2019.
//  Copyright © 2019 zainab. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

           loadCategories()
    }
    
    

    
    
    
    // MARK: -TableView Datasource Methods

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
     
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        

        return cell
    }
    
        //MARK: -Tableview Delegate Methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                performSegue(withIdentifier: "goToItems", sender: self)
   
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destenationVC.selectedCategory = categories?[indexpath.row]
        }
    }
       
    
    //MARK - Model  Manupulation Methods
    
    //MARK - Model  Manupulation Methods
    
    func save(category: Category){

                  do {
                    try realm.write{
                        realm.add(category)
                    }
                  } catch {
                      print("Error saving category \(error)")
                  }
                  self.tableView.reloadData()
    }
    

    
        func loadCategories(){
             categories = realm.objects(Category.self)
            tableView.reloadData()
        }
        
//    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
//        do {
//            try categories = context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    
     //MARK: - Add New Categorys
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   //what will happen one the user clicks add Category button on our UIAlert
                   print("Success!")
                 
                   if textField.text! != ""{
                      
                       let newCategory = Category()
                       newCategory.name = textField.text!
                    
                       
                    self.save(category: newCategory)
                   }
                  
                   
               }
               alert.addTextField { (alertTextField) in
                   alertTextField.placeholder = "create new Category"
                   textField = alertTextField
               }
               
               alert.addAction(action)
               present(alert, animated: true, completion: nil)
    }

}
  //MARK - SearchBar Delegate Methods
//extension CategoryViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//       request.predicate = NSPredicate(format: "name CONTAINS[cd] %@",searchBar.text!)
//
//         request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//
//        loadCategories(with: request)
//
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//             loadCategories()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//
//}
