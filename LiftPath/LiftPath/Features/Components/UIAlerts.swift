//
//  UIAlerts.swift
//  LiftPath
//
//  Created by Evan Huang on 12/8/24.
//  Details: Experimentations with Alerts (might not implement)

import SwiftUI

struct AlertView: UIViewControllerRepresentable {
    var title: String
    var message: String
    var actions: [UIAlertAction]

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { alert.addAction($0) }
        uiViewController.present(alert, animated: true)
    }
}
