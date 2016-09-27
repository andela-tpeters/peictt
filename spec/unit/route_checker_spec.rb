require "spec_helper"

describe Peictt::Http::Checker do
  describe '#check_url' do
    before do

      class TasksController < Peictt::Controller
        def index
        end

        def show
        end
      end

      class App < Peictt::Application
      end

      App.routes.draw do
        get "tasks#index"
        get "tasks#new"
        post "tasks#create"
        get "/task/:id", to: "tasks#show"
      end

      @app = Rack::MockRequest.new(App.new)

    end

    context 'when route exists' do
      it "returns the page for the request" do
        response = @app.get("tasks/index")
        expect(response.body).to include "My Application"
        expect(response.status).to eq 200
        expect(response.header["Content-Type"]).to eq "text/html"
      end
    end

    context 'when route does not exists' do
      it "returns 404 error" do
        response = @app.get('posts/all')
        expect(response.body).to eq "Route not found"
        expect(response.status).to eq 404
      end
    end

    describe 'placeholders' do
      context "when placeholders are provided" do
        it "responds with the show.haml page" do
          response = @app.get("task/1")
          expect(response.body).to include "Show Task"
          route = App.routes.all.select { |route| route.url == "/task/:id" } [0]
          expect(route.controller).to eq TasksController
          expect(route.action).to eq "show"
          expect(route.regexp.match("/task/1").captures[0]).to eq "1"
        end
      end
    end
  end

end
