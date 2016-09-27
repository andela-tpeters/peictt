require "spec_helper"

describe Peictt::Http::MATCH do
  before do
    class TestsController; end
  end

  describe '#initialize' do
    context "when controller key is string" do
      it "returns route controller = TestsController" do
        route = Peictt::Http::MATCH.new //,
                                        controller: "tests",
                                        action: :index,
                                        methods: ["GET"]
        expect(route.controller).to eq TestsController
      end
    end

    context "when controller key camelCased" do
      it "returns controller = TestsController" do
        route = Peictt::Http::MATCH.new //,
                                        controller: "TestsController",
                                        action: :index,
                                        methods: ["GET"]
        expect(route.controller).to eq TestsController
      end
    end

    context "when controller key camelCased" do
      it "returns controller is TestsController class" do
        route = Peictt::Http::MATCH.new //,
                                        controller: TestsController,
                                        action: :index,
                                        methods: ["GET"]
        expect(route.controller).to eq TestsController
      end
    end

    context 'when options keys are not set' do
      context 'when controller is not set' do
        it "raises ArgumentError" do
          expect do
            Peictt::Http::MATCH.new //,
            action: :index,
            methods: ["GET"]
          end.to raise_error ArgumentError
        end
      end

      context 'when action is not set' do
        it "raises ArgumentError" do
          expect do
            Peictt::Http::MATCH.new //,
            controller: "tests",
            methods: ["GET"]
          end.to raise_error ArgumentError
        end
      end

      context 'when methods is not set' do
        it "raises ArgumentError" do
          expect do
            Peictt::Http::MATCH.new //,
            controller: "tests",
            action: :index
          end.to raise_error ArgumentError
        end
      end

      context 'when regexp is not passed' do
        it "raises ArgumentError" do
          expect do
            Peictt::Http::MATCH.new '//',
            controller: "tests",
            action: :index
          end.to raise_error ArgumentError
        end
      end
    end
  end

end
