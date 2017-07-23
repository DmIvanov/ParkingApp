//
//  APIClient.swift
//  solid-palm-tree
//
//  Created by Dmitrii on 22/07/2017.
//  Copyright © 2017 DI. All rights reserved.
//

import Foundation

typealias RequestCompletion = (Any?, Error?) -> ()


class APIClient: NSObject {

    // MARK: - Properties
    private let queue = DispatchQueue(label: "APIRequestsQueue")
    private lazy var session: URLSession = URLSession(configuration: .default)

    // MARK: - Lyfecycle


    // MARK: - Public
    func getUsers(completion:@escaping ([User]?, Error?)->()) {
        executeRequest(type: .UsersGet) { (response, error) in
            let usersArray = response as! NSDictionary
            var users = [User]()
            for (key, value) in usersArray {
                let user = User(apiId: key as! String, apiDictionary: value as! NSDictionary)
                users.append(user)
            }
            completion(users, error)
        }
    }

    func getZones(completion:@escaping ([ParkingZone]?, Error?)->()) {
        executeRequest(type: .ZonesGet) { (response, error) in
            let zonesArray = response as! NSDictionary
            var zones = [ParkingZone]()
            for (key, value) in zonesArray {
                let zone = ParkingZone(apiId: key as! String, apiDictionary: value as! NSDictionary)
                zones.append(zone)
            }
            completion(zones, error)
        }
    }


    // MARK: - Private
    private func executeRequest(type: APIRequestType, completion: @escaping RequestCompletion) {
        queue.sync {
            let task = session.dataTask(
                with: type.url(),
                completionHandler: { (data, response, error) in
                    self.processResponse(responseData: data, error: error, completion: completion)
            })
            task.resume()
        }
    }

    private func processResponse(responseData: Data?, error: Error?, completion: RequestCompletion) {
        if responseData != nil {
            do {
                let resp = try JSONSerialization.jsonObject(
                    with: responseData!,
                    options: JSONSerialization.ReadingOptions.mutableContainers
                )
                completion(resp, nil)
            } catch {
                print("Error. JSON Serialization")
                //let err = NSError(domain: <#T##String#>, code: <#T##Int#>, userInfo: <#T##[AnyHashable : Any]?#>)
                //completion(nil, err)
            }
        } else {
            completion(nil, error)
        }
    }
}


enum APIRequestType {
    case UsersGet
    case ZonesGet

    func url() -> URL {
        switch self {
        case .UsersGet:
            return url(specialPath: "users.json")
        case .ZonesGet:
            return url(specialPath: "parkingZones.json")
        }
    }

    private func url(specialPath: String) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "testapi-11cc3.firebaseio.com"
        components.path = "/\(specialPath)"
        return components.url!
    }
}
