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
    
    
    
    class func getUsers() {
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/StudentLocation?order=-updatedAt")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func getSession(){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"nitinnatural@gmail.com\", \"password\": \"Xn1t1n_07U\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print(error?.localizedDescription)
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }
    
//    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?)->Void) {
//        URLSession.shared.dataTask(with: Endpoints.randomImageFromCollection.url) { (data, response, error) in
//            guard let data = data else {
//                print("data is empty")
//                completionHandler(nil, error)
//                return
//            }
//            print(data)
//            let decoder = JSONDecoder()
//            let imageData = try! decoder.decode(DogImage.self, from: data)
//            completionHandler(imageData, nil)
//            }.resume()
//    }
    
    
    
}
