require "spec_helper"
require "net/http"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]
describe server(:server1) do
  it "responds to /api/admin/settings with 200" do
    uri = URI("http://#{server(:server1).server.address}:3000/api/admin/settings")
    req = Net::HTTP::Get.new(uri)
    req.basic_auth "admin", "PassWord"
    res = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(req)
    end
    expect(res.code.to_i).to eq 200
  end

  it "shows series" do
    cmd = "influx -username read_only -password read_only -ssl -unsafeSsl -database mydatabase --execute show series"
    r = server(:server1).server.ssh_exec cmd
    expect(r).to match(/cpu/)
  end
end
