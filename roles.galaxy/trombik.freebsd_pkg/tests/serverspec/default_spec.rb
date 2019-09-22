require "spec_helper"
require "serverspec"

config = "/usr/local/etc/pkg.conf"

describe file(config) do
  it { should be_file }
  its(:content) { should match Regexp.escape("Managed by ansible") }
  its(:content) { should match(/IGNORE_OSVERSION=yes/) }
end
