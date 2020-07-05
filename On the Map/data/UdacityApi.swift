//
//  UdacityApi.swift
//  On the Map
//
//  Created by Nitin Anand on 04/07/20.
//  Copyright © 2020 NI3X. All rights reserved.
//

import Foundation
class UdacityApi {
    enum Endpoints : String {
        case randomImageFromCollection = "https://dog.ceo/api/breeds/image/random"
        
        case getUsers = "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt"
        
        
        var url:URL {
            return URL(string: self.rawValue)!
        }
    }
    
    
    
    class func postUserLocation(completionHandler: @escaping(String?, Error?)->Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler("suceess", nil)
            print(String(data: data, encoding: .utf8)!)
        }.resume()
    }
    
    
    class func getUsers(completionHandler: @escaping (UserResponse?, Error?)->Void) {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let results = try! decoder.decode(UserResponse.self, from: data)
            completionHandler(results, nil)
        }.resume()
    }
    
    class func getSession(_ username:String, _ password:String, completionHandler: @escaping (String?, Error?)->Void){
        let post = UdacityUserRequest(udacity:UserSession(username:username, password:password))
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(post)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("data is empty")
                completionHandler(nil, error)
                return
            }
            
//            guard let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode) else {
//                    completionHandler(nil, error)
//                    return
//            }
            
        
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            let responseString = String(data: newData, encoding: .utf8)
            print(responseString)
            completionHandler("success", nil)
        }.resume()
    }
    
    
    
}
