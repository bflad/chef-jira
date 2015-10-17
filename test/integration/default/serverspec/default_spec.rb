require 'spec_helper'

describe 'Java' do
  describe command('java -version 2>&1') do
    its(:exit_status) { should eq 0 }
  end
end

describe 'MySQL' do
  describe port(3306) do
    it { should be_listening }
  end
end

describe 'JIRA' do
  describe port(8080) do
    it { should be_listening }
  end

  describe command("curl --noproxy localhost 'http://localhost:8080/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA Setup'") do
    its(:exit_status) { should eq 0 }
  end
end

describe 'Apache2' do
  describe port(80) do
    it { should be_listening }
  end

  describe port(443) do
    it { should be_listening }
  end

  describe command("curl --insecure --noproxy localhost 'https://localhost/secure/SetupApplicationProperties!default.jspa' | grep 'JIRA Setup'") do
    its(:exit_status) { should eq 0 }
  end
end
