require "spec_helper.rb"

describe "pritunl::default" do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it "starts pritunl service" do
    expect(chef_run).to start_service("pritunl")
  end

  it "enables pritunl service" do
    expect(chef_run).to enable_service("pritunl")
  end

  context "ubuntu-14.04" do
    let(:chef_run) { ChefSpec::Runner.new(platform: "ubuntu", version: "14.04").converge(described_recipe) }

    it "adds apt repository" do
      expect(chef_run).to add_apt_repository("pritunl")
    end

    it "installs apt package" do
      expect(chef_run).to install_apt_package("pritunl")
    end
  end

  context "centos-7.0" do
    let(:chef_run) { ChefSpec::Runner.new(platform: "centos", version: "7.0").converge(described_recipe) }

    it "includes yum-epel recipe" do
      expect(chef_run).to include_recipe("yum-epel")
    end

    it "downloads remote rpm file" do
      expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/pritunl.rpm")
    end

    it "installs yum package" do
      expect(chef_run).to install_yum_package("pritunl")
    end
  end
end
