#
#  Be sure to run `pod spec lint DQSegmentedControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "DQSegmentedControl"
  spec.version      = "0.1.1"
  spec.summary      = "A drop-in replacement for UISegmentedControl."
  spec.description  = <<-DESC
  A drop-in replacement for UISegmentedControl mimicking the style of the segmented control
                   DESC

  spec.homepage     = "https://github.com/QiuDaniel/DQSegmentedControl"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "qiudan" => "qiudan-098@163.com" }
  spec.platform     = :ios, '8.0'

  spec.source       = { :git => "https://github.com/QiuDaniel/DQSegmentedControl.git", :tag => "#{spec.version}" }


  spec.requires_arc = true
  spec.swift_version = '4.2'
  spec.default_subspec = "Core"

  spec.subspec "Core" do |core|
    core.source_files = "DQSegmentedControl/*.swift"
  end

  spec.subspec "Rx" do |rx|
    rx.source_files = "DQSegmentedControl", "DQSegmentedControl/Rx"
    rx.dependency 'RxSwift', '>=4.5.0'
    rx.dependency 'RxCocoa', '>=4.5.0'
  end

end
