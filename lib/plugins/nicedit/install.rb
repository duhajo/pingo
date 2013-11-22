# Install hook code here

puts "Copying files..."

public_dir = ::Rails.root.to_s + '/public'
tasks_dir = ::Rails.root.to_s + '/lib/tasks/'

tasks = Dir[File.join(File.dirname(__FILE__), '/tasks/*')]
FileUtils.cp(tasks, tasks_dir)
FileUtils.rm tasks

puts "Files copied - Installation complete!"
