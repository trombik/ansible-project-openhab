require "spec_helper"
require "serverspec"

package = "openhab2"
service = "openhab2"
user    = "openhab"
group   = "openhab"
extra_groups = ["dialout"]
ports   = [8080]
log_dir = "/var/log/openhab2"
db_dir  = "/var/lib/openhab2"
config_dir = "/etc/openhab2"
config_files = %w[
  services/addons.cfg
  services/basicui.cfg
  services/classicui.cfg
  services/logging.cfg
  services/rrd4j.cfg
  services/runtime.cfg
]
xtend_files = %w[scripts/demo.script]
default_user = "root"
default_group = "root"

case os[:family]
when "freebsd"
  extra_groups = ["dialer"]
  config_dir = "/usr/local/etc/openhab2"
  db_dir = "/var/db/openhab2"
  extra_groups = ["dialer"]
  default_group = "wheel"
else
  extra_groups = ["dialout"]
end

describe package(package) do
  it { should be_installed }
end

extra_groups.each do |g|
  describe group(g) do
    it { should exist }
  end
end

describe user(user) do
  it { should exist }
  it { should belong_to_primary_group(group) }
  extra_groups.each do |g|
    it { should belong_to_group(g) }
  end
end

config_files.each do |f|
  describe file("#{config_dir}/#{f}") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 640 }
    its(:content) { should match(/# Managed by ansible/) }
  end
end

xtend_files.each do |f|
  describe file("#{config_dir}/#{f}") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by user }
    it { should be_grouped_into group }
    it { should be_mode 640 }
    its(:content) { should match(%r{// Managed by ansible}) }
  end
end

describe file "#{config_dir}/services/foo.cfg" do
  it { should_not exist }
end

describe file(log_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

describe file(db_dir) do
  it { should exist }
  it { should be_mode 755 }
  it { should be_owned_by user }
  it { should be_grouped_into group }
end

case os[:family]
when "freebsd"
  describe file("/etc/rc.conf.d/openhab2") do
    it { should exist }
    it { should be_file }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    it { should be_mode 644 }
    its(:content) { should match(/# Managed by ansible/) }
  end
when "ubuntu"
  describe file("/etc/default/#{service}") do
    it { should exist }
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by default_user }
    it { should be_grouped_into default_group }
    its(:content) { should match(/# Managed by ansible/) }
    its(:content) { should match(/OPENHAB_HTTP_PORT=8080/) }
  end
end

describe service(service) do
  it { should be_running }
  it { should be_enabled }
end

ports.each do |p|
  # the java VM needs some delay
  sleep 20
  describe port(p) do
    it { should be_listening }
  end
end
