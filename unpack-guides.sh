#!/bin/bash
# unpack roll usersguide rpms found in 
#       <rpmpath> to <treepath>/roll-documentation :
# usage:
#	unpack-guides.sh <rpmpath> <treepath>
# example:
#       unpack-guides.sh /path/to/install/rolls .
#
# @Copyright@
# @Copyright@
RPMPATH=$1
DISTPATH=$2
TMPPATH=$(mktemp -d)
for guide in $(find $RPMPATH -name 'roll-*-usersguide*rpm'); do
	echo "found guide rpm: $guide"
	rpm2cpio $guide | ( cd $TMPPATH; cpio -id)
done	
DESTPATH=$(readlink -f $DISTPATH)
if [ ! -d $DESTPATH/roll-documentation ]; then mkdir -p $DESTPATH/roll-documentation; fi
gpath=$(find $TMPPATH -name roll-documentation -prune)
if [ "x$gpath" != "x" ]; then
	/bin/cp -fR $gpath/* $DESTPATH/roll-documentation
fi
/bin/rm -rf $TMPPATH

