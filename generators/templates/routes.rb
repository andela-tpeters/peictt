<%= config[:name].to_camel_case %>::Application.routes.draw do
  root "landing#index"
end
