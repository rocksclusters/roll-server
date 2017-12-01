#!/bin/bash
VSERVER=$1
DISTPATH=$2
DOCROOT=$(readlink -f $2)
cat << EOF | sed -e "s#@VSERVER@#$1#g"  -e "s#@DOCROOT@#$DOCROOT#g"
###
## Definitions for @VSERVER@ 
###
<VirtualHost *:80>
ServerName @VSERVER@ 
DocumentRoot @DOCROOT@
</VirtualHost>

<Directory @DOCROOT@>
	Options FollowSymLinks Indexes ExecCGI
	AllowOverride None
	Order allow,deny
	Allow from all
</Directory>

<Directory @DOCROOT@/install/sbin>
	AllowOverride None
	SSLRequireSSL
	SSLVerifyClient None
	Allow from all
</Directory>
# allow all access to the rolls RPMS
<Directory @DOCROOT@/install/rolls>
        DirectoryIndex /install/rolls/index.cgi
        Allow from all
</Directory>

EOF
