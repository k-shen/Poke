//
//  SearchVC.swift
//  Poke
//
//  Created by Kaiwen Shen on 6/14/20.
//  Copyright © 2020 Kaiwen Shen. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchDetail = [Search]()
    
    var filteredData = [Search]()
    
    var isSearching = false
    
    var recipient: String!
    
    var messageId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
        // Do any additional setup after loading the view.
        
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                self.searchDetail.removeAll()
                
                for data in snapshot {
                    if let postDict = data.value as? Dictionary<String, AnyObject> {
                        let key = data.key
                        
                        let post = Search(userKey: key, postData: postDict)
                        
                        self.searchDetail.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? MessageVC {
            destinationViewController.recipient = recipient
            destinationViewController.messageId = messageId
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredData.count
        } else {
            return searchDetail.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchData: Search!
        
        if isSearching {
            searchData = filteredData[indexPath.row]
            
        } else {
            searchData = searchDetail[indexPath.row]
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? searchCell {
            cell.configCell(searchDetail: searchData)
            
            return cell
        } else {
            return searchCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            recipient = filteredData[indexPath.row].userKey
            
        } else {
            recipient = searchDetail[indexPath.row].userKey
        }
        
        performSegue(withIdentifier: "toMessage", sender: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            
            view.endEditing(true)
            
            tableView.reloadData()
        } else {
            isSearching = true
            
            filteredData = searchDetail.filter({$0.username == searchBar.text})
            
            tableView.reloadData()
        }
    }
    
    @IBAction func goBack(_ sender: AnyObject) {
        //performSegue(withIdentifier: "toChat", sender: nil)
        dismiss(animated: true, completion: nil)
        
    }
}
