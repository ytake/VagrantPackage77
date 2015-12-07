# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'json'
require 'yaml'

Encoding.default_external = 'UTF-8'

VAGRANTFILE_API_VERSION = "2"

homesteadYamlPath = "./vagrant.yaml"
homesteadJsonPath = "./vagrant.json"
afterScriptPath = "./after.sh"
aliasesPath = "./aliases"

# file required
require File.expand_path(File.dirname(__FILE__) + '/scripts/builder.rb')

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  config.vm.provision 'shell', path: './provision/update.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/database.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/php.sh'
  config.vm.provision :reload
  config.vm.provision 'shell', path: './provision/nginx.sh'

  if File.exists? aliasesPath then
    config.vm.provision "file", source: aliasesPath, destination: "~/.bash_aliases"
  end

  if File.exists? homesteadYamlPath then
    Builder.configure(config, YAML::load(File.read(homesteadYamlPath)))
  elsif File.exists? homesteadJsonPath then
    Builder.configure(config, JSON.parse(File.read(homesteadJsonPath)))
  end

  if File.exists? afterScriptPath then
    config.vm.provision "shell", path: afterScriptPath
  end
end
