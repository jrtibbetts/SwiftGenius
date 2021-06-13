//
//  File.swift
//  
//
//  Created by Jason R Tibbetts on 6/12/21.
//

import Foundation

open class GeniusDecoder: JSONDecoder {

    public override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
 
}
