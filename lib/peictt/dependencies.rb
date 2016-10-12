require "puma"
require "tilt/haml"
require "active_support/inflector"
require "peictt/controller"
require "peictt/utils"
require "peictt/builder/http_header"
require "peictt/builder/template"
require "peictt/builder/router"
require "peictt/http/http"
require "peictt/http/checker"
require "peictt/http/get"
require "peictt/http/post"
require "peictt/http/put"
require "peictt/http/patch"
require "peictt/http/match"
require "peictt/http/delete"
require "peictt/parser/json"
require "peictt/orm/database"
require "peictt/orm/base_model"
require "peictt/orm/migrations"
require "peictt/orm/constraints_parser"
require "peictt/orm/query_helpers"
require "peictt/orm/database_mapper"

class Object
  def self.const_missing(const)
    require const.to_s.to_snake_case
    Object.const_get(const)
  end
end
