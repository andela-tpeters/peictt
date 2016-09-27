require "bundler"
Bundler.require
require_all "app"

module Todo
  class Application < Peictt::Application
  end
end

require File.expand_path("../routes", __FILE__)
