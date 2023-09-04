//
//  AngelWalker.swift
//  RYAngelWalker
//
//  Created by SSR on 2023/9/3.
//

import UIKit

open class AngelWalker: UIView {
    
    public typealias AngelWalker_P0_Block = () -> ()

    public enum WalkerType {
        
        case `default`  // from right to left
        
        case descend    // from top to bottom
    }
    
    // MARK: property
    
    open var backgroundImage: UIImage? = nil {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    open var duration: TimeInterval = 1
    
    open var pause: TimeInterval = 0
    
    open var type: WalkerType = .default
    
    open var walerView: UIView? = nil
    
    open private(set) lazy var contentView: UIView = {
        let contentView = UIView(frame: bounds)
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.clipsToBounds = true
        contentView.backgroundColor = .clear
        return contentView
    }()
    
    open var leftView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let leftView {
                let leftSize = leftView.frame.size
                leftView.frame = CGRect(x: 0, y: (aSize.height - leftSize.height) / 2, width: leftSize.width, height: leftSize.height)
                addSubview(leftView)
                updateContentFrame()
            }
        }
    }
    
    open var rightView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()
            if let rightView {
                let rightSize = rightView.frame.size
                rightView.frame = CGRect(x: aSize.width - rightSize.width, y: (aSize.height - rightSize.height) / 2, width: rightSize.width, height: rightSize.height)
                addSubview(rightView)
                updateContentFrame()
            }
        }
    }
    
    open var isWalking: Bool = false
    
    open var `repeat`: Bool = false
    
    // MARK: private
    
    private lazy var backgroundImageView: UIImageView = {
        let imgView = UIImageView(frame: bounds)
        imgView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        imgView.isUserInteractionEnabled = true
        return imgView
    }()

    private var aSize: CGSize = .zero
    
    private var wSize: CGSize = .zero
    
    private var frameBegin: CGRect = .zero
    
    private var frame1: CGRect = .zero
    
    private var frame2: CGRect = .zero
    
    private var frameEnd: CGRect = .zero
    
    private var finishedBlock: AngelWalker_P0_Block? = nil
    
    private var startBlock: AngelWalker_P0_Block? = nil
    
    // MARK: init
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupContentView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupContentView()
    }
    
    private func setupContentView() {
        addSubview(backgroundImageView)
        addSubview(contentView)
    }
    
    // MARK: Method
    
    open func add(walkerView: UIView) {
        self.walerView?.removeFromSuperview()
        self.walerView = walkerView
        updateWalerViewsFrame()
        contentView.addSubview(walkerView)
    }
    
    open func walkStart(complication: @escaping AngelWalker_P0_Block) {
        startBlock = complication
    }
    
    open func walkFinished(complication: @escaping AngelWalker_P0_Block) {
        finishedBlock = complication
    }
    
    internal func updateWalerViewsFrame() {
        wSize = walerView?.frame.size ?? .zero
    }
    
    private func updateContentFrame() {
        contentView.frame = CGRect(x: leftView?.frame.maxX ?? 0, y: 0, width: aSize.width - (leftView?.frame.width ?? 0), height: aSize.height)
    }
    
    // MARK: life
    
    open func walk() {
        if isWalking { return }
        calculate()
        addAnimations()
    }
    
    open func stop() {
        walerView?.layer.removeAllAnimations()
        walerView?.frame = frameBegin
        isWalking = false
    }
    
    private func calculate() {
        switch type {
            
        case .default:
            let y: CGFloat = 0
            frameBegin = CGRect(x: 0, y: y, width: wSize.width, height: wSize.height)
            frame1 = CGRect(x: -wSize.width, y: y, width: wSize.width, height: wSize.height)
            frame2 = CGRect(x: contentView.frame.width, y: y, width: wSize.width, height: wSize.height)
            frameEnd = CGRect(x: 0, y: y, width: wSize.width, height: wSize.height)
            
        case .descend:
            frameBegin = CGRect(x: 0, y: -wSize.height, width: wSize.width, height: wSize.height)
            frame1 = CGRect(x: 0, y: (aSize.height - wSize.height) / 2, width: wSize.width, height: wSize.height)
            if wSize.width > contentView.frame.width {
                frame2 = CGRect(x: -(wSize.width - contentView.frame.width), y: frame1.minY, width: wSize.width, height: wSize.height)
            } else {
                frame2 = frame1
            }
            frameEnd = CGRect(x: frame2.minX, y: aSize.height, width: wSize.width, height: wSize.height)
        }
    }
        
    private func addAnimations() {
        stop()
        isHidden = false
        
        if type == .default && wSize.width < contentView.frame.width { return }
        
        isWalking = true
        startBlock?()
        
        var velocity = duration
        
        switch type {
            
        case .default:
            velocity = frameBegin.origin.x - frame1.origin.x / duration
            addDefualtAnimation(velocity: velocity)
            
        case .descend:
            velocity = frame1.origin.y - frameBegin.origin.y / duration
        }
    }
    
    private func addDefualtAnimation(velocity: CGFloat) {
        let trueDuration = wSize.width / (contentView.frame.width / duration)
        UIView.animate(withDuration: trueDuration, delay: pause, options: .curveLinear) { [weak self] in
            guard let self else { return }
            self.walerView?.frame = self.frame1
        } completion: { [weak self] finished in
            guard let self else { return }
            if finished {
                self.walerView?.frame = self.frame2
                UIView.animate(withDuration: self.duration, delay: 0, options: .curveLinear) { [weak self] in
                    guard let self else { return }
                    self.walerView?.frame = self.frameEnd
                } completion: { [weak self] finished in
                    guard let self else { return }
                    self.stop()
                    if finished {
                        self.finishedBlock?()
                        if self.repeat {
                            self.addAnimations()
                        }
                    }
                }
            } else {
                self.stop()
            }
        }
    }
    
    private func addDescendAnimation(velocity: CGFloat) {
        UIView.animate(withDuration: duration, delay: 0) { [weak self] in
            guard let self else { return }
            self.walerView?.frame = self.frame1
        } completion: { [weak self] finished in
            guard let self else { return }
            if finished {
                if self.wSize.width > self.contentView.frame.width {
                    UIView.animate(withDuration: (self.frame1.size.width - self.contentView.frame.width) / velocity, delay: self.pause) { [weak self] in
                        guard let self else { return }
                        self.walerView?.frame = self.frame2
                    } completion: { [weak self] finished in
                        guard let self else { return }
                        self.stop()
                        if finished {
                            self.finishedBlock?()
                            if self.repeat {
                                self.addAnimations()
                            }
                        }
                    }
                } else {
                    UIView.animate(withDuration: self.duration, delay: self.pause) { [weak self] in
                        guard let self else { return }
                        self.walerView?.frame = self.frameEnd
                    } completion: { [weak self] finished in
                        guard let self else { return }
                        self.stop()
                        if finished {
                            self.finishedBlock?()
                            if self.repeat {
                                self.addAnimations()
                            }
                        }
                    }
                }
            } else {
                self.stop()
            }
        }
    }
    
}
