Pod::Spec.new do |s|
  s.name         = "SwiduxRouter"
  s.version      = "0.2.0"
  s.summary      = "iOS router driven by Swidux store."

  s.homepage     = "https://github.com/clmntcrl/swidux-router"

  s.license      =  { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Clément Cyril" => "cyril@clmntcrl.io" }
  s.social_media_url   = "http://twitter.com/clmntcrl"

  s.swift_version = "4.2"

  s.ios.deployment_target = "10.0"

  s.source = {
    :git => "https://github.com/clmntcrl/swidux-router.git",
    :tag => s.version
  }

  s.frameworks = "XCTest"

  s.source_files  = "Sources", "Sources/**/*.swift"

  s.dependency 'Swidux', '~> 1.0.0'
end
