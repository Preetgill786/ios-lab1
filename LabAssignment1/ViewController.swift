//
//  ViewController.swift
//  LabAssignment1
//
//  Created by MacStudent on 2020-01-08.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var names: [String] = []
     var students: [NSManagedObject] = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
    title = "Student Data"
    tableView.register(UITableViewCell.self,forCellReuseIdentifier: "Cell")
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func add(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Name",
                                             message: "Add a new name", preferredStyle: .alert)
               let saveAction = UIAlertAction(title: "Save",  style: .default) {
                   [unowned self] action in
                   
                   guard let textField = alert.textFields?.first,
                     
                       let nameToSave = textField.text else {
                       return
                   }
                   //age city graduate name
                   let dataList = nameToSave.components(separatedBy: ",")
                   
                   if dataList.count == 4 {
                       let rollNo: Int = Int(dataList[0]) ?? 0
                       let name : String = dataList[1]
                       let course: String = dataList[2]
                       let age: Int = Int(dataList[3]) ?? 0
                   
                       //self.names.append(nameToSave)
                    self.save(rollNo:rollNo, name:name, course:course, age:age)
                       self.tableView.reloadData()
                   }else{
                       print("error data input")
                   }

                   
                
                   
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .default)
               alert.addTextField()
               
               alert.addAction(saveAction)
               alert.addAction(cancelAction)
               present(alert, animated: true)
        
    }
    
    func save(rollNo:Int, name:String, course:String, age:Int) {
          guard let appDelegate =
              UIApplication.shared.delegate as? AppDelegate else {
                  return
          }
          
          let managedContext = appDelegate.persistentContainer.viewContext
          // 2
          let entity = NSEntityDescription.entity(forEntityName: "Student",
                                                  in: managedContext)!
          let student = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
         student.setValue(rollNo, forKeyPath: "rollNo")
          student.setValue(name, forKeyPath: "name")
         student.setValue(course, forKeyPath: "course")
          student.setValue(age, forKeyPath: "age")
          
          // 4
          do {
              try managedContext.save()
              students.append(student)
          } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
              
          }
          
      }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated)
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        //3
        do {
            students = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            
        }
    }
    
        
        // Do any additional setup after loading the view.
    }

    
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let st = students[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
      
        let rollNo = st.value(forKeyPath: "rollNo") as? Int ?? 0
        let name = st.value(forKeyPath: "name") as? String ?? ""
        let course = st.value(forKeyPath: "course") as? String ?? ""
        let age = st.value(forKeyPath: "age") as? Int ?? 0
       
        
        cell.textLabel?.text = String(format: "%d %@ %@ %d",rollNo, name, course,age)
        //cell.textLabel?.text = names[indexPath.row]
        return cell
    }
}
    
    
    
    

    


    





