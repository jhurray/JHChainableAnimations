Pod::Spec.new do |s|
  s.name     = 'JHChainableAnimations'
  s.version  = '1.3.0'
  s.author   = { 'Jeff Hurray' => 'jhurray33@gmail.com' }
  s.homepage = 'https://github.com/jhurray/JHChainableAnimations'
  s.summary  = 'Easy to read and write chainable Animations in Objective-C'
  s.license  = 'MIT'
  s.source   = { :git => 'https://github.com/jhurray/JHChainableAnimations.git', :tag => s.version.to_s }
  s.source_files = 'JHChainableAnimations/*{.h,.c,.m}'
  s.platform = :ios
  s.ios.deployment_target = '6.0'
  s.requires_arc = true
end
