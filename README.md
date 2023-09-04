# RYAngelWalker

[![CI Status](https://img.shields.io/travis/RisingSSR/RYAngelWalker.svg?style=flat)](https://travis-ci.org/RisingSSR/RYAngelWalker)
[![Version](https://img.shields.io/cocoapods/v/RYAngelWalker.svg?style=flat)](https://cocoapods.org/pods/RYAngelWalker)
[![License](https://img.shields.io/cocoapods/l/RYAngelWalker.svg?style=flat)](https://cocoapods.org/pods/RYAngelWalker)
[![Platform](https://img.shields.io/cocoapods/p/RYAngelWalker.svg?style=flat)](https://cocoapods.org/pods/RYAngelWalker)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RYAngelWalker is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RYAngelWalker'
```

## How to use

```Swift
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
```

## Author

RisingSSR, 2769119954@qq.com

## License

RYAngelWalker is available under the MIT license. See the LICENSE file for more info.
