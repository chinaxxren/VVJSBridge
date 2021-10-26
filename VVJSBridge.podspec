
Pod::Spec.new do |spec|
  spec.name         = "VVJSBridge"
  spec.version      = "0.0.1"
  spec.summary      = "VVJSBridge是JS与Native交互库"
  spec.homepage     = "https://github.com/chinaxxren/VVJSBridge"
  spec.license      = "MIT"
  spec.author       = { "chinaxxren" => "jiangmingz@qq.com" }
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "git@github.com:chinaxxren/VVJSBridge.git", :tag => "#{spec.version}" }
  spec.public_header_files = 'VVJSBridge/Classes/**/*.h'
  spec.source_files = 'Source/Classes/**/*'
  spec.resources = 'Source/Resources/*.js'
  spec.frameworks  = "UIKit"
end
