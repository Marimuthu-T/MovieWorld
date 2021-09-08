//
//  SessionResponse.swift
//  MovieWorld
//
//   Created by Marimuthu T on 07/09/21.
//

import Foundation


struct SessionResponse : Codable
{
    var success : Bool
    var sessionId : String
    
    enum CodingKeys :String , CodingKey
    {
        case success
        case sessionId = "session_id"
    }
}
