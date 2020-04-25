# frozen_string_literal: true

control 'Tomcat `server.xml` config' do
  title 'should contain the lines'

  # Overide by platform
  conf_dir = '/etc/tomcat'
  user_and_group = 'tomcat'
  case platform[:family]
  when 'debian'
    conf_dir = '/etc/tomcat8'
    user_and_group = 'tomcat8'
    case platform[:name]
    when 'debian'
      case platform[:release]
      when /^10/
        conf_dir = '/etc/tomcat9'
        platform_server_xml = 'debian-10.xml'
        user_and_group = 'tomcat'
      when /^9/
        platform_server_xml = 'debian-9.xml'
      end
    when 'ubuntu'
      case platform[:release]
      when /^18/
        platform_server_xml = 'ubuntu-1804.xml'
      when /^16/
        platform_server_xml = 'ubuntu-1604.xml'
      end
    end
  when 'redhat'
    platform_server_xml = 'centos-7.xml'
  when 'fedora'
    platform_server_xml = 'fedora-31.xml'
  when 'suse'
    platform_server_xml = 'opensuse-leap-151.xml'
    user_and_group = 'root'
  end
  server_xml_file = "#{conf_dir}/server.xml"
  server_xml_path = '/tmp/kitchen/srv/salt/file_comparison/server_xml'\
    "#{platform_server_xml}"
  server_xml = file(server_xml_path).content
  server_xml = server_xml.gsub(
    'SALT_MINION_ID_PLACEHOLDER',
    file('/etc/salt/minion_id').content.chomp
  )

  describe file(server_xml_file) do
    it { should be_file }
    it { should be_owned_by user_and_group }
    it { should be_grouped_into user_and_group }
    its('mode') { should cmp '0644' }
    its('content') { should include server_xml }
  end
end
