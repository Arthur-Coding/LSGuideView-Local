Pod::Spec.new do |s|
s.name             = "LSGuideView-Local"
s.version          = "1.0.0"
s.summary          = "Load the local image implementation guide page view."
s.description      = <<-DESC
                    Load the local image implementation guide page view.Create by ArthurShuai
                    DESC
s.homepage         = "https://github.com/Arthur-Coding/LSGuideView-Local"
s.license          = 'MIT'
s.author           = { "ArthurShuai" => "zhixingui_liushuai@163.com" }
s.source           = { :git => "https://github.com/Arthur-Coding/LSGuideView-Local.git", :tag => s.version.to_s }

s.platform     = :ios, '9.0'
s.requires_arc = true

s.source_files = 'LSGuideView-Local/*'
s.frameworks = 'UIKit'

end
