//
//  Quote.swift
//  trumporfalse
//
//  Created by Monte with Pillow on 8/13/16.
//  Copyright © 2016 Monte Thakkar. All rights reserved.
//

import Foundation
import RealmSwift

class Quote: Object {
    
    dynamic var statement: String = ""
    dynamic var statement_valid: Bool = false
    
}
