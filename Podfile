platform :ios, '6.0'

target :MobSquad, :exclusive => true do
  
pod 'AFNetworking', '~> 2.0'
pod 'Typhoon', :head
pod 'CKUITools'
pod 'cocos2d', :path => '~/cocos2d-iphone'

end

target :MobSquadTests do
  
  pod 'OCHamcrest'
  pod 'OCMockito'

end

post_install do |installer|
  installer.project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
    end
  end
end
