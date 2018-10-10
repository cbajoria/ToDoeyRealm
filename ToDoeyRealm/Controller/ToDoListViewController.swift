//
//  ViewController.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 25/09/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    let  realm = try! Realm()
    
    @IBOutlet weak var serachBar: UISearchBar!
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
        
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        
            guard let color = categorySelected?.colour else{ fatalError()}
        
            title = categorySelected!.name
            guard let navBarColor = UIColor(hexString: color) else { fatalError()}
                updateNavBar(withHexColor: navBarColor)
            self.serachBar.barTintColor = navBarColor
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "0096FF") else {fatalError()}
        updateNavBar(withHexColor: originalColor)
    }
    
    
    func updateNavBar(withHexColor hexColor : UIColor)
    {
         guard let navBar = navigationController?.navigationBar else {fatalError("no nav bar")}
            navBar.barTintColor = hexColor
            navBar.tintColor =  ContrastColorOf(hexColor, returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor:ContrastColorOf(hexColor, returnFlat:true)]
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
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let item = itemArray?[indexPath.row]
        {
        cell.textLabel?.text = item.title
            if  let colour =  UIColor(hexString: categorySelected!.colour)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat((itemArray!.count))){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
                
            }
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
    
    override func deleteModel(at indexPath: IndexPath) {
        if  let itemToBeDeleted = itemArray?[indexPath.row]
        {
            do{
            try realm.write {
                realm.delete(itemToBeDeleted)
            }
            }catch{}
        }
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

