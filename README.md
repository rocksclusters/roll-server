__Scripts to copy [Rocks Clusters](http://www.rocksclusters.org) roll isos to a generic (linux) webserver for faster local hosting__

Purpose: Rocks 7.0 frontends require a web server to have rolls "installed" to download.  Sometimes distance or
other issues indicate that a local copy on an existing (non-Rocks) web-server would be much better.  The scripts in this
repository help  with that.

There are four scripts defined in this roll
* rollcopy.sh - copy a roll iso contents for web serving
* index.cgi  - cgi to present roll directory in a standard format
* httpdconf.sh (optional) - defines a virtual server httpd configuration file
* unpack-guides (optional) - unpacks roll users guides into a web-servable directory

__0. Preparation__
* clone this repository `git clone https://github.com/rocksclusters/roll-server.git`
* download the roll isos from UCSD.

__I. Copy Roll(s) to a web directory__
For this example, will assume the `/var/www/html/rocks/7.0`  is the (already created) parent directory into 
which you want to copy rolls.  The `rollcopy.sh` script will create the subdirectory `install/rolls`.
to copy the iso file, `CentOS-7.4.1708-0.x86_64.disk1.iso` to the the release directory:
```
# rollcopy.sh CentOS-7.4.1708-0.x86_64.disk1.iso /var/www/html/rocks/7.0
```
Repeat the above for each roll iso that you want to copy

__II. Make certain that the supplied `index.cgi` script gives the directory listing__
```
# cp index.cgi /var/www/html/rocks/7.0/install/rolls
```
__III. (Optional) provide a virtual httpd server__
The script `httpdconf.sh` will write to standard output a reasonable stanza for Apache web server configuration.
Suppose that you wanted the virtual server to be called `rocks-7.my.org` and have it used  the directory above.
Then
```
httpdconf.sh rocks-7-0.my.org /var/www/html/rocks/7.0
```
will generate an httpds conf file. It is your responsibility to place this on the appropriate directory and restart
your webserver. 

__IV. (Optional) unpack the userguides__
You can unpack userguides 
```
unpack-guides.sh /var/www/html/rocks/7.0/install/rolls /var/www/html/rocks/7.0
```


