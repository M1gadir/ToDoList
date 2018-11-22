//
//  ViewController.swift
//  ToDoList
//
//  Created by My Macbook on 27/10/18.
//  Copyright © 2018 TB. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate,  UITableViewDataSource{
    
    @IBOutlet weak var tableview: UITableView!
    var itemName: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
        
        do
        {
            itemName = try context.fetch(fetchRequest)
        }
        catch
        {
            print("Error In Loading Data ")
        }
    }
    var titleTextField: UITextField!
    
    func titleTextField(textfield: UITextField!)
    {
        titleTextField = textfield
        titleTextField.placeholder = "item name"
    }
    
    @IBAction func Addbutton(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Add Your Item", message: "Add Your Item Name Below", preferredStyle: .alert)
        let Addaction = UIAlertAction(title: "Save", style: .default, handler: self.save)
        let cancelaction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(Addaction)
        alert.addAction(cancelaction)
        alert.addTextField(configurationHandler: titleTextField)
        self.present(alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(itemName[indexPath.row])
            itemName.remove(at: indexPath.row)
            
            
            do
            {
             try context.save()
            }
            catch
            {
                print("There Was a error in deleting.")
            }
                
        }
      self.tableview.reloadData()
        
    }
    
    func save(alert: UIAlertAction!)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
        let theTitle = NSManagedObject(entity: entity, insertInto: context)
        theTitle.setValue(titleTextField.text, forKey: "Title")
        
        do
        {
           try context.save()
            itemName.append(theTitle)
        }
        catch
        {
           print("there was a error in saving")
        }
        self.tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = itemName[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = title.value(forKey: "title") as? String
        return cell
        
    }
}


