//
//  Coordinator.swift
//  movieApp
//
//  Created by Karwan on 25/10/2025.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
