//
// Created by alexey on 5/6/17.
// Copyright (c) 2017 GoTo Inc. All rights reserved.
//

import UIKit
import KRProgressHUD

class NetworkLayer {

    static func getWatermarkURLs(user: String, key: String, completion: @escaping (_ success: Bool, [String]?) -> ()) {
        let urlString = baseURL + userId + user + "&" + secure + key + "&files=1"
        guard let url = URL(string: urlString) else {
            completion(false, nil)
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(false, nil)
                return
            }
            if httpResponse.statusCode != 200 {
                completion(false, nil)
            }
            guard let data = data else {
                completion(false, nil)
                return
            }
            var json: [String: String]?
            do {
                json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: String]
            } catch {
                completion(false, nil)
            }
            if let json = json {
                var watermarks: [String] = []
                for watermark in json {
                    let key = watermark.key
                    if key.contains("apifile") {
                        watermarks.append(watermark.value)
                    }
                }
                completion(true, watermarks)
            }
         }
        task.resume()
    }

    static func login(user name: String, key: String, completion: @escaping (_ success: Bool) -> ()) {
        let urlString = baseURL + userId + name + "&" + secure + key
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
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
            }
         }
        task.resume()
    }
}
