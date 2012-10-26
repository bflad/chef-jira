name              "template-cookbook"
maintainer        "The Wharton School - The University of Pennsylvania"
maintainer_email  "chef-admins@wharton.upenn.edu"
license           "Apache 2.0"
description       "A cool description."
version           "0.1.0"
recipe            "template-cookbook", "Short description of template-cookbook default recipe."
recipe            "template-cookbook::alternate", "Short description of template-cookbook::alternate recipe."

%w{ apache2 logrotate }.each do |d|
  depends d
end

%w{ redhat ubuntu }.each do |os|
  supports os
end
