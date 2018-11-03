//
//  LoginViewController.swift
//  BorrowMyAngel
//
//  Created by dev1 on 11/3/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var typeSelector: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        typeSelector.backgroundColor = .clear
        typeSelector.tintColor = .clear
        
        typeSelector.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        typeSelector.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "DINCondensed-Bold", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray,
            NSAttributedString.Key.underlineColor: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 1.0),
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue
            ], for: .selected)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signIn(_ sender: Any) {
        if self.typeSelector.selectedSegmentIndex == 0 {
            self.performSegue(withIdentifier: "personInNeedSegue", sender: self)
        } else {
            self.performSegue(withIdentifier: "angelSegue", sender: self)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
