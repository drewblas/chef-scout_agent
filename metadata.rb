maintainer        "Drew Blas"
maintainer_email  "drew.blas@gmail.com"
license           "Apache 2.0"
description       "Installs and configures the Scout Agent"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.2"

%w{debian ubuntu centos}.each do |os|
  supports os
end
