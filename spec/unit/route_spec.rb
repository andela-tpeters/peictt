require 'spec_helper'

describe Peictt::Builder::Router do
  describe "#initialize" do
    context "when argument is passed" do
      it "raises ArgumentError" do
        expect { Peictt::Builder::Router.new "" }.to raise_error ArgumentError
      end
    end
  end

  describe "#all" do
    before do
      @router = Peictt::Builder::Router.new
    end

    context "when no route" do
      it "returns empty array" do
        expect(@router.all.size).to eq 0
      end
    end

    context 'when route block is passed' do
      context 'when controller does not exist' do
        it "raises controller not found error" do
          expect {@router.draw { get "posts#index" }}.to raise_error LoadError
        end
      end

      context "when controller exists" do
        it "builds the route object and saves to @router.routes" do
          class PostsController; end
          @router.draw { get "posts#index" }
          expect(@router.all.size).to eq 1
        end
      end
    end

    describe '#method_missing' do
      context "GET route" do
        it "returns a route object with get method" do
          route = @router.get "posts#index"
          expect(route.verb).to eq "GET"
          expect(route.url).to eq "posts/index"
          expect(route.controller).to eq PostsController
        end
      end

      context 'POST route' do
        it "returns a route object with post method" do
          route = @router.post "posts#create"
          expect(route.verb).to eq "POST"
          expect(route.url).to eq "posts/create"
          expect(route.controller).to eq PostsController
        end
      end

      context 'PUT  route' do
        it "returns a route object with put method" do
          route = @router.put "posts#update"
          expect(route.verb).to eq "PUT"
          expect(route.url).to eq "posts/update"
          expect(route.controller).to eq PostsController
        end
      end

      context 'PATCH route' do
        it "returns a route object with patch method" do
          route = @router.patch "posts#update"
          expect(route.verb).to eq "PATCH"
          expect(route.url).to eq "posts/update"
          expect(route.controller).to eq PostsController
        end
      end

      context 'DELETE route' do
        it "returns a route object with delete method" do
          route = @router.delete "posts#destroy"
          expect(route.verb).to eq "DELETE"
          expect(route.url).to eq "posts/destroy"
          expect(route.controller).to eq PostsController
        end
      end
    end
  end
end
