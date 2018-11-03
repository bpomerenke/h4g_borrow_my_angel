//
//  LandingViewController.swift
//  BorrowMyAngel
//
//  Created by dev1 on 11/3/18.
//  Copyright © 2018 hack4good. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAnonymously(_ sender: Any) {
        UserSession.sharedInstance.setHandle()
    }
    
    @IBAction func share(_ sender: Any) {
    
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = "Check out Borrow My Angel!!"
        
        if let myWebsite = URL(string: "https://4agc.com/donation_pages/c9252832-caf3-4cf1-99eb-7450c0dc4699?gift_id=3fbcc69f-54aa-4581-b01b-93106c58b131") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
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


