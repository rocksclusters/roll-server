# roll-server

Scripts to help hosting a custom [Rocks Clusters](http://www.rocksclusters.org) roll download
server using apache/httpd

Rocks 7.0 frontend installation downloads "rolls" from remote server and installs them. The minimum
rolls required would end up 10 GB or above and downloading them for every installation is hard.
The scripts in this repository can help with that. We setup a local server that can simulate the
rocks cluster download server for easy download.

There are four scripts defined in this repo
* `index.cgi`  - cgi script to serve roll directory in a standard format
* `rollcopy.sh` - extract roll iso contents for web serving
* `httpdconf.sh` (optional) - defines a virtual server httpd configuration file
* `unpack-guides` (optional) - unpacks roll users guides into a web-servable directory

## 0. Preparation
* Clone this repository `git clone https://github.com/rocksclusters/roll-server.git`
* Download the roll isos from [rockscluster.org](http://central-7-0-x86-64.rocksclusters.org/isos/)

## I. Extract roll(s) to a web directory
`rollcopy.sh` extracts the roll iso files. The first argument `<file>` is the iso roll and the
second one is the server directory. It creates `install/rolls/` directory in the target and extracts
the files to it.

``` sh
$ rollcopy.sh <file> <target>
```

To extract the roll, `CentOS-7.4.1708-0.x86_64.disk1.iso` to the the server directory:
``` sh
$ rollcopy.sh CentOS-7.4.1708-0.x86_64.disk1.iso /var/www/html/
```

Repeat the above for each roll iso that you want to copy. The rolls will be accessbile for download
from the path `http://localhost/install/rolls/`.


## II. Copy `index.cgi` script for directory listing
Rocks frontend installation program searches for all the rolls by checking the directory listing of
files from the server. The `index.cgi` script servers the response by mimicking the rolls download
server. It needs to be copied to every directory.

``` sh
$ find /var/www/html/install/rolls -type d -exec cp index.cgi {} \;
```

Now configure `httpd` to execute the cgi script for every request

``` apache
# allow all access to the rolls RPMS
<Directory /var/www/html/install/rolls>
        # don't use SetHandler
        AddHandler cgi-script .cgi
        Options +FollowSymLinks +Indexes +ExecCGI
        DirectoryIndex /install/rolls/index.cgi
        Allow from all
</Directory>
```
(See below for an example of how to test and verify that your index.cgi is being
called properly)

## III. (Optional) serve directories on a virtual server
`httpdconf.sh` lets you generate a vhost configuration for the server

``` sh
$ httpdconf.sh rocks-7-0.my.org /var/www/html/
```

Above command generates a httpd vhost conf file with cgi handlers for  virtual server
`rocks-7.0.my.org`. If you have your rolls in `/var/www/html/rocks/7.0/[install/rolls/...]` then
change the second argument accordingly.

## IV. (Optional) unpack the userguides
You can unpack userguides
``` sh
$ unpack-guides.sh /var/www/html/rocks/7.0/install/rolls/ /var/www/html/rocks/7.0/
```

## V. Verifying that cgi scripts are working

Try
``` sh
$ wget -O - http://central-7-0-x86-64.rocksclusters.org/install/rolls/
```

and compare the output of the rocks central server listing of rolls to
your website, something like

``` sh
$ wget -O - http://rocks-7-0.my.org/install/rolls/
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

## VI. Verifying that rolls directories can be listed

The rolls themselves need be listed. Try the following

``` sh
$ wget -O -  http://rocks-7-0.my.org/install/rolls/base/7.0/x86_64
```
and verify that you get the same output from
`http://central-7-0-x86-64.rocksclusters.org/install/rolls/base/7.0/x86_64`

## VII. Other items to check

The following may need to be checked/changed for your setup:
  * Firewall needs modifying on your web server to allow http access (platform sepcific)
  * SELinux may need to be modified or turned off (e.g., ```setenforce Permissive```)
  * Check your permissions on the directories, run
    ``` sh
    $ chown www-data:www-data -R /var/www/html/rocks/7.0/
    ```
    to fix permissions to apache user. (run with sudo if necessary)
  * You might need root pemissions to run `rollcopy.sh`
  * Need to enable `cgi` module in apache/httpd
    ``` sh
    $ a2enmod cgi
    ```
