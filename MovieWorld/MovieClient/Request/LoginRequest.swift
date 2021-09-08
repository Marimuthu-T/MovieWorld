//
//  Login.swift
//  MovieWorld
//
//  Created by Marimuthu T on 07/09/21.
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
