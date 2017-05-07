//
// Created by alexey on 5/6/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit
import KRProgressHUD

class NetworkLayer {

    static func login(user name: String, password: String, completion: @escaping (_ success: Bool) -> ()) {
        let urlString = baseURL + userName + name + "&" + userPassword + password
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        let request = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            if httpResponse.statusCode != 200 {
                completion(false)
                return
            }
            guard let data = data else {
                completion(false)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                guard let apiNumber = json?[apiNum] as? String else {
                    completion(false)
                    return
                }
                let apiMessage = json?[apiMsg] as? String

                if apiMessage == "ACTIVE" {
                    completion(true)
                    return
                } else {
                    switch apiNumber {
                        case "-1":
                            completion(false)
                            return
                        case "-2":
                            completion(false)
                            return
                        case "-3":
                            completion(false)
                            return
                        default:
                            completion(false)
                            return
                    }
                }
            } catch {
                completion(false)
                return
            }
         }
        task.resume()
    }
}
