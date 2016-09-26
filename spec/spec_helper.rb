require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack'
require 'peictt'
APP_ROOT = File.expand_path "spec/todo"
