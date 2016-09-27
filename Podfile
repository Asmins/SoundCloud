# Uncomment this line to define a global platform for your project
 platform :ios, ’8.0’
# Uncomment this line if you're using Swift
 use_frameworks!

target 'SoundCloud' do
	pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
	pod 'SwiftyJSON'
	pod 'SDWebImage/WebP'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |configuration|
      configuration.build_settings['SWIFT_VERSION'] = "2.3"
    end
  end
end

