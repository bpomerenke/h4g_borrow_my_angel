//
//  FirstViewController.swift
//  BorrowMyAngel
//
//  Created by Jordan McAdoo on 11/2/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectDescription: UILabel!
    @IBOutlet weak var issuePicker: UIPickerView!
    
    var issueData: [String] = ["Depression", "I'm feeling sad", "I'm having a rough day", "Physical Abuse", "Mental Abuse", "Substance Abuse"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.issuePicker.delegate = self
        self.issuePicker.dataSource = self
     
    }
    
    @IBAction func comeBack(unwindSegue: UIStoryboardSegue){
        print("did it...came back")
    }
    @IBAction func connectNow(_ sender: Any) {

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return issueData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return issueData[row]
    }

}


