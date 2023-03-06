//
//  ViewController.swift
//  HearXProject
//
//  Created by Mihlali Mazomba on 2023/03/05.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func startButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "TestScreenSegue", sender: sender)
    }
}

