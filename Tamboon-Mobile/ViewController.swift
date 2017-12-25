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
    // Server
    private let server = "http://192.168.0.113:8080"

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshButton = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(getDatabase))
        self.navigationItem.rightBarButtonItem = refreshButton
        getDatabase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func getDatabase() {
        let urlString = self.server + "/charities"
        guard let url = URL(string: urlString)
            else {
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                // Check Status Code
                switch (response.statusCode) {
                case 200:
                    self.decodeCharities(data: data)
                    break
                default:
                    self.getFail()
                    break
                }
            } else {
                self.getFail()
            }
        }
        task.resume()
    }
    
    func decodeCharities(data: Data?) {
        if let data = data {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                print(json)
                if let jsonArray = json as? [[String : Any]] {
                    self.charityArray.removeAll()
                    for jsonObject in jsonArray {
                        let charity = CharityObject(id: jsonObject["id"] as? Int,
                                                    name: jsonObject["name"] as? String,
                                                    url: jsonObject["logo_url"] as? String)
                        self.charityArray.append(charity)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    self.decodeFail()
                }
            } catch {
//                print(String.init(data: data, encoding: String.Encoding.utf8)!)
//                print("error: \(error)")
                self.decodeFail()
            }
        } else {
            self.getFail()
        }
    }
    
    func decodeFail() {
        DispatchQueue.main.async {
            self.showAlert(title: "Cannot retrieve charities information", message: "Please contact administrator")
        }
    }
    
    func getFail() {
        DispatchQueue.main.async {
            self.showAlert(title: "Cannot retrieve charities information", message: "Please contact administrator")
        }
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
    
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}

