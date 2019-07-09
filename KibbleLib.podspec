#
# Be sure to run `pod lib lint KibbleLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KibbleLib'
  s.version          = '0.1.1'
  s.summary          = 'Bits and pieces of extensions and utils that have been gathered over time to make future apps and projects more convenient.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"This CocoaPods library is meant as a collection of small convenience extensions and utilities that are commonly reused in projects."
                       DESC

  s.homepage         = 'https://github.com/aviatoali/KibbleLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'aviatoali' => 'aviatoali@gmail.com' }
  s.source           = { :git => 'https://github.com/aviatoali/KibbleLib.git', :tag => s.version.to_s }
  s.social_media_url   = "https://www.linkedin.com/in/ali-shah-717144123/"

  s.ios.deployment_target = "12.0"
  s.swift_version = "5.0"

  s.source_files = 'KibbleLib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KibbleLib' => ['KibbleLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
