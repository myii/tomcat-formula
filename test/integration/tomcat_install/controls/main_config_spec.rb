# frozen_string_literal: true

# Overide by platform
catalina_tmpdir = '/var/cache/tomcat/temp'
main_config_file = '/etc/sysconfig/tomcat'
user_and_group = 'tomcat'
case platform[:family]
when 'debian'
  catalina_tmpdir = '/var/cache/tomcat8/temp'
  main_config_file = '/etc/default/tomcat8'
  user_and_group = 'tomcat8'
  case platform[:name]
  when 'debian'
    case platform[:release]
    when /^10/
      catalina_tmpdir = '/var/cache/tomcat9/temp'
      main_config_file = '/etc/default/tomcat9'
      platform_file = 'debian-10'
      user_and_group = 'tomcat'
    when /^9/
      platform_file = 'debian-9'
    end
  when 'ubuntu'
    case platform[:release]
    when /^18/
      platform_file = 'ubuntu-1804'
    when /^16/
      platform_file = 'ubuntu-1604'
    end
  end
when 'redhat'
  platform_file = 'centos-7'
when 'fedora'
  platform_file = 'fedora-31'
when 'suse'
  platform_file = 'opensuse-leap-151'
end
main_config_path = "/tmp/kitchen/srv/salt/file_comparison/main_config/#{platform_file}"
main_config = file(main_config_path).content

control 'Tomcat main config' do
  title 'should contain the lines'

  describe file(main_config_file) do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include main_config }
  end
end

control 'Tomcat Catalina temp dir' do
  title 'should be prepared with the settings'

  describe file(catalina_tmpdir) do
    it { should be_directory }
    it { should be_owned_by user_and_group }
    it { should be_grouped_into user_and_group }
    its('mode') { should cmp '0755' }
  end
end
