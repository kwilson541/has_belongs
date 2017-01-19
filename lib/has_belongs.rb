require "has_belongs/version"
require "has_belongs/search"
require "has_belongs/remove"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "migrate", "runs a migration for your model associations"
    def migrate
      system("bin/rails db:create")
    	search = Search.new
    	output = search.generate_migration
    	output.each { |element| system(element) }
    	system("bin/rake db:migrate")
    	system("bin/rake db:schema:load")
    	puts set_color "has_belongs ran successfully", :red, :on_white, :bold
    end

    desc "unmigrate", "runs a migration for when you have removed assoications from your models"
    def unmigrate
    	remove = Remove.new
    	output = remove.generate_migration
    	output.each { |element| system(element) }
    	system("bin/rake db:migrate")
    	system("bin/rake db:schema:load")
    	puts set_color "has_belongs ran successfully", :white, :on_red, :bold
    end

    desc "help", "provides documentation and information about this gem"
    def help
      puts set_color "HELP ME!", :yellow, :on_black, :bold
    end

  end
end
