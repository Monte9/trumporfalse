
//
//  ViewController.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit
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
    @IBOutlet weak var trumpImage_neg: UIImageView!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    
    
    
   // @IBOutlet weak var trumpImage_pos: UIImageView!
    
     // text-to-speech code
    let speechSynthesizer = AVSpeechSynthesizer()
    var rate: Float!
    var pitch: Float!
    var volume: Float!
    
    var audioPlayer: AVAudioPlayer?
    
    var countdown = 10
    var myTimer: NSTimer? = nil
    
    var quotes = [Int: Quote]()
    var index = 0
    
    var streak = 0
 
    
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
        
        UIView.animateWithDuration(1.5, animations: {
            self.play()
            self.view.backgroundColor = UIColor.blackColor()
        }) {
            (true) in
            self.playStatement()
        }
        
    }
    
    func play() {
        do {
            if let path = NSBundle.mainBundle().pathForResource("trumpAudio", ofType: "mp3") {
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
            timeLost()
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
            self.trueButton.hidden = true
            self.falseButton.hidden = true
            self.quoteBox.text = "CORRECT!"
            self.view.backgroundColor = UIColor.greenColor()
            self.myTimer!.invalidate()
            }) { (true) in
                UIView.animateWithDuration(1.0, animations: {
                    self.view.backgroundColor = UIColor.blackColor()
                    }, completion: { (true) in
                        self.index += 1
                        self.index = self.index % self.quotes.count
                        self.quoteBox.text = self.quotes[self.index]?.statement
                        
                    
                        self.trueButton.hidden = false
                        self.falseButton.hidden = false
                        //self.trumpImage_pos.hidden = false
                        
                        self.countdown = 10
                        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:"updateCounter", userInfo: nil, repeats: true)
                        self.countdownTimer.text = "\(self.countdown)"
                        
                        self.streak += 1
                        self.streakLabel.text = String(self.streak)
                        self.playStatement()
                })
        } 
        
    }
    
    func timeLost() {
        UIView.animateWithDuration(1.5, animations: {
            self.quoteBox.text = "TIME'S UP!"
            self.streak = 0
            self.streakLabel.text = String(self.streak)
            self.view.backgroundColor = UIColor.redColor()
            self.myTimer!.invalidate()
        }) { (true) in
            UIView.animateWithDuration(2.0, animations: {
                self.index = 1
                self.view.backgroundColor = UIColor.whiteColor()
                self.trumpImage_neg.hidden = false
                }, completion: { (true) in
                    let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
            })
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
            UIView.animateWithDuration(2.0, animations: {
                self.index = 1
                self.view.backgroundColor = UIColor.whiteColor()
                self.trumpImage_neg.hidden = false
                }, completion: { (true) in
                    let start_game_storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: UIViewController = start_game_storyboard.instantiateViewControllerWithIdentifier("HomeNavigationController") as UIViewController
                    self.presentViewController(vc, animated: true, completion: nil)
            })
        }
    }
    
}

