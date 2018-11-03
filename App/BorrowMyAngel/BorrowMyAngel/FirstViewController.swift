//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectDescription: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
    }
    
    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }
    @IBAction func connectNow(_ sender: Any) {

    }

}


