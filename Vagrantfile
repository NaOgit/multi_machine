# Install required plugins
# Include plugin for "vagrant-berkshelf"

required_plugins = ["vagrant-omnibus"]
required_plugins = ["vagrant-berkshelf"]

required_plugins = ["vagrant-hostsupdater"]

required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    puts "Installing vagrant plugin #{plugin}"
    Vagrant::Plugin::Manager.instance.install_plugin plugins
    puts "Installed vagrant plugin #{plugin}"
  end
end

def set_var(obj)
  command = <<~HEREDOC
  HEREDOC

  obj.each do |key, value|
    command += <<~HEREDOC
    echo #{key}
    echo #{value}
    echo "export #{key}=#{value}" >> ~/.bashrc
    source ~/.bashrc
    HEREDOC
  end
  command
end

Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    app.vm.box = "ubuntu/xenial64"
    app.vm.network "private_network", ip: "192.168.10.100"
    app.hostsupdater.aliases = ["development.local"]
    app.vm.synced_folder "app", "/home/ubuntu/app"
    app.vm.synced_folder "environment/app", "/home/ubuntu/environment"
    app.vm.provision "chef_solo" do |chef|
      chef.add_recipe "node::default"
    end
    app.vm.provision "shell", inline: set_var({"DB_HOST" => "192.168.10.101"}), privileged: false
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.101"
    db.hostsupdater.aliases = ["database.local"]
    # go into etc and replace whatever ip is there
    db.vm.synced_folder "environment/db", "/home/ubuntu/environment"
    db.vm.provision "chef_solo" do |chef|
      chef.add_recipe "mongo::default"
    end
  end

end
