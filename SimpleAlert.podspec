Pod::Spec.new do |s|
  s.name         = "SimpleAlert"
  s.version      = "3.1.2"
  s.summary      = "Simply Alert for Swift"
  s.homepage     = "https://github.com/KyoheiG3/SimpleAlert"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Kyohei Ito" => "je.suis.kyohei@gmail.com" }
  s.swift_version = '4.2'
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/KyoheiG3/SimpleAlert.git", :tag => s.version.to_s }
  s.source_files  = "SimpleAlert/**/*.{h,swift,xib}"
  s.requires_arc = true
  s.frameworks = 'UIKit'
end
