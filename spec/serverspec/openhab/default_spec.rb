# frozen_string_literal: true

require_relative "../spec_helper"
require "net/http"

ports = [
  80,   # nginx
  8086, # influxdb
  8080, # OpenHab UI
  3000, # grafana
  8094, # telegraf
  1883  # mosquitto
]
services = %w[
  openhab2
  mosquitto
  grafana-server
  influxd
  telegraf
  nginx
]

context "after provision finishes" do
  it_behaves_like "a host with a valid hostname"
  it_behaves_like "a host with all basic tools installed"
end

services.each do |s|
  describe service s do
    it { should be_enabled }
    it { should be_running }
  end
end

ports.each do |p|
  describe port p do
    it { should be_listening }
  end
end

describe "OpenHab UI" do
  let(:base_uri) { "http://172.16.100.200" }

  describe "/" do
    it "is redirected to /start/index" do
      uri = "#{base_uri}/"
      res = Net::HTTP.get_response(URI(uri))
      expect(res.code.to_i).to eq 302
      expect(res.to_hash).to have_key("location")
      expect(res["location"]).to match(%r{/start/index})
    end
  end

  describe "/start/index" do
    it "exists" do
      uri = "#{base_uri}/start/index"
      res = Net::HTTP.get_response(URI(uri))
      expect(res.code.to_i).to eq 200
    end
  end
end

describe "grafana UI" do
  let(:base_uri) { "http://172.16.100.200/grafana" }

  describe "/" do
    it "is redirected to /grafana/login" do
      uri = "#{base_uri}/"
      res = Net::HTTP.get_response(URI(uri))
      expect(res.code.to_i).to eq 302
      expect(res.to_hash).to have_key("location")
      expect(res["location"]).to match(%r{/grafana/login})
    end
  end
end
