//
//  AngelWalker.swift
//  RYAngelWalker
//
//  Created by SSR on 2023/11/7.
//

import UIKit

open class AngelWalker: UIView {

    public typealias AngelWalker_P0_Block = () -> ()
    
    public enum WalkerType {
        
        case `default`  // from right to left
        
        case descend    // from top to bottom
    }
    
    var walkerType: WalkerType = .default
    
    var spaceBetweenItems: CGFloat = 20
    
    var parkingTimeOfWalker: TimeInterval = 2
    
    var animateTimeIntervalPer100Move: TimeInterval = 2
    
    var duration: TimeInterval {
        (copyWalkerView?.frame.minX ?? 0) / 100.0 * animateTimeIntervalPer100Move
    }
    
    public var contentWidth: CGFloat {
        set { frame.size.width = newValue }
        get { bounds.width }
    }
    
    // MARK: init
    
    private convenience init() {
        self.init(contentWidth: 100)
    }
    
    deinit {
        timer.setEventHandler { }
        timer.setCancelHandler { }
        timer.cancel()
    }
    
    public init(contentWidth: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: contentWidth, height: 0))
        commitInit()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    open override func encode(with coder: NSCoder) {
        super.encode(with: coder)
        commitInit()
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        if let value = walkerView {
            size.height = value.bounds.height
        }
        return size
    }
    
    func commitInit() {
        super.addSubview(contentView)
    }
    
    // MARK: override
    
    open override func addSubview(_ view: UIView) {
        contentView.addSubview(view)
    }
    
    // MARK: property
    
    lazy var contentView: UIView = {
        let contentView = UIView(frame: bounds)
        contentView.backgroundColor = .clear
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        return contentView
    }()
    
    lazy var timer: DispatchSourceTimer = {
        let queue = DispatchQueue.global(qos: .default)
        return DispatchSource.makeTimerSource(queue: queue)
    }()
    
    var walkerView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            copyWalkerView?.removeFromSuperview()
            if let newValue = walkerView, 
                let newCopyValue = copyByKeyedArchiver(newValue) {
                copyWalkerView = newCopyValue
                addSubview(newValue)
                addSubview(newCopyValue)
                updateContentFrame()
            }
        }
    }
    
    private var copyWalkerView: UIView?
    
    private var walkIfLongerThanSelf: Bool = true
    
    // MARK: method
    
    func updateContentFrame() {
        if let value = walkerView, let copyValue = copyWalkerView {
            value.frame.origin = CGPoint(x: 0, y: 0)
            frame.size.height = value.bounds.height
            switch walkerType {
            case .default:
                let maxWidth = max(bounds.width, value.frame.maxX + spaceBetweenItems)
                copyValue.frame.origin = CGPoint(x: maxWidth, y: 0)
            case .descend:
                copyValue.frame.origin = CGPoint(x: 0, y: bounds.height)
            }
        }
    }
    
    func animateAnimations() {
        guard let walkerView = walkerView,
                let copyWalkerView = copyWalkerView else { return }
        switch walkerType {
        case .default:
            walkerView.frame.origin = CGPoint(x: -copyWalkerView.frame.minX, y: 0)
            copyWalkerView.frame.origin = CGPoint(x: 0, y: 0)
        case .descend:
            walkerView.frame.origin = CGPoint(x: 0, y: -walkerView.bounds.height)
            copyWalkerView.frame.origin = CGPoint(x: 0, y: 0)
        }
    }
    
    func animateCompletion() {
        updateContentFrame()
    }
    
    open func walk(ifLongerThanSelf: Bool = true) {
        if ifLongerThanSelf {
            guard let walkerView = walkerView, bounds.width < walkerView.bounds.width else {
                return
            }
        }
        
        timer.setEventHandler { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIView.animate(withDuration: self.duration) {
                    self.animateAnimations()
                } completion: { _ in
                    self.animateCompletion()
                    self.resume()
                }
            }
        }
        
        resume()
    }
    
    func resume() {
        timer.schedule(deadline: .now() + parkingTimeOfWalker, repeating: .infinity)
        timer.activate()
    }
}

private func copyByKeyedArchiver<T>(_ copyFrom: T) -> T? where T: NSCoding {
    let requiringSecureCoding = copyFrom is NSSecureCoding
    let archiver = NSKeyedArchiver(requiringSecureCoding: requiringSecureCoding)
    archiver.encode(copyFrom, forKey: "ry_copyed")
    let data = archiver.encodedData
    let unArchiver = try? NSKeyedUnarchiver(forReadingFrom: data)
    unArchiver?.requiresSecureCoding = requiringSecureCoding
    return unArchiver?.decodeObject(forKey: "ry_copyed") as? T
}
