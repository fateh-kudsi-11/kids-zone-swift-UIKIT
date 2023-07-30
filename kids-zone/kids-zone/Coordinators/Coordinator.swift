//
//  Coordinator.swift
//  test500
//
//  Created by user on 26.06.2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    func navigate(to type: String)

    func start()
    func presentAuth()
    func hideAuth()
}

protocol Coordinating {
    var coordinator: Coordinator? { get set }
}
