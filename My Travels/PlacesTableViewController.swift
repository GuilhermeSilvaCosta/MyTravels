//
//  PlacesTableViewController.swift
//  My Travels
//
//  Created by Guilherme Costa on 13/06/22.
//

import UIKit

class PlacesTableViewController: UITableViewController {
    
    var places: [ Dictionary<String, String> ] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refresh()
    }
    
    func refresh() {
        places = Storage.list()
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let place = places[indexPath.row]["place"]

        cell.textLabel?.text = place
        
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            Storage.remove(index: indexPath.row)
            refresh()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        performSegue(withIdentifier: "showPlace", sender: place as! Dictionary<String, String>)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlace" {
            let t = type(of: sender!)
            if t != UIBarButtonItem.self {
                let viewController = segue.destination as! ViewController
                viewController.travel = sender as! Dictionary<String, String>
            }
        }
    }
}
