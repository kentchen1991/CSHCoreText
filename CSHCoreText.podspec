

Pod::Spec.new do |s|

  s.name         = "CSHCoreText"
  s.version      = "0.0.1"
  s.summary      = "上传测试"
  s.description  = <<-DESC
                   A longer description of CSHCoreText in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "https://github.com/kentchen1991/CSHCoreText"
  s.license      = "MIT (example)"
  s.author             = { "kentchen1991" => "email@address.com" }
  s.source       = { :git => "https://github.com/kentchen1991/CSHCoreText.git", :tag => "0.0.1" }
  s.source_files  = "CSHCoreText", "CSHCoreText/**/*.{h,m}"
end
