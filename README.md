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

You will probably need to add something like the following in your Apache 
configuration, so that the directory index is given via the index.cgi  

```
# allow all access to the rolls RPMS
<Directory /var/www/html/rocks/7.0/install/rolls>
	AddHandler cgi-script .cgi
        Options FollowSymLinks Indexes ExecCGI
        DirectoryIndex /rocks/7.0/install/rolls/index.cgi
        Allow from all
</Directory>
```
(See below for an example of how to test and verify that your index.cgi is being
called properly)

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

__V.  Verifying that your output is correct (that is, index.cgi is being called)__
try
```
wget -O - http://central-7-0-x86-64.rocksclusters.org/install/rolls
```
and compare the output of the rocks central server listing of rolls to
your website, something like 
```
wget -O - http://rocks-7-0.my.org/install/rolls

```
You should see output very similar to 
```
TTP request sent, awaiting response... 200 OK
Length: 877 [text/html]
Saving to: ‘STDOUT’

 0% [                                       ] 0           --.-K/s              <html><body><table><tr><td>
<a href="area51/">area51/</a>
</td></tr>
<tr><td>
<a href="base/">base/</a>
</td></tr>
<tr><td>
<a href="CentOS/">CentOS/</a>
</td></tr>
<tr><td>
<a href="core/">core/</a>
</td></tr>
<tr><td>
<a href="fingerprint/">fingerprint/</a>
</td></tr>
<tr><td>
<a href="ganglia/">ganglia/</a>
</td></tr>
<tr><td>
<a href="hpc/">hpc/</a>
</td></tr>
<tr><td>
<a href="htcondor/">htcondor/</a>
</td></tr>
<tr><td>
<a href="kernel/">kernel/</a>
</td></tr>
<tr><td>
<a href="kvm/">kvm/</a>
</td></tr>
<tr><td>
<a href="openvswitch/">openvswitch/</a>
</td></tr>
<tr><td>
<a href="perl/">perl/</a>
</td></tr>
<tr><td>
<a href="python/">python/</a>
</td></tr>
<tr><td>
<a href="sge/">sge/</a>
</td></tr>
<tr><td>
<a href="Updates-CentOS-7.4.1708/">Updates-CentOS-7.4.1708/</a>
</td></tr>
<tr><td>
<a href="zfs-linux/">zfs-linux/</a>
</td></tr>
100%[======================================>] 877         --.-K/s   in 0s     
```
__VI.  Verifying that rolls directories can be listed__

The rolls themselves need be listed. Try the following
```
wget -O -  http://central-7-0-x86-64.rocksclusters.org/install/rolls/base/7.0/x86_64
```
and verify that when you use your roll server instead that you get the same output

__VII. Other items to checkThe following may need to be checked/changed for your setup__

* Firewall needs modifying on your web server to allow http access (platform sepcific)

* SELinux may need to be modified or turned off (```setenforce Permissive```)



