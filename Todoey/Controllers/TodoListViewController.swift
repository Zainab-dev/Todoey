//
//  ViewController.swift
//  Todoey
//
//  Created by zainab on 29/09/2019.
//  Copyright © 2019 zainab. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController  {

    var todoItems : Results<Item>?
    let realm = try! Realm()

    
    var selectedCategory : Category? {
            didSet{
               loadItems()
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        ///print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
     
    
         
           
   
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
          return todoItems?.count ?? 1
       }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ?  .checkmark : .none

        } else {
             cell.textLabel?.text = "No Item Added"
        }
       
        return cell
    }
 
    //MARK: -Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        context.delete(todoItems[indexPath.row])
//        todoItems.remove(indexPath.row)
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write{
                item.done = !item.done
                }
                
            } catch {
                print("Error saving done status, \(error)")
            }
        }
   
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    

    //MARK: - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen one the user clicks add item button on our UIAlert
            print("Success!")
          
            if textField.text! != ""{

                if let currentCategory = self.selectedCategory{
                    
                    
                   do {
                     try self.realm.write{
                            let newItem = Item()
                                newItem.title = textField.text!
                                newItem.dateCreated = Date()
                                currentCategory.items.append(newItem)
                               }
                             } catch {
                                 print("Error saving category \(error)")
                             }
                    
                  
                }

                            self.tableView.reloadData()


            }
           
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK - Model  Manupulation Methods
    


    

    func loadItems(){

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}


    //MARK - SearchBar Delegate Methods
extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
             loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}

