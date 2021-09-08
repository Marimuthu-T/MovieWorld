//
//  Login.swift
//  TheMovieManager
//
//  Created by Owen LaRosa on 8/13/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest : Encodable
{
    var userName : String
    var password : String
    var requestToken  : String
    
    
    enum CodingKeys :String , CodingKey
    {
        case userName = "username"
        case password
        case requestToken = "request_token"
    }
}
