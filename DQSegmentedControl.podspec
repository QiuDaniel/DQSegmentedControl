#
#  Be sure to run `pod spec lint DQSegmentedControl.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "DQSegmentedControl"
  spec.version      = "0.0.3"
  spec.summary      = "A drop-in replacement for UISegmentedControl."
  spec.description  = <<-DESC
  A drop-in replacement for UISegmentedControl mimicking the style of the segmented control
                   DESC

  spec.homepage     = "https://github.com/QiuDaniel/DQSegmentedControl"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "qiudan" => "qiudan-098@163.com" }
  spec.platform     = :ios, '8.0'

  spec.source       = { :git => "https://github.com/QiuDaniel/DQSegmentedControl.git", :tag => "#{spec.version}" }

  spec.source_files  = "DQSegmentedControl", "DQSegmentedControl/*.swift"

  spec.requires_arc = true
  spec.swift_version = '4.2'

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
