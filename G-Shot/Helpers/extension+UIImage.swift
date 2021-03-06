//
//  extension+UIImage.swift
//  G-Shot
//
//  Created by Alexey on 5/11/17.
//  Copyright © 2017 GoTo Inc. All rights reserved.
//

import UIKit
import KRProgressHUD

extension UIImageView {

  func donwnload(from url: URL, completion: @escaping (Bool) -> Void) {
    KRProgressHUD.show()
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      guard let httpURLResponse = response as? HTTPURLResponse,
        httpURLResponse.statusCode == 200,
        let data = data,
        error == nil,
        let image = UIImage(data: data) else {
          completion(false)
          return
      }
      DispatchQueue.main.async {
        self.image = image
        KRProgressHUD.dismiss()
      }
      completion(true)
    }.resume()
  }
}
