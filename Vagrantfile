require 'yaml'

projectVars = YAML.load_file("config/project-config.yml")

configVars = YAML.load_file("config/config-"+projectVars['configType']+".yml")

Vagrant.configure("2") do |config|
	
	config.vm.box = "ubuntu/xenial64"
	
	config.vm.provider "virtualbox" do |v|
		v.name = projectVars['projectName']
	end
	
	config.vm.synced_folder projectVars['projectDir'], configVars['networkProjectDir'],
		id: "web-root",
		create: true
	
	# Do some network configuration
	config.vm.network :forwarded_port, guest: 80, host: 8080
    config.vm.network :private_network, ip: configVars['networkIP']
	
	config.vm.provision :shell, :path => "provisions/"+configVars['provision']
end