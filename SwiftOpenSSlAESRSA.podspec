

Pod::Spec.new do |s|



  s.name         = "SwiftOpenSSlAESRSA"
  s.version      = "1.0.0"
  s.summary      = "Swift OpenSSl AES RSA Encryption to decrypt"


  s.description  = <<-DESC
                   swift 使用OpenSSL 加密
                   DESC

  s.homepage     = "https://github.com/aaaaa893215155/Swift-OpenSSL-AES-RSA"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"





  s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "WangMing" => "893215155@qq.com" }


  s.platform     = :ios, "8.0"


  s.ios.deployment_target = "8.0"


  s.source       = { :git => "https://github.com/aaaaa893215155/Swift-OpenSSL-AES-RSA.git", :tag => s.version.to_s }
  s.source_files  = "Swift OpenSSL AES加密/openssl/**/*.{h,m,a,swift}"
  #s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"
  s.frameworks = "Foundation"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"



  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
