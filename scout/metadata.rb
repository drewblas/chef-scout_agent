name              "chef-scout"
maintainer        "Scout Support"
maintainer_email  "supports@scoutapp.com"
license           "Apache 2.0"
description       "Installs and configures monitoring agent for scoutapp.com"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.4"

%w[ubuntu debian redhat centos fedora scientific amazon].each do |os|
  supports os
end
