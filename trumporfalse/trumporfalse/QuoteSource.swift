//
//  QuoteSource.swift
//  trumporfalse
//
//  Created by Thomas Clavelli on 8/14/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import UIKit

class QuoteSource: NSObject {
    
    struct Quote {
        var statement: String
        var isvalid: Bool
        
        init(statement: String, isvalid: Bool) {
            self.statement = statement
            self.isvalid = isvalid
        }
    }
    
    // Properties
    var quotes = [Int:Quote]()
    var numEntries = 0
    
    
    override init() {
        super.init()
        
        addEntry("My message isn't perfectly defined. I have, as a human being, fallen to peer pressure.", isvalid: false)
        addEntry("It's just hard to meet new people, in my position.", isvalid: false)
        addEntry("War is to man what maternity is to a woman. From a philosophical and doctrinal viewpoint, I do not believe in perpetual peace.", isvalid: false)
        addEntry("All propaganda has to be popular and has to accommodate itself to the comprehension of the least intelligent of those whom it seeks to reach.", isvalid: false)
        addEntry("Any alliance whose purpose is not the intention to wage war is senseless and useless.", isvalid: false)
        addEntry("Anyone who sees and paints a sky green and fields blue ought to be sterilized.", isvalid: false)
        addEntry("By the skillful and sustained use of propaganda, one can make a people see even heaven as hell or an extremely wretched life as paradise.", isvalid: false)
        addEntry("Demoralize the enemy from within by surprise, terror, sabotage, assassination. This is the war of the future.", isvalid: false)
        addEntry("Strength lies not in defense but in attack.", isvalid: false)
        addEntry("The very first essential for success is a perpetually constant and regular employment of violence.", isvalid: false)
        addEntry("The victor will never be asked if he told the truth.", isvalid: false)
        addEntry("Terrorism will never cease in a country where the so-called leaders are criminals and terrorists in disguise.", isvalid: false)
        addEntry("Who isn't amused by a giant, dancing penis? Sometimes when I'm sad, I make my assistant put on the penis outfit and bounce around my house.", isvalid: false)
        addEntry("You know, it really doesn’t matter what the media write as long as you’ve got a young, and beautiful, piece of ass.", isvalid: true)
        addEntry("I have a great relationship with the Blacks.", isvalid: true)
        addEntry("Sadly, because president Obama has done such a poor job as president, you won't see another black president for generations!", isvalid: true)
        addEntry("All of the women on The Apprentice flirted with me – consciously or unconsciously. That’s to be expected.", isvalid: true)
        addEntry("One of they key problems today is that politics is such a disgrace. Good people don’t go into government.", isvalid: true)
        addEntry("The beauty of me is that I’m very rich.", isvalid: true)
        addEntry("It’s freezing and snowing in New York – we need global warming!", isvalid: true)
        addEntry("I’ve said if Ivanka weren’t my daughter, perhaps I’d be dating her.", isvalid: true)
        addEntry("My fingers are long and beautiful, as, it has been well documented, are various other parts of my body.", isvalid: true)
        addEntry("I have never seen a thin person drinking Diet Coke.", isvalid: true)
        addEntry("I think the only difference between me and the other candidates is that I’m more honest and my women are more beautiful.", isvalid: true)
        addEntry("The point is, you can never be too greedy.", isvalid: true)
        addEntry("My Twitter has become so powerful that I can actually make my enemies tell the truth.", isvalid: true)
        addEntry("My IQ is one of the highest — and you all know it! Please don't feel so stupid or insecure; it's not your fault.", isvalid: true)
        addEntry("I have so many fabulous friends who happen to be gay, but I am a traditionalist.", isvalid: true)
        addEntry("Number one, I have great respect for women. I was the one that really broke the glass ceiling on behalf of women, more than anybody in the construction industry.", isvalid: true)
        addEntry("So you know what I'm gonna do? I'm gonna do something really outrageous, I'm gonna tell the truth.", isvalid: false)
        addEntry("I feel like I'm too busy writing history to read it.", isvalid: false)
        addEntry("Nobody builds walls better than me.", isvalid: true)
        addEntry("No, I’m not into anal.", isvalid: true)
        addEntry("I love the attention but I don't like too much of it.", isvalid: false)
        addEntry("Everyone thinks I’m such a nice guy.", isvalid: true)
        addEntry("Who says I am not under the special protection of God?", isvalid: false)
        addEntry("It’s freezing and snowing in New York – we need global warming!", isvalid: true)
        addEntry("I still think I am the greatest.", isvalid: false)
        addEntry("I don't know what's better gettin' laid or gettin' paid.", isvalid: false)
        addEntry("I will go down as the voice of this generation, of this decade, I will be the loudest voice.", isvalid: false)
        addEntry("Wealthy people don’t like me.", isvalid: true)
        addEntry("I am not a fan of books.", isvalid: false)
        addEntry("I don't hate women - they just sometimes make me mad.", isvalid: false)
        addEntry("If I ever ran for office, I’d do better as a Democrat than as a Republican", isvalid: true)
        addEntry("The truth is that men are tired of liberty.", isvalid: false)
        addEntry("Nobody can tell me where I can and can't go.", isvalid: false)
        addEntry("Usually if I fire somebody who’s bad, I’ll tell them how great they are. Because I don’t want to hurt people’s feelings.", isvalid: true)
        addEntry("One of the problems with defending free speech is you often have to defend people that you find to be outrageous and unpleasant and disgusting.", isvalid: false)
        addEntry("Nothing in life is promised except death.", isvalid: false)
        addEntry("It is not truth that matters, but victory.", isvalid: false)
        addEntry("I do not see why man should not be just as cruel as nature.", isvalid: false)
        
        
        randomizeSource()
    }
    
    func addEntry(statement: String, isvalid: Bool) {
        
        quotes[numEntries] = Quote(statement: statement, isvalid: isvalid)
        
        numEntries += 1
    }
    
    func randomizeSource() {
        for i in 0..<numEntries {
            let rand = Int(arc4random_uniform(UInt32(numEntries)))
            let temp = quotes[rand]
            quotes[rand] = quotes[i]
            quotes[i] = temp
        }
    }
    
}
