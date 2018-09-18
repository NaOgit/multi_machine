# Install required plugins
required_plugins = ["vagrant-hostsupdater"]
required_plugins.each do |plugin|
    exec "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

# obj = {
#   DB_HOST: 192.168.10.101"
# }

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
    app.vm.provision "shell", path: "environment/app/provision.sh", privileged: false
    app.vm.provision "shell", inline: set_var({"DB_HOST" => "192.168.10.101"}), privileged: false
  end

  config.vm.define "db" do |db|
    db.vm.box = "ubuntu/xenial64"
    db.vm.network "private_network", ip: "192.168.10.101"
    db.hostsupdater.aliases = ["database.local"]
    # go into etc and replace whatever ip is there
    db.vm.synced_folder "environment/db", "/home/ubuntu/environment"
    db.vm.provision "shell", path: "environment/db/provision.sh", privileged: false
  end

end
