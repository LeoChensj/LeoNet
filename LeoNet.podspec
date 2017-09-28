#
#  Be sure to run `pod spec lint LeoNet.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "LeoNet"
  s.version      = "1.1"
  s.summary      = "Object-C网络请求框架"
  s.description  = <<-DESC
                   基于AFNetworking的网络请求框架
                   DESC

  s.homepage     = "https://github.com/LeoChensj/LeoNet"
  s.license      = "MIT"
  s.author       = { "LeoChen" => "LeoChensj@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/LeoChensj/LeoNet.git", :tag => "#{s.version}" }
  s.source_files = "LeoNet/*.{h,m}"
  s.public_header_files = "LeoNet/*.h"
  s.requires_arc = true
  s.dependency "AFNetworking"
  s.dependency "GreedJSON"
  s.dependency "MD5Digest"

end
