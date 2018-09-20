//
//  ViewController.swift
//  CustomSDK
//
//  Created by webwerks on 9/20/18.
//  Copyright © 2018 Pradeep. All rights reserved.
//

import UIKit
import CustomFramework

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let operation = ArithmeticOperation()
        print(operation.addition(ofTwoNumber: 20, secondNumber: 30))
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

