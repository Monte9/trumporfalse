//
//  ViewController.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit
import Realm

class ViewController: UIViewController {
    
    struct Quote {
        var statement: String
        var valid: Bool
    }
    
    // MARK: Outlets
    @IBOutlet weak var quoteBox: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var trumpImage: UIImageView!
    
    var countdown = 10
    var myTimer: NSTimer? = nil
    
    var quotes = [Int: Quote]()
    var index = 0
    
    var streak = 0
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateCounter", userInfo: nil, repeats: true)
        countdownTimer.text = "\(countdown)"
        
        streakLabel.text = String(streak)
        

        
        quotes[0] = Quote(statement: "Donald Trump!", valid: false)
        quotes[1] = Quote(statement: "YAY!", valid: true)
        quotes[2] = Quote(statement: "BOOM lol", valid: false)
        
        quoteBox.text = quotes[index]?.statement
        
        //addQuotesToRealmDB()
        
       // readCSVFile()
    
    }

//    func addQuotesToRealmDB() {
//        
//        let quote = Quote()
//        quote.
//        
//        try! realm.write {
//            realm.add(myDog)
//        }
//        
//        let myPuppy = realm.objects(Dog.self).filter("age == 1").first
//        try! realm.write {
//            myPuppy!.age = 2
//        }
//        
//        print("age of my dog: \(myDog.age)") // => 2
//    }
//    
//    func readCSVFile() {
//        print("Heelo")
//        
//        var filePath = NSBundle.mainBundle().pathForResource("hello", ofType:"txt")
//        var data = NSData(contentsOfFile:filePath!)
//        
//        if let data = NSData(contentsOfURL: contentsOfURL) {
//            if let content = NSString(data: data, encoding: NSUTF8StringEncoding) {
//                //existing code
//            }
//        }
//        
//        
//        print(data)
//
//        
//    }
//    
    func updateCounter() {
        countdown -= 1
        
        if (countdown == 0) {
            showLoseScreen()
        }
        
        countdownTimer.text = "\(countdown)"
    }
    
    @IBAction func choseFalse(sender: UIButton) {
  
        var quote = quotes[index]

        if (quote?.valid)! {
            showLoseScreen()
        } else {
            showAnotherQuote()
        }
    }

    @IBAction func choseTrue(sender: UIButton) {

        
        var quote = quotes[index]

        
        if (quote?.valid)! {
            showAnotherQuote()
        } else {
            showLoseScreen()
        }
    }
    
    func showAnotherQuote(){
        UIView.animateWithDuration(1.5, animations: {
            
            self.quoteBox.text = "CORRECT!"
            self.view.backgroundColor = UIColor.greenColor()
            self.myTimer!.invalidate()
            }) { (true) in
                self.index += 1
                self.index = self.index % self.quotes.count
                self.quoteBox.text = self.quotes[self.index]?.statement
                self.view.backgroundColor = UIColor.whiteColor()
                self.countdown = 10
                self.myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateCounter", userInfo: nil, repeats: true)
                self.countdownTimer.text = "\(self.countdown)"
                self.streak += 1
                self.streakLabel.text = String(self.streak)
                
                
        }
    }
    
    func showLoseScreen() {
        UIView.animateWithDuration(1.5, animations: {
            self.quoteBox.text = "INCORRECT!"
            self.streak = 0
            self.streakLabel.text = String(self.streak)
            self.view.backgroundColor = UIColor.redColor()
            self.myTimer!.invalidate()
        }) { (true) in
            self.index = 1
            self.view.backgroundColor = UIColor.whiteColor()
            self.trumpImage.hidden = false
        }
        
    }
    
    
}

