//
//  CategoryTableViewController.swift
//  ToDoey
//
//  Created by Chandrika Bajoria on 03/10/18.
//  Copyright © 2018 Chandrika Bajoria. All rights reserved.
//

import UIKit
import  CoreData

class CategoryTableViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let destinationVC = segue.destination as! ToDoListViewController;
        if let index = tableView.indexPathForSelectedRow
        {
            destinationVC.categorySelected = categoryArray[index.row]
        }
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem)
    {
        var textField : UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Add", style: UIAlertActionStyle.default)
        { (action) in
            
            let category = Category(context: self.context)
            category.name = textField.text
            self.categoryArray.append(category)
            self.saveCategory()
         
        }
        
        alert.addAction(action)
        alert.addTextField
        { (text) in
            
            textField = text
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveCategory()
    {
        do{
           try context.save()
            
        }catch
        {
            print("error in saving category")
        }
        tableView.reloadData()
    }
    
    func loadCategory()
    {
        let request : NSFetchRequest<Category> =  Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch
        {
            
        }
        
    }

}
