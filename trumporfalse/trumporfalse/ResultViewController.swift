//
//  ResultViewController.swift
//  trumporfalse
//
//  Created by Thomas Clavelli on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pressedButton(selection: Bool) {
        var correct = true
        // compare selection to attribute of quote and set
        
        if (correct) {
            print("Choice is correct")
            resultLabel.text = "Correct!"
            resultLabel.textColor = UIColor.greenColor()
            
            // Play trump sound clip
        }
        else {
            resultLabel.text = "Incorrect!"
            resultLabel.textColor = UIColor.redColor()
            
            // Play 'take a shot' audio
        }
        
    }

}
