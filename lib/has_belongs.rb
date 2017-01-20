require "has_belongs/version"
require "has_belongs/search"
require "has_belongs/remove"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "migrate", "runs a migration for when you have added associations to your models"
    def migrate
      system("bin/rails db:create")
      search = Search.new
      output = search.generate_migration
      output.each { |element| system(element) }
      system("bin/rake db:migrate")
      system("bin/rake db:schema:load")
      puts set_color "has_belongs migrate ran successfully", :white, :on_green, :bold
    end

    desc "unmigrate", "runs a migration for when you have removed assoications from your models"
    def unmigrate
<<<<<<< HEAD
    	remove = Remove.new
    	output = remove.remove_migrations
    	output.each { |element| system(element) }
    	system("bin/rake db:migrate")
    	system("bin/rake db:schema:load")
    	puts set_color "has_belongs unmigrate ran successfully", :white, :on_green, :bold
    end

    desc "help", "provides documentation and information about this gem"
    def help
      puts set_color "HELP ME!", :yellow, :on_black, :bold
=======
      remove = Remove.new
      output = remove.generate_migration
      output.each { |element| system(element) }
      output = remove.generate_habtm_remove_migrations
      output.each { |element| system(element) }
      system("bin/rake db:migrate")
      system("bin/rake db:schema:load")
      puts set_color "has_belongs unmigrate ran successfully", :white, :on_green, :bold
>>>>>>> aa6472fe1af2bfa4919fb6f03971c2b477bc6bd4
    end

  end

end
