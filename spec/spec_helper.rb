require 'coveralls'
Coveralls.wear!
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "has_belongs"
require_relative "../lib/has_belongs/search"
require_relative "../lib/has_belongs/remove"
require "fileutils"
require "web_helper"
