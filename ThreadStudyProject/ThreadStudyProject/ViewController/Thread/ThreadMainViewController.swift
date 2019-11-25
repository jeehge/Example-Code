//
//  ThreadMainViewController.swift
//  ThreadStudyProject
//
//  Created by JH on 22/11/2019.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit

class ThreadMainViewController: UIViewController {

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

class RamenProgram {
    
}

class RamenCook {
    
    private var ramenCount: Int
    private var burners: [String] = ["_", "_", "_", "_"]
    
    init(count: Int) {
        ramenCount = count
    }
    
    func run() {
        while ramenCount > 0 {
           
        }
    }
}
