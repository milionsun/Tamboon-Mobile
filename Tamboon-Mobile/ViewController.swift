//
//  ViewController.swift
//  Tamboon-Mobile
//
//  Created by Milion Sun on 12/14/2560 BE.
//  Copyright © 2560 Chayanon. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    private var charityArray : [CharityObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getDatabase() {
        let urlString = "http://192.168.0.113:8080/charities"
        guard let url = URL(string: urlString)
            else {
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    if let jsonArray = json as? [[String : Any]] {
                        for jsonObject in jsonArray {
                            let charity = CharityObject(id: jsonObject["id"] as? Int,
                                                        name: jsonObject["name"] as? String,
                                                        url: jsonObject["logo_url"] as? String)
                            self.charityArray.append(charity)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print(String.init(data: data, encoding: String.Encoding.utf8)!)
                    print("error: \(error)")
                }
            }
            if let error = error {
                print(error)
            }
        }
        task.resume()
    }

    // ======================================================================================================
    // Table View Setup
    // ======================================================================================================
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charityArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as! CharityTableViewCell
        if let name = charityArray[indexPath.row].name {
            cell.charityNameLabel.text = "\(name)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let donationViewController = self.storyboard?.instantiateViewController(withIdentifier: "DonationViewController") as! DonationViewController
        donationViewController.charity = charityArray[indexPath.row]
        self.navigationController?.pushViewController(donationViewController, animated: true)
    }
    
    // ======================================================================================================
}

