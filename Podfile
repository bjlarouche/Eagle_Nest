# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.2'
project 'BCApp'
inhibit_all_warnings!
use_frameworks!

target 'BCApp' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  

  # Pods for BCApp
  pod 'Parse'
  pod 'Parse/UI'
  pod 'TwitterKit'
  pod 'JSQMessagesViewController'
  pod 'ParseLiveQuery'

  target 'BCAppTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Parse'
  end

  target 'BCAppUITests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Parse'
  end

end

# force the sub specs in the array below to use swift version 3.2
    post_install do |installer|
        installer.pods_project.targets.each do |target|
            if ['PromiseKit'].include? target.name
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '3.2'
                end
            end
        end
    end
