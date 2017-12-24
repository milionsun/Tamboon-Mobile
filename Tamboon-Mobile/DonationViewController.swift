//
//  DonationViewController.swift
//  Tamboon-Mobile
//
//  Created by Milion Sun on 12/14/2560 BE.
//  Copyright © 2560 Chayanon. All rights reserved.
//

import UIKit
import OmiseSDK

class DonationViewController: UIViewController {
    // Index of charities from list
    private let publicKey = "pkey_test_5aajhp4l3ouwpae8cg1"
    var charity : CharityObject?
    var amount = 0
    var isKeyboardShowing = false
    
    @IBOutlet var donateAmountTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // Perform when user touch donate button
    @IBAction func donateButtonTouched(_ sender: Any) {
        guard let amountText = donateAmountTextField.text else {
            return
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        guard let amount = formatter.number(from: amountText)?.doubleValue else {
            return
        }
        print("\(amountText) => \(amount)")
        self.amount = (Int) (amount * 100)
        
        guard let _ = nameTextField.text else {
            return
        }
        
        let closeButton = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(dismissCreditCardForm))
        
        let creditCardView = CreditCardFormController.makeCreditCardForm(withPublicKey: publicKey)
        creditCardView.delegate = self
        creditCardView.handleErrors = true
        creditCardView.navigationItem.rightBarButtonItem = closeButton
        
        let navigation = UINavigationController(rootViewController: creditCardView)
        present(navigation, animated: true, completion: nil)
    }
    
    @objc func dismissCreditCardForm() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DonationViewController : CreditCardFormDelegate {
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        dismissCreditCardForm()
        
        // Sends `OmiseToken` to your server for creating a charge, or a customer object.
        let urlString = "http://192.168.0.113:8080/donations"
        guard let url = URL(string: urlString)
            else {
                return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        
        let dict = ["name" : nameTextField.text!, "token" : token.tokenId, "amount" : self.amount] as [String : Any?]
        guard let body = try? JSONSerialization.data(withJSONObject: dict, options: [])
            else {
                return
        }
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments])
                    print(json)
                    DispatchQueue.main.async {
                        let successViewController = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
                        self.navigationController?.pushViewController(successViewController, animated: true)
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
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        dismissCreditCardForm()
    }
}
