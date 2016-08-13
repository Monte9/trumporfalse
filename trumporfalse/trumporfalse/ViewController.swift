//
//  ViewController.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var quoteBox: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    
    
    var countdown = 10
    var myTimer: NSTimer? = nil
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        myTimer = NSTimer(timeInterval: 1.0, target: self, selector:#selector(ViewController.countDownTick), userInfo: nil, repeats: true)
        countdownTimer.text = "\(countdown)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func countDownTick() {
        print("called countdowntick")
        countdown -= 1
        
        if (countdown == 0) {
            myTimer!.invalidate()
            myTimer = nil
        }
        
        countdownTimer.text = "\(countdown)"
    }
    
    @IBAction func choseFalse(sender: UIButton) {
        print("You chose false")
    }

    @IBAction func choseTrue(sender: UIButton) {
        print("You chose true")
    }
    
    
}

