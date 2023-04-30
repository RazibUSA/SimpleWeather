//
//  ViewController.swift
//  Weather
//
//  Created by Rimo Tech  on 4/29/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    
    lazy var weatherViewModel = WeatherViewModel(weatherFetcher: WeatherDataFetcher())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadSwiftUIView()
    }

    func loadSwiftUIView() {
        let weatherView = WeatherMainView(viewModel: weatherViewModel)
        let childView = UIHostingController(rootView: weatherView)
        addChild(childView)
        childView.view.frame = mainView.bounds
        mainView.addSubview(childView.view)
        childView.didMove(toParent: self)
        
    }
}

