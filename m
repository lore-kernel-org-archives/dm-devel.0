From: Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH v5] DM: dm-inplace-compress: inplace compressed DM target
Date: Mon, 13 Mar 2017 14:30:40 -0700
Message-ID: <1489440641-8305-1-git-send-email-linuxram@us.ibm.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: corbet@lwn.net, shli@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hbabu@us.ibm.com, linuxram@us.ibm.com, julia.lawall@lip6.fr
List-Id: dm-devel.ids

This  patch   provides   a   generic  device-mapper  compression device.
Originally written by Shaohua Li.
https://www.redhat.com/archives/dm-devel/2013-December/msg00143.html

I have optimized and hardened the code.

I have not received any negative comments till now.  Feel confident with the
code.  Please consider merging the code upstream.


Testing:
-------
This compression block device  is   tested in  the  following scenarios
a) backing a ext4/xfs/btrfs filesystem 
b) backing swap

Ran 'badblocks' test on the compressed block device.
Thoroughly stress tested on PPC64 and x86 system.

I have included a test-script that I used to test the block device.

Version v5:
	Modified the parameter list format to use token=value.
	Fixed a coding issue noted by Julia Lawall.
	Fixed data corruption issue when compressed size was same as the
	original data.
	Modified the allowed maximum I/O size to be as large as two pages,
	without  which  larger  size  I/O  need  larger  size  buffers to 
	temporarily hold  compressed data. This can lead  to inability to 
	satisfy memory allocation requests.

Version v4:
	fixed kbuild errors; hopefully they are all taken care off.
       	  - no reference to zero_page
	  - convert all divide and mod operations to bit operations

Version v3:
	Fixed  sector  alignment  bugs  exposed  while   testing on x86.
	Explicitly set the maximum request size  to 128K.  Without which
	range  locking  failed,  causing  I/Os  to  stamp   each  other.
	Fixed an occasional data corruption  caused by wrong size of the
	compression buffer.
	Added  a   parameter   while  creation  of  the   block  device, 
	to  not  sleep   during  memory  allocations. This can be useful
       	if the device is used as a swap device.

Version v2:
	All patches are merged into a single patch.
	Major code re-arrangement.
	Data and metablocks allocated based on the length of the device
	map rather than the size of the backing device.
        Size   of   each entry   in  the bitmap array is explicitly set
	 to 32bits.
	Attempt  to  reuse  the  provided  bio  buffer  space   instead
	 of allocating a new one.

Version v1:
	Comments from Alasdair have been incorporated.
	https://www.redhat.com/archives/dm-devel/2013-December/msg00144.html


Ram Pai (1):
  From: Shaohua Li <shli@kernel.org>

 Documentation/device-mapper/dm-inplace-compress.txt |  174 +
 drivers/md/Kconfig                                  |    6 
 drivers/md/Makefile                                 |    2 
 drivers/md/dm-inplace-compress.c                    | 2295 ++++++++++++++++++++
 drivers/md/dm-inplace-compress.h                    |  194 +
 5 files changed, 2671 insertions(+)



---------- Test script -------------
#!/bin/bash
# a test program to verify the correctness of
# the dm-inplace-compression target
# - Ram Pai

compdevname="__compdev"
usage()
{
	echo 
	echo 
        echo "$1:  -d <device path> [ -h ] [ -c <compdevicename> ]"
        echo "-d <device path> path to the block device to "
	echo "	back the compression device"
	echo "-c <compdevicename>  some unique name of the compress"
	echo " device name to be used. Defaults to $compdevname"
        echo "-h help"
	echo 
	echo 
        return
}

getsize()
{
	#the target will spew out the maximum size that
	#it can accommodate for the device. So start with
	#insane number and let it fail.
	insane=999999999999999999990009
	dmsetup create $2 --table \
		"0 $insane inplacecompress device=$1, \
		writethrough,compressor=lzo" 2>/dev/null
	echo $(dmesg | \
	   grep 'dm-inplace-compress:  This device can accommodate at most'\
	   | tail -1 | awk '{print $(NF-1)}')
}

MYNAME=$(basename $0)
OPTIND=0
while getopts "d:c:h" args $OPTIONS
do
     case "$args" in
        d)      device=$OPTARG
                ;;
        c)      compdevname=$OPTARG
                ;;
        *)      usage $MYNAME
                exit 1
                ;;
        esac
done

if [ -z "$device" ]
then
	usage $MYNAME
	exit 1;
fi

if [ ! -b "$device" ]
then
	usage $MYNAME
	echo ERROR: $device is not a block device
	exit 1;
fi

if [ -b "/dev/mapper/$compdevname" ]
then
	echo "WARNING: $compdevname already exist"
	usage $MYNAME
fi

echo -n "ANY DATA ON $device WILL BE LOST. Continue using $device?: y/n:"
read yesorno
if [ "$yesorno" != "y" ]
then
	echo "Ok, exiting"
	exit 1;
fi

dmsetup targets | grep inplacecompress > /dev/null
if [ $? -ne 0 ]
then
	echo "Please enable dminplacecompress target in the kernel"
	echo "Try modprobe dm-inplace-compress.ko"
	exit 1
fi



#clean and init the device
dd if=/dev/zero of=$device count=100 2> /dev/null

dmsetup remove $compdevname 2> /dev/null
size=$(getsize $device $compdevname)
if [ ! -n $size ]
then
	echo "FAILURE: determining the maximum possible size of the device"
	exit 1
fi

ret=0
for mode in writethrough writeback=2
do
 for i in lzo 842
 do
	cat /proc/crypto  | grep -w "$i$" > /dev/null
	if [ $? -ne 0 ]
	then
		continue
	fi

	echo "Testing: $i $mode....:"

	#generate the device
	dmsetup create $compdevname --table "0 $size inplacecompress device=$device, $mode ,compressor=$i"
	if [ $? -ne 0 ]
	then
		echo "FAILURE: creating the device"
		exit 1
	fi

	badblocks -wsv /dev/mapper/$compdevname
	if [ $? -ne 0 ]
	then
		echo "FAILURE:"
		ret=1
	fi

	##
	##
	## ADD MORE TESTS HERE
	##
	##

	echo "PASS"
	dmsetup remove $compdevname
 done
done

if [ $ret -eq 0 ]
then
	echo CONGRATS IT WORKS
	exit 0
else
	echo FAIL
	exit 0
fi
------------------------
