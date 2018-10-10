//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 03/10/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    //var categoryArray = [Category]()
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = super.tableView(tableView, cellForRowAt: indexPath)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category Added yet"
        guard let color = UIColor(hexString: (categoryArray?[indexPath.row].colour)!) else{fatalError()}
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf( color, returnFlat: true)
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController;
        if let index = tableView.indexPathForSelectedRow
        {
            destinationVC.categorySelected = categoryArray?[index.row]
        }
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add", style: UIAlertActionStyle.default)
        { (action) in
            
            let category = Category()
            category.name = textField.text!
            category.colour = UIColor.randomFlat.hexValue()
            //self.categoryArray.append(category) // as Result is an auto updating container so no need to append it
            self.save(category: category)
         
        }
        
        alert.addAction(action)
        alert.addTextField
        { (text) in
            
            textField = text
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func save(category : Category)
    {
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch
        {
            print("error in saving category")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        categoryArray = realm.objects(Category.self)
        
    }
    
    override func deleteModel(at indexPath: IndexPath) {
        
        if let caterogyToBeDeleted = categoryArray?[indexPath.row]
        {
            do{
            try realm.write {
                realm.delete(caterogyToBeDeleted)
            }
            }catch{}
        }
    }
    

}
