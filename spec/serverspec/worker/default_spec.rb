# frozen_string_literal: true

require_relative "../spec_helper"

context "after provision finishes" do
  it_behaves_like "a host with a valid hostname"
  it_behaves_like "a host with all basic tools installed"
end

describe command "echo foo" do
  its(:stdout) { should match(/foo/) }
end

buildbot_worker_package = case os[:family]
                          when "freebsd"
                            "devel/py-buildbot-worker"
                          else
                            "buildbot-worker"
                          end
describe package buildbot_worker_package do
  it { should be_installed }
end

%w[fx230.i.trombik.org obuild.i.trombik.org].each do |h|
  describe command "ping -c 1 #{h}" do
    its(:exit_status) { should eq 0 }
  end
end

case os[:family]
when "freebsd"
  describe command "sudo poudriere ports -l" do
    let(:sudo_options) { "-u buildbot -i" }
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match(/^devel\s+/) }
  end
end
