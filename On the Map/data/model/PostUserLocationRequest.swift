//
//  File.swift
//  On the Map
//
//  Created by Nitin Anand on 05/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import Foundation
struct PostUserLocationRequest: Codable {
    let uniqueKey:String
    let firstName:String
    let lastName:String
    let mapString:String
    let mediaURL:String
    let latitude:Double
    let longitude:Double
}
