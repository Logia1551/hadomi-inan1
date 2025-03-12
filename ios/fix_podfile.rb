#!/usr/bin/env ruby

# Ambil FLUTTER_ROOT dari Generated.xcconfig
flutter_root = nil
xcconfig_path = File.join(Dir.pwd, '..', 'Flutter', 'Generated.xcconfig')
if File.exist?(xcconfig_path)
  File.foreach(xcconfig_path) do |line|
    if matches = line.match(/FLUTTER_ROOT\=(.*)/)
      flutter_root = matches[1].strip
      puts "Found FLUTTER_ROOT: #{flutter_root}"
      break
    end
  end
end

# Jika FLUTTER_ROOT tidak ditemukan, gunakan pendekatan alternatif
unless flutter_root
  puts "FLUTTER_ROOT tidak ditemukan di Generated.xcconfig, menggunakan nilai default"
  flutter_root = `flutter --version --machine | grep flutterRoot | cut -d'"' -f4`.strip
  puts "Using Flutter root: #{flutter_root}"
end

# Buat Podfile baru
podfile_content = <<-EOT
# Uncomment this line to define a global platform for your project
platform :ios, '13.0'
# CocoaPods analytics sends network stats synchronously affecting flutter build latency.
ENV['COCOAPODS_DISABLE_STATS'] = 'true'
project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}
# Definisi flutter_root langsung dengan nilai yang diperoleh
def flutter_root
  "#{flutter_root}"
end
require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)
flutter_ios_podfile_setup
target 'Runner' do
  use_frameworks!
  use_modular_headers!
  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
  end
end
EOT

# Tulis ke file
File.write('Podfile', podfile_content)
puts "Podfile baru telah dibuat dengan FLUTTER_ROOT: #{flutter_root}"