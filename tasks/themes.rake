namespace :themes do
  namespace :cache do
    desc "Creates the cached (public) theme folders"
    task :create do
      themes_root = File.join(RAILS_ROOT, "themes")
      for theme in Dir.glob(File.join(themes_root, '*'))

        theme_name = theme.split( File::Separator )[-1]
        theme_root = File.join(RAILS_ROOT, "public", "themes", theme_name)

        puts "Creating #{theme_root}"
        FileUtils.mkdir_p "#{theme_root}"

        %w{ images stylesheets javascripts }.each do |d|          
          FileUtils.mkdir_p File.join(theme_root, d)
          Dir.glob(File.join(theme, d, '**', '*')) do |f|                        
            final_path = f[theme.length + 1, f.length]
            if File.stat(f).directory? then               
               FileUtils.mkdir_p File.join(theme_root, final_path) #, :verbose => true
            else               
               FileUtils.cp f, File.join(theme_root, final_path) #, :verbose => true
            end
          end
        end
      end
    end

    desc "Removes the cached (public) theme folders"
    task :remove do
      themes_cache = File.join(RAILS_ROOT, 'public', 'themes')
      puts "Removing #{themes_cache}"
      FileUtils.rm_r themes_cache, :force => true
    end

    desc "Updates the cached (public) theme folders"
    task :update => [:remove, :create]
  end
end
