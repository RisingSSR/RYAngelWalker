//
//  TrotingLabel.swift
//  RYAngelWalker
//
//  Created by SSR on 2023/9/4.
//

import UIKit

open class TrotingLabel: AngelWalker {
    
    public enum TrotingRate: Int, @unchecked Sendable {
        
        case normal
        
        case slowly
        
        case fast
    }
    
    // MARK: property
    
    open var rate: TrotingRate = .normal
    
    open var repeatTextArr: Bool = true
    
    open var hideWhenStoped: Bool = true {
        didSet {
            isHidden = hideWhenStoped
        }
    }
    
    private lazy var label: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .clear
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    
    private var index: Int = 0
    
    // MARK: init
    
    public override init(contentWidth: CGFloat) {
        super.init(contentWidth: contentWidth)
        setupInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInit()
    }
    
    func setupInit() {
        
    }
    
    // MARK: method
    
    open func setup(data: (UILabel) -> ()) {
        data(label)
        label.sizeToFit()
        label.frame.origin = .zero
        walkerView = label
    }
}
