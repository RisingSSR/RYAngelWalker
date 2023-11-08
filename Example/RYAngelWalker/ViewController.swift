//
//  ViewController.swift
//  RYAngelWalker
//
//  Created by RisingSSR on 09/03/2023.
//  Copyright (c) 2023 RisingSSR. All rights reserved.
//

import UIKit
import RYAngelWalker

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(walkerLab)
    }
    
    lazy var walkerLab: TrotingLabel = {
        let lab = TrotingLabel(contentWidth: 120)
        lab.frame.origin = CGPoint(x: 10, y: 100)
        lab.backgroundColor = .blue
        lab.setup { alab in
            alab.backgroundColor = .green
            alab.font = .systemFont(ofSize: 18)
            alab.textColor = .black
            alab.text = "请求前非常非常非常长的文本"
        }
        
        lab.walk()
        
        return lab
    }()
}
