//
//  SearchResultTabbarController.swift
//  MovieWorld
//
//  Created by Marimuthu T on 07/09/21.
//

import UIKit

class SearchResultTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let viewController1 = ListViewController()
        let viewController2 = ResultCollectionViewController()
        
        viewController1.title = "VC1"
       
        
        viewController2.title = "VC2"
        
       
        
        self.viewControllers = [viewController1 , viewController2]
    }
    
}
