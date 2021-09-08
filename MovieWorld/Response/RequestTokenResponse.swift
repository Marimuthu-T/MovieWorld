//
//  RequestTokenResponse.swift
//  MovieWorld
//
//   Created by Marimuthu T on 07/09/21.
//

import Foundation


struct RequestTokenResponse : Codable
{
    var success : Bool
    var expiresAt : String
    var requestToken : String
    
    enum CodingKeys : String , CodingKey ,Decodable
    {
        
        case success 
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}


