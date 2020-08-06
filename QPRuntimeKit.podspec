#
# Be sure to run `pod lib lint QPRuntimeKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QPRuntimeKit'
  s.version          = '0.1.0'
  s.summary          = 'Encapsulate Objective-C Runtime to parse or modify Runtime Objects in a manner consistent with its type system.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Encapsulate Objective-C Runtime to parse or modify Runtime Objects in
a manner consistent with its type system, each prototype object has a
corresponding wrapper class.
                       DESC

  s.homepage         = 'https://github.com/keqiongpan/QPRuntimeKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Qiongpan Ke' => 'keqiongpan@163.com' }
  s.source           = { :git => 'https://github.com/keqiongpan/QPRuntimeKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.8'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'QPRuntimeKit/Classes/**/*'

  # s.resource_bundles = {
  #   'QPRuntimeKit' => ['QPRuntimeKit/Assets/*.png']
  # }

  s.public_header_files = ['QPRuntimeKit/Classes/**/*.h']
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
