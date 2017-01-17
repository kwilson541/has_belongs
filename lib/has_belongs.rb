require "has_belongs/version"
require "thor"


module HasBelongs
  class Cli < Thor
    include Thor::Actions

    desc "install", "should run a command line task"
    def install
      create_file("my_file.txt")
    end

  end
end
