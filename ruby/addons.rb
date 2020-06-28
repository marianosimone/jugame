current = File.basename(__FILE__, ".rb")
Dir.glob("#{File.dirname(__FILE__)}/*.rb") {|file|
      require file unless (File.basename(file, ".rb") == file)
}
