//
//  CategoryTableViewController.swift
//  ToDoEY
//
//  Created by Aleksandra Asichka on 2023-03-30.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories: Results<CategoryItem>?
   
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor =  #colorLiteral(red: 0.2103916407, green: 0.5888115764, blue: 1, alpha: 1)
        loadCategories()
    }
    
    // MARK: - Alert controller
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category:", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Add", style: .default) { ok in
            guard let new = textField.text else {
                return
            }
            let newItem = CategoryItem()
            newItem.name = new
            self.saveCategories(category: newItem)
        }
        alert.addTextField { tf in
            tf.placeholder = "new category"
            textField = tf
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name
        return cell
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    // MARK: - Manipulation functions
    
    private func saveCategories(category: CategoryItem) {
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
        self.tableView.reloadData()
    }
    
    private func loadCategories() {
        categories = realm.objects(CategoryItem.self)
        tableView.reloadData()
    }
}
