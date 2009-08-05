def cache_theme_files(root, theme_name)
  FileUtils.mkdir_p "#{root}/public/themes/#{theme_name}"
  %w(images stylesheets javascripts).each do |assets|
    FileUtils.cp_r "#{root}/themes/#{theme_name}/#{assets}", "#{root}/public/themes/#{theme_name}/#{assets}"
  end
end

desc "Creates the cached (public) theme folders"
task :theme_create_cache do
  $stdout.sync = true
  root = File.expand_path(RAILS_ROOT)
  if theme_name = ENV["THEME"]
    puts "Copying theme files for '#{theme_name}'... done."
    cache_theme_files(root, theme_name)
  else
    print "Copying theme files to public/..."
    for theme_name in Dir.entries("#{root}/themes")
      next if theme_name =~ /^\./
      cache_theme_files(root, theme_name)
      print " " + theme_name
    end
    puts " ...done."
  end
end

desc "Removes the cached (public) theme folders"
task :theme_remove_cache do
  if theme_name = ENV["THEME"]
    puts "Removing all theme files for '#{theme_name}' from public/... done."
    FileUtils.rm_rf "#{RAILS_ROOT}/public/themes/#{theme_name}"
  else
    puts "Removing all theme files from public/... done."
    FileUtils.rm_rf "#{RAILS_ROOT}/public/themes"
  end
end

desc "Updates the cached (public) theme folders"
task :theme_update_cache => [:theme_remove_cache, :theme_create_cache]