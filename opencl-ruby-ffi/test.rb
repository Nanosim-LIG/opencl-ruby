require './man.rb'
platforms = OpenCL::get_platforms
platforms.each { |platform|
  puts platform.name + ": " + platform.version
  devices = platform.devices
  devices.each { |device|
    puts "  " + device.name
  }
}
