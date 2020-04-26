# frozen_string_literal: true

# Prepare platform "finger"
platform_finger = "#{platform[:name]}-#{platform[:release].split('.')[0]}"

# Default values for `control 'Tomcat main config'`
main_config_file = '/etc/sysconfig/tomcat'
# Default values for `control 'Tomcat Catalina temp dir'`
catalina_tmpdir = '/var/cache/tomcat/temp'
catalina_tmpdir_user_and_group = 'tomcat'

# Override by platform
case platform[:family]
when 'debian'
  main_config_file = '/etc/default/tomcat8'
  catalina_tmpdir = '/var/cache/tomcat8/temp'
  catalina_tmpdir_user_and_group = 'tomcat8'
  case platform_finger
  when 'debian-10'
    main_config_file = '/etc/default/tomcat9'
    catalina_tmpdir = '/var/cache/tomcat9/temp'
    catalina_tmpdir_user_and_group = 'tomcat'
  when 'debian-9'
  when 'debian-8'
    main_config_file = '/etc/default/tomcat7'
    catalina_tmpdir = '/var/cache/tomcat7/temp'
    catalina_tmpdir_user_and_group = 'tomcat7'
  when 'ubuntu-18'
  when 'ubuntu-16'
  end
when 'redhat'
  case platform_finger
  when 'centos-8'
  when 'centos-7'
  when 'centos-6'
  when 'amazon-2'
  when 'amazon-2018'
  end
when 'fedora'
  case platform_finger
  when 'fedora-31'
  when 'fedora-30'
  end
when 'suse'
  case platform_finger
  when 'opensuse-15'
  end
when 'linux'
  case platform_finger
  when 'arch-5'
  end
end

control 'Tomcat main config' do
  title 'should contain the lines'

  # Prepare comparison file
  main_config_path = '/tmp/kitchen/srv/salt/file_comparison/main_config/'\
    "#{platform_finger}"
  main_config = file(main_config_path).content

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
    it { should be_owned_by catalina_tmpdir_user_and_group }
    it { should be_grouped_into catalina_tmpdir_user_and_group }
    its('mode') { should cmp '0755' }
  end
end
