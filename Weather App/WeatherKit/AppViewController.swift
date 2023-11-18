//
//  AppViewController.swift
//  Weather App
//
//  Created by Felipe C. Araujo on 18/11/23.
//

import UIKit

protocol AppViewController {
    associatedtype CustomView
    var customView: CustomView { get set }
}
