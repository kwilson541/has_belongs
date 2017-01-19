require "has_belongs/version"
require "has_belongs/search"
require "has_belongs/remove"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "install", "should run a command line task"
    def install
      puts set_color "test", :red, :on_white, :bold
      # create_file("spec/sandbox/test.txt")
    end

    desc "migrate", "should run a migration command passing in one parameter"
    def migrate
      system("bin/rails db:create")
    	search = Search.new
    	output = search.generate_migration
    	output.each { |element| system(element) }
    	system("bin/rake db:migrate")
    	system("bin/rake db:schema:load")
    	puts "has_belongs ran successfully"
    end

    desc "unmigrate", "should remove your db associations"
    def unmigrate
    	remove = Remove.new
    	output = remove.generate_migration
    	output.each { |element| system(element) }
    	system("bin/rake db:migrate")
    	system("bin/rake db:schema:load")
    	puts "has_belongs ran successfully"
    end

  end
end
