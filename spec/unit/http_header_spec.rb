require "spec_helper"

describe Peictt::Builder::HttpHeader do

  describe '#initialize' do
    context 'when args is empty' do
      it "builds default headers" do
        headers = Peictt::Builder::HttpHeader.new([])
        expect(headers.headers["Content-Type"]).to eq "text/html"
        expect(headers.status).to eq 200
      end
    end

    context 'text headers' do
      it "builds Content-Type = text/plain" do
        headers = Peictt::Builder::HttpHeader.new([{text: ""}])
        expect(headers.headers["Content-Type"]).to eq "text/plain"
      end
    end

    context 'json headers' do
      it "builds Content-Type = application/json" do
        headers = Peictt::Builder::HttpHeader.new([{json: {}}])
        expect(headers.headers["Content-Type"]).to eq "application/json"
      end
    end

    context 'status headers' do
      it "sets the status passed" do
        headers = Peictt::Builder::HttpHeader.new([{status: 404}])
        expect(headers.status).to eq 404
      end
    end

    context 'when other headers are added' do
      it "merges other headers" do
        headers = Peictt::Builder::HttpHeader.new(
          [{headers: {"Set Cookie"=>"Test"}}]
        )
        expect(headers.headers["Set Cookie"]).to eq "Test"
        expect(headers.headers["Content-Type"]).to eq "text/html"
      end
    end

    context 'when hash is not passed' do
      it "raises error" do
        expect { Peictt::Builder::HttpHeader.new(["",[]]) }.
          to raise_error ArgumentError
      end
    end
  end

end
