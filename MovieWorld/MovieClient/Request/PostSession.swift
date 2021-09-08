//
//  PostSession.swift
//  MovieWorld
//
//   Created by Marimuthu T on 07/09/21.
//

import Foundation

struct SessionRequest : Codable
{
    var requestToken : String
    
    enum CodingKeys :String  , CodingKey
    {
        case requestToken = "request_token"
    }
    
}

