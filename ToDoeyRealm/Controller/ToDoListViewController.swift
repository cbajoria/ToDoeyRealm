//
//  ViewController.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 25/09/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    let  realm = try! Realm()
    
    var itemArray :Results<Item>?
    
    var categorySelected : Category?
    {
        didSet  // called when value is set in categorySelected
        {
            loadData()
        }
    }
    
    let defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemArray?[indexPath.row]
        {
        cell.textLabel?.text = item.title
        
        //ternary operator
        cell.accessoryType = item.done ? .checkmark : .none
        }else
        {
            cell.textLabel?.text = "No items Added"
        }

        return cell
        
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if   let item = itemArray?[indexPath.row]
        {
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{}
        }
        tableView.reloadData()
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
       // var newItem : String = "" //not usefull
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add new Item", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.default, handler: { (action) in
           
            do{
                try self.realm.write {
                    if let currentCategory = self.categorySelected
                    {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        currentCategory.items.append(newItem)
                        self.realm.add(newItem)
                    }
                
                }
            }catch{
                
            }
            self.tableView.reloadData()

           
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
          
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
        
        
    }
    
    
    
    func loadData()
    {
        itemArray = categorySelected?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    
}

//MARK: Search bar methods

extension ToDoListViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count==0
        {
            loadData()
        
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

