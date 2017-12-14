//
//  DonationViewController.swift
//  Tamboon-Mobile
//
//  Created by Milion Sun on 12/14/2560 BE.
//  Copyright © 2560 Chayanon. All rights reserved.
//

import UIKit

class DonationViewController: UIViewController {
    // Index of charities from list
    var charityIndex = -1
    
    @IBOutlet var cardNumberTextField: UITextField!
    @IBOutlet var donateAmountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Perform when user touch donate button
    @IBAction func donateButtonTouched(_ sender: Any) {
        let successViewController = self.storyboard?.instantiateViewController(withIdentifier: "SuccessView") as! SuccessViewController
        self.navigationController?.pushViewController(successViewController, animated: true)
    }
}
