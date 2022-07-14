#
# Be sure to run `pod lib lint SMYBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMYBase'
  s.version          = '0.1.2'
  s.summary          = 'A short description of SMYBase.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/camelfu/SMYBase'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'camelfu' => 'camelfu@icloud.com' }
  s.source           = { :git => 'https://github.com/camelfu/SMYBase.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  
  s.source_files = 'SMYBase/Classes/**/*.{h,m,c,swift,pch,strings}'
  
  s.resource_bundles = {
    'SMYBase' => ['SMYBase/{Assets,Classes}/**/*.{xcassets,png,gif,ttf,xib,bundle}']
  }
  
  s.public_header_files = 'Pod/Classes/SMYBase.h'
  s.frameworks = 'Foundation','UIKit'
  s.swift_version = '5.0'
  
#  s.prefix_header_file = false
#  s.prefix_header_file = 'SMYBase/Classes/SMYBasePrefix.pch'
  
  s.compiler_flags = '-ObjC'
#  s.prefix_header_contents = 'UtilityMacro.h','UIColor+Custom.h'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }
  non_arc_files = 'SMYBase/Classes/Third/Reachability/Reachability.m'
  s.exclude_files = non_arc_files
  s.subspec 'no-arc' do |sp|
    sp.source_files = non_arc_files
    sp.requires_arc = false
  end
   
  # s.dependency 'AFNetworking', '~> 2.3'
end
