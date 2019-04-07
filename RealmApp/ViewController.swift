//
//  ViewController.swift
//  RealmApp
//
//  Created by apple on 4/6/19.
//  Copyright © 2019 Sahil. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var nameTextfileld: UITextField!
    @IBOutlet weak var dataTableView: UITableView!
    
    //MARK: Properties 
    let realm = try! Realm()
    var names : Results < ModelClass >?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadItems()
    }

    
    @IBAction func buttonAction(_ sender: Any) {
    
        let na = ModelClass()
        na.name = nameTextfileld.text!
        
        do{
            try! realm.write {
               realm.add(na)
            }
        } catch let errr{
            print("error in \(errr.localizedDescription)")
        }
        loadItems()
    }
    
    func loadItems(){
        names = realm.objects(ModelClass.self)
        dataTableView.reloadData()
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return names?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names?[indexPath.row].name ?? "no name added at now"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController.init(title: "Update Data", message: "", preferredStyle: .alert)
       
        var textfield = UITextField()
        alert.addTextField{ (alertTextfield) in
            alertTextfield.placeholder = " Update name"
            textfield = alertTextfield
        }
        let action = UIAlertAction(title: "Update Name", style: .default) { (handler) in
            if let nameis = self.names?[indexPath.row] {
            do {
                try! self.realm.write {
                    nameis.name = textfield.text!
                    self.loadItems()
                }
            } catch let erroris{
                print("error at updating data\(erroris)")
            }
        }
    }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        dataTableView.reloadData()
    }
}

