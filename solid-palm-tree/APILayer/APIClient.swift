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
            let usersDict = response as! NSDictionary
            var users = [User]()
            for (key, value) in usersDict {
                let user = User(apiId: key as! String, apiDictionary: value as! NSDictionary)
                users.append(user)
            }
            completion(users, error)
        }
    }

    func postUser(user: User, completion:@escaping (String?, Error?)->()) {
        let paramDict = user.dict()
        var paramData: Data?
        do {
            paramData = try JSONSerialization.data(
                withJSONObject: paramDict,
                options: JSONSerialization.WritingOptions.prettyPrinted
            )
        } catch {
            // error
        }
        executeRequest(type: .UsersPost, body: paramData) { (response, error) in
            let userDict = response as! NSDictionary
            if let name = userDict["name"] as? String {
                completion(name, nil)
            } else {
                // completion(nil, error)
            }
        }
    }

    func getZones(completion:@escaping ([ParkingZone]?, Error?)->()) {
        executeRequest(type: .ZonesGet) { (response, error) in
            let zonesDict = response as! NSDictionary
            var zones = [ParkingZone]()
            for (key, value) in zonesDict {
                let zone = ParkingZone(apiId: key as! String, apiDictionary: value as! NSDictionary)
                zones.append(zone)
            }
            completion(zones, error)
        }
    }

    func getParkingActions(completion:@escaping ([ParkingAction]?, Error?)->()) {
        executeRequest(type: .ParkingActionGet) { (response, error) in
            let actionsDict = response as! NSDictionary
            var actions = [ParkingAction]()
            for (key, value) in actionsDict {
                let action = ParkingAction(apiId: key as! String, apiDictionary: value as! NSDictionary)
                actions.append(action)
            }
            completion(actions, error)
        }
    }

    func postParkingAction(action: ParkingAction, completion:@escaping (String?, Error?)->()) {
        let paramDict = action.dict()
        var paramData: Data?
        do {
            paramData = try JSONSerialization.data(
                withJSONObject: paramDict,
                options: JSONSerialization.WritingOptions.prettyPrinted
            )
        } catch {
            // error
        }
        executeRequest(type: .ParkingActionPost, body: paramData) { (response, error) in
            let actionDict = response as! NSDictionary
            if let name = actionDict["name"] as? String {
                completion(name, nil)
            } else {
                // completion(nil, error)
            }
        }
    }

    func patchParkingAction(action: ParkingAction, completion:@escaping (Error?)->()) {
        let paramDict = action.endDateDict()
        var paramData: Data?
        do {
            paramData = try JSONSerialization.data(
                withJSONObject: paramDict,
                options: JSONSerialization.WritingOptions.prettyPrinted
            )
        } catch {
            // error
        }
        let additionalPath = action.actionId!
        executeRequest(type: .ParkingActionPatch, body: paramData, additionalPath: additionalPath) { (response, error) in
            completion(error)
        }
    }


    // MARK: - Private
    private func executeRequest(type: APIRequestType, body: Data? = nil, additionalPath: String? = nil, completion: @escaping RequestCompletion) {
        queue.sync {
            var url = type.url()
            if additionalPath != nil {
                url = url.appendingPathComponent(additionalPath! + ".json")
            }
            var request = URLRequest(url: url)
            request.httpMethod = type.httpMethod()
            request.httpBody = body
            let task = session.dataTask(
                with: request,
                completionHandler: { [weak self] (data, response, error) in
                    self?.processResponse(responseData: data, error: error, completion: completion)
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
    case UsersPost
    case ZonesGet
    case ParkingActionPost
    case ParkingActionGet
    case ParkingActionPatch

    func url() -> URL {
        switch self {
        case .UsersGet, .UsersPost:
            return url(specialPath: "users.json")
        case .ZonesGet:
            return url(specialPath: "parkingZones.json")
        case .ParkingActionPost, .ParkingActionGet:
            return url(specialPath: "parkingActions.json")
        case .ParkingActionPatch:
            return url(specialPath: "parkingActions")
        }
    }

    func httpMethod() -> String {
        switch self {
        case .ParkingActionPost, .UsersPost:
            return "POST"
        case .ParkingActionPatch:
            return "PATCH"
        default:
            return "GET"
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
