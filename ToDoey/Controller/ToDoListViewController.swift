//
//  ViewController.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 25/09/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray =  [Item]()
    
    var categorySelected : Category?
    {
        didSet  // called when value is set in categorySelected
        {
            loadData()
        }
    }
    
    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first?.appendingPathComponent("Item.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  print(dataFilePath)
        // Do any additional setup after loading the view, typically from a nib.
       // loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
//        if item.done == true
//        {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
     
        
           itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         tableView.deselectRow(at: indexPath, animated: true)
        saveData()
        
        // this code can be written in one line
//        if itemArray[indexPath.row].done == true
//        {
//            itemArray[indexPath.row].done = false
//        }else
//        {
//            itemArray[indexPath.row].done = true
//        }
        //we need to associate check property not with cell
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }else
//        {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
//
       
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
       // var newItem : String = "" //not usefull
        
        var textField = UITextField()
        
        let alert = UIAlertController(title:"Add new Item", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertActionStyle.default, handler: { (action) in
           
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.categorySelected
            self.itemArray.append(newItem)
            self.saveData()
        })
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
          
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    
        
        
    }
    
    func saveData()
    {
        
        //Using Encoder
//        let encoder = PropertyListEncoder()
//        do{
//        let data = try encoder.encode(itemArray);
//            try data.write(to: dataFilePath!)
//        }catch
//        {
//
//        }
        
        //Using Sqlite
        do{
          try context.save()
        }catch{
            
        }
        
        
       tableView.reloadData()
        
    }
    
    func loadData(with request:NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil)  //with : external parameter and request : internal parameter when we don't pass the value for request then it take Item.fetchRequest as default parameter
    {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@",categorySelected!.name!)
        
        if  let additionalPredicate = predicate{
            request.predicate  = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        }else
        {
            request.predicate = categoryPredicate
        }
    
        
          //Using Sqlite
        do{
           itemArray =  try context.fetch(request)
           }catch
           {
           }
        tableView.reloadData()
        
        //Using Encoder
        //        if let data = try? Data(contentsOf: dataFilePath!)
        //        {
        //            let decoder = PropertyListDecoder()
        //            do{
        //             itemArray = try decoder.decode([Item].self, from: data)
        //            }catch
        //            {
        //
        //            }
        //
        //        }
        
    }
    
    
}

//MARK: Search bar methods

extension ToDoListViewController : UISearchBarDelegate
{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //Predicate is used for quering data
        
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //String comparisons are by default case and diacritic sensitive so to make it insensitive .
     request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // sorting it
        
        loadData(with: request,predicate: predicate)
        
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

