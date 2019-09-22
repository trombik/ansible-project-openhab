# frozen_string_literal: true

require_relative "../spec_helper"

context "after provision finishes" do
  it_behaves_like "a host with a valid hostname"
  it_behaves_like "a host with all basic tools installed"
end

if os[:family] == "freebsd"
  describe file "/usr/local/etc/pkg.conf" do
    it { should be_file }
  end
end

%w[fx230.i.trombik.org obuild.i.trombik.org].each do |h|
  describe command "ping -c 1 #{h}" do
    its(:exit_status) { should eq 0 }
  end
end
