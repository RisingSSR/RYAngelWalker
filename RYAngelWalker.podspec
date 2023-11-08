#
# Be sure to run `pod lib lint RYAngelWalker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RYAngelWalker'
  s.version          = '0.2.2'
  s.summary          = 'RYAngelWalker 跑马灯效果 Swift'

  s.homepage         = 'https://github.com/RisingSSR/RYAngelWalker'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'RisingSSR' => '2769119954@qq.com' }
  s.source           = { :git => 'https://github.com/RisingSSR/RYAngelWalker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'

  s.source_files = 'RYAngelWalker/Classes/**/*.swift'

  s.frameworks       = 'UIKit', 'Foundation'
  s.swift_version    = '4.8'
end
