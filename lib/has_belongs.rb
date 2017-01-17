require "has_belongs/version"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "install", "should run a command line task"
    def install
      create_file("spec/sandbox/test.txt")
    end

    desc "migrate ASSOCIATION", "should run a migration command passing in one parameter"
    def migrate(association)
      system("touch #{association}")
      system("bin/rake db:migrate")
      system("bin/rake db:schema:load")
      puts "has_belongs ran successfully"
    end

  end
end
