# frozen_string_literal: true

require_relative "../spec_helper"

services = %w[
  openhab2
  mosquitto
  grafana-server
  influxd
  telegraf
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
