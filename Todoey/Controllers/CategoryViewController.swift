//
//  CategoryViewController.swift
//  Todoey
//
//  Created by zainab on 03/10/2019.
//  Copyright © 2019 zainab. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

           loadCategories()
    }
    
    

    
    
    
    // MARK: -TableView Datasource Methods

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        

        return cell
    }
    
        //MARK: -Tableview Delegate Methods
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                performSegue(withIdentifier: "goToItems", sender: self)
   
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destenationVC = segue.destination as! TodoListViewController
        if let indexpath = tableView.indexPathForSelectedRow {
            destenationVC.selectedCategory = categoryArray[indexpath.row]
        }
    }
       
    
    //MARK - Model  Manupulation Methods
    
    //MARK - Model  Manupulation Methods
    
    func saveCategories(){

                  do {
                    try context.save()
                  } catch {
                      print("Error saving context \(error)")
                  }
                  self.tableView.reloadData()
    }
    

    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do {
            try categoryArray = context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
     //MARK: - Add New Categorys
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
               let alert = UIAlertController(title: "Add New Todey Category", message: "", preferredStyle: .alert)
               
               let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
                   //what will happen one the user clicks add Category button on our UIAlert
                   print("Success!")
                 
                   if textField.text! != ""{
                      
                       let newCategory = Category(context: self.context)
                       newCategory.name = textField.text!
                       self.categoryArray.append(newCategory)
                       
                       self.saveCategories()
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
extension CategoryViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
       request.predicate = NSPredicate(format: "name CONTAINS[cd] %@",searchBar.text!)
    
         request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
       
        loadCategories(with: request)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
             loadCategories()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
