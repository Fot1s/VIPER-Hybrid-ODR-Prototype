# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'VIPER-Hybrid-Container' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'Kingfisher', '~> 3.0'
  pod 'PKHUD', '~> 4.0'
  pod 'R.swift','~> 3.0'
  pod 'Starscream', '<= 3.0.5'

  target 'VIPER-Hybrid-ContainerTests' do
    inherit! :complete
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'YES'
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
