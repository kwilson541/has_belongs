require "has_belongs/version"
require "has_belongs/add"
require "has_belongs/remove"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "migrate", "runs a migration for when you have added associations to your models"
    def migrate
      system("bin/rails db:create")
      add = Add.new
      output = add.generate_migration
      output.each { |element| system(element) }
      system("bin/rake db:migrate")
      system("bin/rake db:schema:load")
      puts set_color "has_belongs migrate ran successfully", :white, :on_green, :bold
    end

    desc "unmigrate", "runs a migration for when you have removed assoications from your models"
    def unmigrate
      remove = Remove.new
      output = remove.remove_migrations
      output.each { |element| system(element) }
      system("bin/rake db:migrate")
      system("bin/rake db:schema:load")
      puts set_color "has_belongs unmigrate ran successfully", :white, :on_green, :bold
    end

  end

end
