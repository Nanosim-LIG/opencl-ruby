require './man.rb'
platforms = OpenCL::get_platforms
platforms.each { |platform|
  puts platform.name + ": " + platform.version
  devices = platform.devices
  devices.each { |device|
    puts "  " + device.name
    puts "  " + device.execution_capabilities_names.inspect
    puts "  " + device.global_mem_cache_type_name.inspect
    puts "  " + device.queue_properties_names.inspect
    puts "  " + device.type_names.inspect
  }
}
