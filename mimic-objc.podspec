Pod::Spec.new do |s|
  s.name             = "mimic-objc"
  s.version          = "0.1.0"
  s.summary          = "Create live server stubs for your end-to-end tests."
  s.description      = <<-DESC
Mimic is a testing tool that lets you set create a fake stand-in for an external web service to be used when writing integration/end-to-end tests for applications or libraries that access these services.
                       DESC
  s.homepage         = "https://github.com/cybertk/mimic-objc"
  s.license          = 'MIT'
  s.author           = { "Quanlong He" => "kyan.ql.he@gmail.com" }
  s.source           = { :git => "https://github.com/cybertk/mimic-objc.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'LRMimic/LRMimic.{h,m}'

end
