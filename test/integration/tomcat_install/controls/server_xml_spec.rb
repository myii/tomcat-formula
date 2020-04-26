# frozen_string_literal: true

# Prepare platform "finger"
platform_finger = "#{platform[:name]}-#{platform[:release].split('.')[0]}"

# Default values for `control 'Tomcat main config'`
conf_dir = '/etc/tomcat'
server_xml_user_and_group = 'tomcat'

# Override by platform
case platform[:family]
when 'debian'
  conf_dir = '/etc/tomcat8'
  server_xml_user_and_group = 'tomcat8'
  case platform_finger
  when 'debian-10'
    conf_dir = '/etc/tomcat9'
    server_xml_user_and_group = 'tomcat'
  when 'debian-9'
  when 'debian-8'
    conf_dir = '/etc/tomcat7'
    server_xml_user_and_group = 'tomcat7'
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
    server_xml_user_and_group = 'root'
  end
when 'linux'
  case platform_finger
  when 'arch-5'
  end
end

control 'Tomcat `server.xml` config' do
  title 'should contain the lines'

  server_xml_file = "#{conf_dir}/server.xml"
  server_xml_path = '/tmp/kitchen/srv/salt/file_comparison/server_xml/'\
    "#{platform_finger}.xml"
  server_xml = file(server_xml_path).content
  # Need the hostname to be used for `tomcat.cluster`
  server_xml = server_xml.gsub(
    'SALT_MINION_ID_PLACEHOLDER',
    file('/etc/salt/minion_id').content.chomp
  )

  describe file(server_xml_file) do
    it { should be_file }
    it { should be_owned_by server_xml_user_and_group }
    it { should be_grouped_into server_xml_user_and_group }
    its('mode') { should cmp '0644' }
    its('content') { should include server_xml }
  end
end
