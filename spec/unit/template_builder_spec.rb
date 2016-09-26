require 'spec_helper'

describe Peictt::Builder::Template do
  describe '#initialize' do
    context "default template" do
      it "returns haml template" do
        template = Peictt::Builder::Template.new ["test_file",{}],
                                                 'posts',
                                                 :index
        expect(template.html?).to be_truthy
        controller = template.instance_variable_get :@controller
        expect(controller).to eq 'posts'
        expect(template.action).to eq :index
        expect(template.body).to eq "#{APP_ROOT}/app/views/posts/test_file.haml"
      end
    end

    context 'json template' do
      it "returns *.json.haml" do
        template = Peictt::Builder::Template.new ["test_file",{json:{}}],
                                                 'posts',
                                                 :index
        expect(template.json?).to be_truthy
        expect(template.body).to eq "#{APP_ROOT}/app/views/posts/test_file.json.haml"
      end
    end

    context 'text template' do
      it "returns text? true" do
        template = Peictt::Builder::Template.new ["test_file",{text:""}],
                                                 'posts',
                                                 :index
        expect(template.text?).to be_truthy
      end
    end

    context 'when controller key is passed to options' do
      it "overides the default controller" do
        template = Peictt::Builder::Template.new ["test_file",{controller: "new"}],
                                                 'posts',
                                                 :index
        controller = template.instance_variable_get :@controller
        expect(controller).to eq "new"
      end
    end

    context 'when two application formats are given' do
      it "raises RuntimeError" do
        expect do
          Peictt::Builder::Template.new ["test_file",{text: "", json: {}}],
                                                 'posts',
                                                 :index
        end.to raise_error RuntimeError
      end
    end

    context "wrong argument format" do
      it "raises ArgumentError" do
        expect do
          Peictt::Builder::Template.new "", 'posts', :index
        end.to raise_error ArgumentError
      end
    end

    context "local variables" do
      it "builds template with the local variables" do
        template = Peictt::Builder::Template.new ["test_file",{locals: {name: "Name"}}],
                                               'posts',
                                               :index
        expect(template.locals[:name]).to eq "Name"
      end
    end
  end
end
