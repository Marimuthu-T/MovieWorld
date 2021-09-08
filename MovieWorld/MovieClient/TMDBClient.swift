//
//  TMDBClient.swift
//  MovieWorld
//
//   Created by Marimuthu T on 07/09/21.
//

import Foundation

class TMDBClient {
    
    static let apiKey = "d3ba3d983ffe2da5e84f4dc147e1f710"
    
    struct Auth {
        static var accountId = 0
        static var requestToken = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        static let apiKeyParam = "?api_key=\(TMDBClient.apiKey)"
        
        case getWatchlist
        case getRequestToken
        case login
        case getSessionId
        case movieSearch
        case posterLoader
        
        var stringValue: String {
            switch self {
            case .getWatchlist: return Endpoints.base + "/account/\(Auth.accountId)/watchlist/movies" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .getRequestToken:
                return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam
            case .login:
                return Endpoints.base + "/authentication/token/validate_with_login" + Endpoints.apiKeyParam
            case .getSessionId:
                return Endpoints.base + "/authentication/session/new" + Endpoints.apiKeyParam
            case .movieSearch:
                return Endpoints.base + "/search/movie" + Endpoints.apiKeyParam + "&language=en-US&page=1&include_adult=false&query="
            case .posterLoader:
                return "https://image.tmdb.org/t/p/w500/"
            }
            
        }
        
        
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        func urlWithQuery(query : String) -> URL?
        {
            let urlString = self.stringValue + query
            
            if let url = URL(string: urlString)
            {
                return url
            }
            else
            {
                return nil
            }
        }
    }
    
    class func getWatchlist(completion: @escaping ([Movie], Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getWatchlist.url) { data, response, error in
            guard let data = data else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(MovieResults.self, from: data)
                completion(responseObject.results, nil)
            } catch {
                completion([], error)
            }
        }
        task.resume()
    }
    
    class func getRequestToken(CompletionHandler : @escaping (Bool , Error?) -> Void ) -> Void
    {
        let session = URLSession.shared
        let endPoint  = Endpoints.getRequestToken
        
        
        session.dataTask(with: endPoint.url)
        {
            (data , responce , error) in
            guard error == nil else
            {
                return
            }
            if let requestToken = try? JSONDecoder().decode(RequestTokenResponse.self, from: data!)
            {
                Auth.requestToken = requestToken.requestToken
                CompletionHandler(true , nil)
            }
            else
            {
                CompletionHandler(false, error)
            }
        }.resume()
    }
    
    class func loginRequest(username : String , password : String , completionHandler : @escaping (Bool , Error?) -> Void)
    {
        let session = URLSession.shared
        
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(userName: username, password: password, requestToken: Auth.requestToken)
        request.httpBody = try? JSONEncoder().encode(body)
        
        session.dataTask(with: request )
        {
            ( data , _ , error ) in
            guard let data = data else
            {
                completionHandler(false , error)
                return
            }
            do{
                let response = try JSONDecoder().decode(RequestTokenResponse.self, from: data)
                print(Auth.requestToken)
                print(response.requestToken)
                Auth.requestToken = response.requestToken
                completionHandler(true , nil)
            }
            catch
            {
                completionHandler(false , error)
            }
            
        }.resume()
    }
    
    class func imageLoader(forPath url : String , completionHandler : @escaping (Data? , Bool , Error? ) -> Void)
    {
        let session = URLSession.shared
        guard let url = Endpoints.posterLoader.urlWithQuery(query: url) else
        {
            completionHandler(nil , false , nil)
            return
        }
        session.dataTask(with: url)
        {
            (data , _ , error) in
            guard error == nil else
            {
                completionHandler(nil , false , error)
                return
            }
            if let data = data
            {
                completionHandler(data , true , nil)
            }
            else
            {
                completionHandler(nil ,false , nil)
            }
        }.resume()
    }
    
    class func movieSearch(for searchQuery : String , completionHandler : @escaping (MovieResults? , Bool , Error?) -> Void ) -> URLSessionTask?
    {
        let session = URLSession.shared
        guard let url = Endpoints.movieSearch.urlWithQuery(query: searchQuery) else
        {
            completionHandler(nil ,false , nil)
            return nil
        }
        print(url)
        let task = session.dataTask(with: url)
        {
            (data,_,error) in
            guard error == nil else
            {
                completionHandler(nil ,false , error)
                return
            }
            if let data = data
            {
                do{
                let resultData = try JSONDecoder().decode(MovieResults.self, from: data)
                    completionHandler(resultData , true , nil)
                }
                catch{
                    completionHandler(nil ,false,error)
                }
                

            }
            
        }
        return task
        
         
    }
    
    class func sessionId(completionHandler : @escaping (Bool , Error?) -> Void)
    {
        let session = URLSession.shared
        
        var request = URLRequest(url: Endpoints.getSessionId.url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = SessionRequest(requestToken: Auth.requestToken)
        request.httpBody = try? JSONEncoder().encode(body)
        session.dataTask(with: request)
        {
            (data , _ , error) in
            guard let data = data , error ==  nil else
            {
                return
            }
            do
            {
                let reponse = try JSONDecoder().decode(SessionResponse.self , from: data)
                
                Auth.sessionId = reponse.sessionId
                completionHandler(true , nil)
            }
            catch{
                completionHandler(false , error)
            }
        }.resume()
        
    }
    
}
