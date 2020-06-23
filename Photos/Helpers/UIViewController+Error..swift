//
//  UIViewController+Alert.swift
//  Photos
//
//  Created by Elizaveta Konysheva on 23.06.20.
//  Copyright © 2020 Elizaveta Konysheva. All rights reserved.
//

import UIKit

extension UIViewController {
    func displayError(with title: String) {
        let alert = UIAlertController(title: "Oops!", message: title, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

