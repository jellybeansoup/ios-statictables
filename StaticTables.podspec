Pod::Spec.new do |s|
  s.name         = "StaticTables"
  s.version      = "0.1.0"
  s.summary      = "A library for easily creating static table views programatically."
  s.homepage     = "https://github.com/jellybeansoup/ios-statictables"
  s.license      = { :type => 'BSD', :file => 'LICENSE' }
  s.author       = { "Daniel Farrelly" => "daniel@jellystyle.com" }
  s.source       = { :git => "https://github.com/jellybeansoup/ios-statictables.git", :tag => "0.1.0" }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'src/StaticTables/*.{h,m}'
  s.public_header_files = 'src/StaticTables/*.h'
end
