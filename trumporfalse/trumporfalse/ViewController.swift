//
//  ViewController.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit
import Realm
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    struct Quote {
        var statement: String
        var valid: Bool
    }
    
    //Store state of the speech Uterrance for pause/play functionality
    struct TextToSpeech {
        static var pausing: Bool? = false
        static var previousIndex: NSIndexPath = NSIndexPath()
    }
    
    // MARK: Outlets
    @IBOutlet weak var quoteBox: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var trumpImage: UIImageView!
    
    // text-to-speech code
    let speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
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
        quotes[1] = Quote(statement: "My IQ is one of the highest — and you all know it! Please don't feel so stupid or insecure; it's not your fault.", valid: true)
        quotes[2] = Quote(statement: "BOOM lol", valid: false)
        
        quoteBox.text = quotes[index]?.statement
        
        //Text-to-Speech settings
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        //playStatement()
        //playSound("Desiigner")
        
        play()
        
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
    
    func play() {
        
        print("GETTING IT NOW>..")
        var filePath = NSBundle.mainBundle().pathForResource("trumpAudio", ofType:"m4a")
       // var beepPlayer = AVAudioPlayer()

        print(filePath)

//        beepPlayer = AVAudioPlayer(contentsOfURL: beepSoundURL)
//        beepPlayer.prepareToPlay()
//        beepPlayer.play()
    }
    
    
    func playMySound(){
        
    }
    func playSound(nameOfAudioFileInAssetCatalog: String) {
        var alarmAudioPlayer: AVAudioPlayer?
        if let sound = NSDataAsset(name: nameOfAudioFileInAssetCatalog) {
            do {
                print("here")
                try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try! AVAudioSession.sharedInstance().setActive(true)
                try alarmAudioPlayer = AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
                alarmAudioPlayer!.play()
                print(alarmAudioPlayer)
            } catch {
                print("error initializing AVAudioPlayer")
            }
        }
    }

    //delegate methods for the ArticleCellDelegate
    func playStatement() {
        
        let text = quotes[index]?.statement
        
        let speechUtterance = AVSpeechUtterance(string: text!)
        speechUtterance.rate = rate
        speechUtterance.pitchMultiplier = pitch
        speechUtterance.volume = volume
        speechSynthesizer.speakUtterance(speechUtterance)
        
    }
    
    //Text-to-Speech default settings
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<String, AnyObject> = ["rate": rate, "pitch": pitch, "volume": volume]
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultSpeechSettings)
    }
    
    //load Text-to-Speech default settings
    func loadSettings() -> Bool {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let theRate: Float = userDefaults.valueForKey("rate") as? Float {
            rate = theRate
            pitch = userDefaults.valueForKey("pitch") as! Float
            volume = userDefaults.valueForKey("volume") as! Float
            return true
        }
        return false
    }

    
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
                UIView.animateWithDuration(1.0, animations: {
                    self.playSound("trumpAudio")
                    }, completion: { (true) in
                        self.index += 1
                        self.index = self.index % self.quotes.count
                        self.quoteBox.text = self.quotes[self.index]?.statement
                        self.view.backgroundColor = UIColor.whiteColor()
                        self.countdown = 10
                        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateCounter", userInfo: nil, repeats: true)
                        self.countdownTimer.text = "\(self.countdown)"
                        self.streak += 1
                        self.streakLabel.text = String(self.streak)
                        self.playStatement()                })
                
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
            UIView.animateWithDuration(5.0, animations: { 
                self.index = 1
                self.view.backgroundColor = UIColor.whiteColor()
                self.trumpImage.hidden = false
                }, completion: { (true) in
                    let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("startViewController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    
    }
    
    
}

