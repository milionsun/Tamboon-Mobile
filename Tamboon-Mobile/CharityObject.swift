//
//  CharityObject.swift
//  Tamboon-Mobile
//
//  Created by Milion Sun on 12/14/2560 BE.
//  Copyright © 2560 Chayanon. All rights reserved.
//

import Foundation

struct CharityObject {
    let id : Int
    let name : String
    let url : String
    
    init(id : Int, name : String, url : String) {
        self.id = id
        self.name = name
        self.url = url
    }
}
