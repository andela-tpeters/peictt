# Peictt [![Build Status](https://travis-ci.org/andela-tpeters/peictt.svg?branch=testing)](https://travis-ci.org/andela-tpeters/peictt) [![Coverage Status](https://coveralls.io/repos/github/andela-tpeters/peictt/badge.svg?branch=testing)](https://coveralls.io/github/andela-tpeters/peictt?branch=testing) [![Code Climate](https://codeclimate.com/github/andela-tpeters/peictt/badges/gpa.svg)](https://codeclimate.com/github/andela-tpeters/peictt)

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/peictt`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'peictt'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install peictt


## Usage
When creating a new Peictt application, a few things need to be setup and a few rules adhered to. Peictt follows the same folder structure as a typical rails app with all of the model, view and controller code packed inside of an app folder, configuration based code placed inside a config folder and the main database file in a db folder. [Here](https://github.com/andela-tpeters/peictt_todo) is a link to a to-do app built using Peictt with the correct folder setup, it can be forked, cloned and edited to suit other purposes.

### Generators

Peictt has generators that help to make work flow easy

#### New App

Generates new folder structure for the named app with the basic files needed

```ruby
peictt new appname
```

#### New Controller

Creates new controller file with the name provided

```ruby
peictt generate controller controllername
```

#### New Model

Creates new model file with the name provided

```ruby
peictt generate model modelname
```

#### New Migration
Creates new migration file with the tablename provided

```ruby
peictt generate migration tablename
```

### Tasks

#### Start Server
Runs the Server

```ruby
peictt server
```

#### Run Migrations
Executes the migrations

```ruby
peictt migrate
```

#### Drop Tables

Deletes all Database Tables

```ruby
peictt drop_tables
```

#### Reset Database

Deletes all tables in the database and creates the tables

```ruby
peictt reset_db
```


### Setup

In order to run a Peictt app, it is assumed that a `config.ru` file exists in the root directory and all the needed files have been required here.

Example `config.ru` file:

* Note that the 'APP_ROOT' constant is required and must point to the current file directory as the gem uses this internally to find and link folders.

```ruby
require "bundler"
Bundler.require
require_all "app"
APP_ROOT = __dir__

module MyApp
  class Application < Peictt::Application
  end
end

peicttApp = MyApp::Application.new

require File.expand_path __FILE__, "./config/routes"

run peicttApp
```

### Routes

The route file should be required in the config.ru file after the application has been initialized and before the rack 'run' command is called.

Example route file:

```ruby
MyApp.routes.draw do
  root "pages#index"
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "signup", to: "pages#signup"
  post "signup", to: "users#create"
  put "user/:id", to: "users#update"
  delete "user/:id", to: "agendas#destroy"
  match /regexp/, controller: <ControllerClass>, action: <controller_action>, methods: ["GET","POST"]
end
```

### Models

Peictt implements a lightweight orm that makes it easy to query the database using ruby objects. It supports only sqlite3. Models are placed inside the `app/models` folder.

Example model file:

```ruby
class App < Peictt::BaseModel
end
```

### Controllers

Controllers are placed inside the `app/controllers` folder.

Example controller file:

```ruby
class PagesController < Peictt::Controller
  def index
    @todos = Todo.all
  end

  def about
  end

  def show
    @todo = Todo.find_by id: params[:id]
  end
end
```

#### Render action

The render action can be used to modify the response from the server. Default renders "text/html"

To render json

```ruby
render json: {}
```

So Peictt uses the method name to find the corresponding file `*.json.haml` in the application views folder

To render text
```ruby
render text: "This is a text"
```

To use another controller view file with the same method
```ruby
render controller: "controller_name"
```

To use another controller with a different view file
```ruby
render controller: "controller_name", action: "action_name"
```

To passing locals to the view
```ruby
render locals: {name: "name"}
```

### Views

View templates are mapped to controller actions and must assume the same nomenclature as their respective actions. Haml is used as the templating engine and files which are views are required to have the `.haml` file extension. Views are placed inside the `app/views` folder. A default layout file is required and must be placed inside the `app/views/layouts` folder. It is also required that this file is named `application.haml` and has a `yield` command.

Example file:

```haml
%head
  %title Todo Application
%body
  = yield
```
## Running the tests

Test files are placed inside the spec/unit folder. You can run the tests from your command line client by typing `rspec spec`


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-tpeters/peictt. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
