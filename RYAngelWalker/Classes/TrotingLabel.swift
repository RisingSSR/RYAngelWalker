//
//  TrotingLabel.swift
//  RYAngelWalker
//
//  Created by SSR on 2023/9/4.
//

import UIKit

open class TrotingLabel: AngelWalker {

    public typealias TrotingBlock = (TrotingAttribute) -> ()
    
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
    
    open var font: UIFont = .systemFont(ofSize: 14) {
        didSet {
            label.font = font
        }
    }
    
    open var textColor: UIColor = .black {
        didSet {
            label.textColor = textColor
        }
    }
    
    private lazy var label: UILabel = {
        let lab = UILabel()
        lab.backgroundColor = .clear
        lab.textColor = .black
        lab.font = .systemFont(ofSize: 14)
        return lab
    }()
    
    private lazy var attrivuteArrs: [TrotingAttribute] = []
    
    private var index: Int = 0
    
    private var trotingBlock: TrotingBlock? = nil
    
    private var currentAttribute: TrotingAttribute? = nil
    
    // MARK: init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupInit()
    }
    
    private func setupInit() {
        walkStart { [weak self] in
            guard let self else { return }
            if let currentAttribute = self.currentAttribute {
                self.trotingBlock?(currentAttribute)
            }
        }
        
        walkFinished { [weak self] in
            guard let self else { return }
            
            if self.attrivuteArrs.count == 0 {
                self.index = 0
                if self.hideWhenStoped {
                    self.isHidden = true
                }
                return
            }
            
            if self.index < self.attrivuteArrs.count - 1 {
                self.index += 1
            } else {
                self.index = 0
                
                if !self.repeatTextArr {
                    if self.hideWhenStoped {
                        self.isHidden = true
                    }
                    return
                }
            }
            
            self.add(self.attrivuteArrs[self.index])
        }
    }
    
    // MARK: override
    
    open override func walk() {
        if attrivuteArrs.count > 0 {
            super.walk()
        }
    }
    
    // MARK: method
    
    private func setNeedsTroting() {
        if !isWalking && attrivuteArrs.count > 0 {
            add(attrivuteArrs[index])
        }
    }
    
    private func calcuteDuration() {
        switch rate {
        case .normal:
            duration = (type == .default ? 3 : 0.8)
        case .slowly:
            duration = (type == .default ? 8 : 2)
        case .fast:
            duration = (type == .default ? 1 : 0.2)
        }
    }
    
    open func add(_ text: String?) {
        add([text])
    }
    
    open func add(_ texts: [String?]) {
        var textArrs = [TrotingAttribute]()
        for text in texts {
            let attribute = TrotingAttribute(text: text)
            textArrs.append(attribute)
        }
        add(textArrs)
    }
    
    open func add(_ attributes: [TrotingAttribute]) {
        if attributes.count == 0 { return }
        attrivuteArrs += attributes
        setNeedsTroting()
    }
    
    open func add(_ attribute: TrotingAttribute) {
        if walerView == nil {
            add(walkerView: label)
        }
        
        currentAttribute = attribute
        isHidden = false
        
        if let attributedText = attribute.attribute {
            label.attributedText = attributedText
        } else {
            label.text = attribute.text
        }
        
        let textSize = label.text?.size(withAttributes: [.font: label.font])
        label.frame.size = textSize ?? .zero
        
        calcuteDuration()
        updateWalerViewsFrame()
        walk()
    }
    
    open func add(_ attributes: TrotingAttribute, at index: Int) {
        if (index > attrivuteArrs.count - 1 || attrivuteArrs.count == 0) && index != 0 {
            return
        }
        attrivuteArrs.insert(attributes, at: index)
        setNeedsTroting()
    }
    
    open func remove(at index: Int) {
        if index > attrivuteArrs.count - 1 || attrivuteArrs.count == 0 {
            return
        }
        attrivuteArrs.remove(at: index)
        setNeedsTroting()
    }
    
    open func removeAll() {
        if attrivuteArrs.count > 0 {
            attrivuteArrs.removeAll()
        }
    }
    
    open func trotingAttribute(handle: @escaping TrotingBlock) {
        trotingBlock = handle
    }
}
