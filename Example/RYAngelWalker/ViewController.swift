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
        let lab = TrotingLabel(frame: CGRect(x: 10, y: 100, width: 111, height: 40))
        lab.backgroundColor = .green
        lab.font = .systemFont(ofSize: 18)
        lab.textColor = .black
        lab.pause = 2
        lab.add("数据结构非常非常恶心，恶心到一定境界了")
        return lab
    }()
}
