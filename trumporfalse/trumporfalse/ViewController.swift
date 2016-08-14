
//
//  ViewController.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVSpeechSynthesizerDelegate {
    
    
//    struct Quote {
//        var statement: String
//        var valid: Bool
//    }
    
    //Store state of the speech Uterrance for pause/play functionality
    struct TextToSpeech {
        static var pausing: Bool? = false
        static var previousIndex: NSIndexPath = NSIndexPath()
    }
    
    // MARK: Outlets
    @IBOutlet weak var quoteBox: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var countdownTimer: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    @IBOutlet weak var correctMark: UIImageView!
    @IBOutlet weak var wrongMark: UIImageView!
    
    @IBOutlet weak var timeUpClock: UIImageView!
    
    @IBOutlet weak var beginningCounter: UILabel!
    
    
    
   // @IBOutlet weak var trumpImage_pos: UIImageView!
    
     // text-to-speech code
    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    var audioPlayer: AVAudioPlayer?
    
    var beginningCount = 3
    var countdown = 5
    var myTimer: NSTimer? = nil
    
    var quotes = QuoteSource()
    var index = 0
    
    var streak = 0
 
    var highestStreak: Int? = 0
    
//    func applyBlurEffect(image: UIImage){
//        var image : UIImage = UIImage(named:"usa_chicago_reflection_buildings_city_lights_58590_750x1334")!
//        var imageToBlur = CIImage(image: image)
//        var blurfilter = CIFilter(name: "CIGaussianBlur")
//        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
//        var resultImage = blurfilter!.valueForKey("outputImage") as! CIImage
//        var blurredImage = UIImage(CIImage: resultImage)
//        self.blurImageView.image = blurredImage
//        
//    }
//    
    
    
//    var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//    var blurEffectView = UIVisualEffectView(effect: blurEffect)
//    blurEffectView.frame = view.bounds
//    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
//    view.addSubview(blurEffectView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechSynthesizer.delegate = self
        
        countdownTimer.text = "\(countdown)"
        streakLabel.text = String(streak)
        quoteBox.text = ""
        quoteBox.backgroundColor = UIColor(red: 255/255.0, green: 252/255.0, blue: 240/255.0, alpha: 1.0)
        quoteBox.layer.cornerRadius = 20
        quoteBox.clipsToBounds = true
        trueButton.hidden = true
        falseButton.hidden = true
        
        //Text-to-Speech settings
        if !loadSettings() {
            registerDefaultSettings()
        }
    
        getHighestStreakCount()
        
        //Customize the navigation bar title and color
        let navigationBar = self.navigationController?.navigationBar
        
        //make navigation bar transparent
        navigationBar!.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationBar!.shadowImage = UIImage()
        navigationBar!.translucent = true
        
        //set navigation bar title with color
        navigationItem.title = "High Score: \(Int(highestStreak!))"
        navigationBar!.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor()]
        self.quoteBox.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        beginningCounter.text = "\(beginningCount)"
        play("trumpAudio")
        
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"beginningCountdown", userInfo: nil, repeats: true)
    }
    
    func startGame() {
        quoteBox.text = quotes.quotes[index]!.statement
        
        UIView.animateWithDuration(1.5, animations: {
            self.view.backgroundColor = UIColor.whiteColor()
        }) {
            (true) in
            self.playStatement()
        }
    }

    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance utterance: AVSpeechUtterance) {
        myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateCounter", userInfo: nil, repeats: true)
        trueButton.hidden = false
        falseButton.hidden = false
    }
    
    func play(s : String) {
        do {
            if let path = NSBundle.mainBundle().pathForResource(s, ofType: "mp3") {
                try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: path), fileTypeHint: "mp3")
                if let sound = audioPlayer {
                    sound.prepareToPlay()
                    sound.play()
                }
            }
        } catch {
            print("error initializing AVAudioPlayer")
        }
    }

    //delegate methods for the ArticleCellDelegate
    func playStatement() {
        
        let text = quotes.quotes[index]!.statement
        
        let speechUtterance = AVSpeechUtterance(string: text)
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
    
    func storeHighestStreakCount() {
        if (streak > highestStreak) {
            let prefs = NSUserDefaults.standardUserDefaults()
            prefs.setValue(streak, forKey: "high")
        }
        getHighestStreakCount()
    }
    
    func getHighestStreakCount() {
        let prefs = NSUserDefaults.standardUserDefaults()
        let value = prefs.integerForKey("high")
        highestStreak = value
        navigationItem.title = "New High Score: \(Int(highestStreak!))"
    }

    func beginningCountdown() {
        beginningCount -= 1
        beginningCounter.text = "\(beginningCount)"
        
        if (beginningCount == 0) {
            beginningCounter.alpha = 0
            beginningCounter.text = "Go!"
            UIView.animateWithDuration(0.8, animations: {
                self.beginningCounter.alpha = 1.0
            }) {
                (true) in
                self.beginningCounter.hidden = true
                self.startGame()
                self.quoteBox.backgroundColor = UIColor(red: 171/255.0, green: 155/255.0, blue: 106/255.0, alpha: 1.0)
            }
            
        }
    }
    
    func updateCounter() {
        countdown -= 1
        
        if (countdown == 0) {
            timeLost()
        }
        
        if (countdown <= 3) {
            countdownTimer.textColor = UIColor.redColor()
        }
        
        countdownTimer.text = "\(countdown)"
    }

    @IBAction func choseFalse(sender: UIButton) {
        
        let quote = quotes.quotes[index]!
        
        if (quote.isvalid) {
            showLoseScreen()
        } else {
            showAnotherQuote()
        }
    }
    
    @IBAction func choseTrue(sender: UIButton) {
        let quote = quotes.quotes[index]!
        if (quote.isvalid) {
            showAnotherQuote()
            
        } else {
            showLoseScreen()
        }
    }
    
    
    func showAnotherQuote(){
        correctMark.alpha = 0
        correctMark.hidden = false
        countdownTimer.textColor = UIColor.blackColor()
        
        if (speechSynthesizer.speaking) {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }

        UIView.animateWithDuration(0.75, animations: {
            self.play("yourereallysmart (1)")
            self.trueButton.hidden = true
            self.falseButton.hidden = true
            self.correctMark.alpha = 1.0
            self.quoteBox.backgroundColor = UIColor(white: 1, alpha: 0.5)
            self.quoteBox.text = ""
            if(self.myTimer != nil) {
                self.myTimer!.invalidate()
            }
            }) { (true) in
                UIView.animateWithDuration(0.5, animations: {
                        self.correctMark.alpha = 0.00
                    }, completion: { (true) in
                       
                        self.correctMark.hidden = true
                        self.index += 1
                        self.index = self.index % self.quotes.numEntries
                        self.quoteBox.text = self.quotes.quotes[self.index]!.statement
                        
                        //self.trueButton.hidden = false
                        //self.falseButton.hidden = false
                        //self.trumpImage_pos.hidden = false
                        self.quoteBox.backgroundColor = UIColor(red: 171/255.0, green: 155/255.0, blue: 106/255.0, alpha: 1.0)
                        self.countdown = 5
                        self.countdownTimer.text = "\(self.countdown)"
                        self.streak += 1
                        self.storeHighestStreakCount()
                        self.streakLabel.text = String(self.streak)
                        
                        self.playStatement()
                        //while (self.speechSynthesizer.speaking){}
                })
        } 
        
    }
    
    func timeLost() {
        if (speechSynthesizer.speaking) {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }

        UIView.animateWithDuration(1.5, animations: {
            self.play("stupid1")
            self.trueButton.hidden = true
            self.falseButton.hidden = true
            self.view.backgroundColor = UIColor(red: 157/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0)
            self.timeUpClock.hidden = false
            self.quoteBox.text = ""
            self.quoteBox.hidden = true
            self.storeHighestStreakCount()
            self.streak = 0
            self.streakLabel.text = String(self.streak)
            if(self.myTimer != nil) {
                self.myTimer!.invalidate()
            }

        }) { (true) in
            UIView.animateWithDuration(2.0, animations: {
                self.index = 1
                self.view.backgroundColor = UIColor.whiteColor()
                }, completion: { (true) in
                    let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
            })
        }

    }
    
    func showLoseScreen() {
        wrongMark.alpha = 0.0
        wrongMark.hidden = false
        
        if (speechSynthesizer.speaking) {
            speechSynthesizer.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        }

        UIView.animateWithDuration(1, animations: {
            self.play("stupid1")
            self.trueButton.hidden = true
            self.falseButton.hidden = true
            self.wrongMark.alpha = 1.0
            self.quoteBox.backgroundColor = UIColor(white: 1, alpha: 0.5)
            self.quoteBox.text = ""
            self.storeHighestStreakCount()
            self.streak = 0
            self.streakLabel.text = String(self.streak)
            if(self.myTimer != nil) {
                self.myTimer!.invalidate()
            }
        }) { (true) in
            UIView.animateWithDuration(0.5, animations: {
                self.index = 1
                self.wrongMark.alpha = 0.0
                }, completion: { (true) in
                    self.wrongMark.hidden = true
                    let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }
    
    
    
}

