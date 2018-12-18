#
#  Be sure to run `pod spec lint RestKit.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.platform = :ios
  s.ios.deployment_target = '12.0'
  s.name         = "SwiftyRestKit"
  s.summary      = "An easy, organized, protocol-oriented way to do REST requests on iOS."
  s.requires_arc = true

  s.version      = "1.0.2"

  s.description  = "SwiftyRestKit is a simple, lightweight library, built using URLSession, to help make REST requests on iOS easier to deal with and more testable."

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Rodolfo Roca" => "rroca1982@gmail.com" }

  s.homepage     = "https://github.com/rroca1982/SwiftyRestKit"

  s.source       = { :git => "https://github.com/rroca1982/SwiftyRestKit.git", :tag => "#{s.version}" }

  s.source_files = "SwiftyRestKit/**/*.{swift}"

  s.swift_version = "4.2"

end
