//
//  ViewController.swift
//  Tamboon-Mobile
//
//  Created by Milion Sun on 12/14/2560 BE.
//  Copyright © 2560 Chayanon. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // ======================================================================================================
    // Table View Setup
    // ======================================================================================================
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listViewCell") as! CharityTableViewCell
        cell.charityNameLabel.text = "Row \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let donationViewController = self.storyboard?.instantiateViewController(withIdentifier: "DonationViewController") as! DonationViewController
        donationViewController.charityIndex = indexPath.row
        self.navigationController?.pushViewController(donationViewController, animated: true)
    }
    
    // ======================================================================================================
}

