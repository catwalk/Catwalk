Pod::Spec.new do |spec|

  spec.name         = "Catwalk"
  spec.version      = "0.9.14"
  spec.summary      = "Catwalk's CocoaPods library for you Fashion Virtual Assistant"

  spec.description  = <<-DESC
  Catwalk's SDK let you offer an intelligent Fashion Virtual Assistant to assist your users during their purchase journey on your applications, creating looks, finding similar items, showing item details, gathering information for clothing, managing multiple SKUs for sale and adding them altogheter into your shopping Cart.
                   DESC

  spec.homepage     = "https://github.com/catwalk/Catwalk"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Development" => "development@mycatwalk.com" }
  spec.source       = { :git => "https://github.com/catwalk/Catwalk.git", :tag => "#{spec.version}" }

  spec.source_files  = "Catwalk/**/*.{h,m,swift}"
  spec.ios.deployment_target = "11.0"
  spec.swift_version = "4.2"

  spec.resources = "Catwalk/Resources/*.png"
  spec.dependency "SDWebImage", "~> 5.0"

end
