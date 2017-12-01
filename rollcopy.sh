#!/bin/bash
# copy contents of:
#       <isoname> to the directory <treepath>install/rolls 
# usage:
#      rollcopy.sh <isoname> <treepath>
# example:
#      rollcopy.sh /path/to/kernel.iso .
#
# @Copyright@
# @Copyright@
ROLLISO=$1
DISTPATH=$2
if [ ! -f $ROLLISO ]; then
	echo "$ROLLISO not found"
	exit -1;
fi
if [ ! -d /mnt/cdrom ]; then mkdir -p /mnt/cdrom; fi
mount -o loop $ROLLISO /mnt/cdrom

DESTPATH=$(readlink -f $DISTPATH)
if [ ! -d $DESTPATH/install/rolls ]; then mkdir -p $DESTPATH/install/rolls; fi
echo Copying "$ROLLISO"
(cd /mnt/cdrom; tar cf - --exclude=TRANS.TBL --exclude=.discinfo --exclude=var --exclude=var --exclude=repodata --exclude=EFI --exclude=images --exclude=LiveOS --exclude=comps.xml --exclude=ks.cfg --exclude=isolinux .) | (cd $DESTPATH/install/rolls; tar xvfBp - )

umount /mnt/cdrom
