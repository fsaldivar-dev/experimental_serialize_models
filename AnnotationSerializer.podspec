Pod::Spec.new do |s|
  s.name             = 'AnnotationSerializer'
  s.version          = '0.0.1'
  s.summary          = 'Librería que permite agrupar multilpes propertywrapers'
  s.homepage         = 'https://github.com/JavierSaldivarRubio/experimental-annotation-swift'
  s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = 'Francisco Javier Saldivar Rubio'
  s.source           = { :git => 'https://github.com/fsaldivar-dev/experimental_serialize_models.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'AnnotationSerializer/Sources/**/*'
  s.dependency 'AnnotationSwift'
end
