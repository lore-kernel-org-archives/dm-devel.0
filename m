From: "John A. Sullivan III" <jsullivan@opensourcedevel.com>
Subject: prio_callout script to set failover priorities
Date: Mon, 13 Apr 2009 05:42:45 -0400
Message-ID: <1239615765.6376.62.camel@jaspav.missionsit.net.missionsit.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello, all.  At Christophe's invitation, I'll post our script and
documentation for setting path priorities with dm-multipath.  First,
lest I waste everyone's time wading through the script, let me explain
what we are trying to do in case we completely missed the point of
prio_callout and there is a better way to do what we want to do.

Our environment has many interfaces per system to the SAN and many
interfaces on the SAN devices themselves.  Because of heavy
virtualization, our environment is a few-to-few network and we thus do
not gain much from Ethernet bonding because the traffic collapses to a
single path based upon MAC address pairing and we create a single point
of failure in the switch.  I won't take time to explain that issue here
but we tried endless permutations largely constrained by the fact that
our PogoLinux/Nexenta/ZFS/opensolaris SAN devices only support 802.3ad.

We thus chose to distribute traffic across the interfaces using a
combination of dm-multipath and software RAID0.  We realize we could use
multibus for load balancing but seem to achieve better performance using
software RAID0.  In either case, we still need dm-multipath for
fault-tolerance and this is where the prio_callout script comes into
play.

Whether we are using a limited number of targets and RAID0 or a target
per virtual machine, we still want the traffic balanced across the
multiple Ethernet ports. This seemed to be the natural role of
prioritization.  For a simple illustration, let's assume I have two
ports and two virtual machines and the disks are exposed by the
underlying host as local disks (in other words, the host is using the
SAN and presenting the SAN based storage as local storage to the VMs or
even storing the VMs on the the SAN).  I want to send traffic for VM1
over port1 and traffic for VM2 over port2 but, in the event of failure
of either the server or SAN interface, the traffic should failover to
the available interface.

How do we tell dm-multipath running on the host to behave this way? Most
of what we saw about prio_callout scripts said they are binaries
supplied by the SAN vendor.  In our case, there was no such binary.  So,
we created our own based upon bash scripting.  This is a bit of a
problem as multipathd requires a binary to store in its ramfs but we got
around this by calling "/bin/bash <scriptname> %n"  Here is the script
and the logic which allows us to set our priorities as we wish from the
host side.

The script is actually in three parts which are concatenated into a
single script just before calling multipathd.  The basic idea is that
multipathd knows the short device name (e.g., sdd or sdah) when setting
up the path and can pass this to the script in the %n parameter.  We
have no idea how these device names will be assigned when iscsid sets up
the connections.  Thus, we correlate the device names with the mappings
in /dev/disk/by-path.  This is the part we dynamically pull in just
before multipathd starts.

Another part of the script contains a list of all the paths with a
designator of which path should be given which priority.  Configurable
direction of priorities is handled by editing this list.  We include
both lists as part of the script because multipathd does not have access
to disk while running.  Because the lists can be very large, we cannot
use sed to alter the list and thus concatenate parts of the script
including the dynamically created device list.  That's the overall
logic.  Here is the script:

The main script actually used by multipathd is named mpath_prio_ssi.
Various google sources said the script name must begin with mpath_prio.
I do not know if that is still true.  I've shortened the lists
dramatically just to make it easier to expunge sensitive information:

mpath_prio_ssi:
#!/bin/bash
# Copyright 2009 - John A. Sullivan III - SSI Services, LP
# if not passed any device name, return a priority of 0
if [ -z "${1}" ];then
	echo 0
	exit
fi

DEVS="lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac-lun-0 -> ../../sdj
lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c-lun-0 -> ../../sdr
lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7-lun-0 -> ../../sdn
lrwxrwxrwx 1 root root  9 Apr 11 23:13 ip-172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:7e8e4e27-5bec-6467-e44f-b0c48ef1ffcf-lun-0 -> ../../sdv"

# The iqns map as follows:
# base  = iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9
# ld02 = iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7
# ns01 = iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac
# p01 = iqn.1986-03.com.sun:02:99ea3d86-36a1-6c1f-9da0-a6c10dd9f966
# scanner01 = iqn.1986-03.com.sun:02:7e8e4e27-5bec-6467-e44f-b0c48ef1ffcf
# win = iqn.1986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c

# Edit this list to set priorities (-><priority value>)
LIST="172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->99
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->49
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->24
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->11
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->49
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->99
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->11
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->24"

FOUND=0
IFSORIG=${IFS}
IFS=$'\n'
# find the DEVS line which matches the device passed to prio_callout as %n
for LINE in ${DEVS}
do
	ENTRY=${LINE%/${1}}
	if [ ${#ENTRY} -ne ${#LINE} ];then # We found the line
		FOUND=1
		break
	fi
done
if [ "$FOUND" = "0" ];then  # This is not an iSCSI device
	echo 0
	exit
fi
# strip off the beginning and end so the syntax matches the prioritization list syntax
DEV="${ENTRY##* ip-}"
#DEV="${DEV%% ->*}" # the pattern changed in CentOS 5.3
#DEV="$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
DEV="${DEV%%-lun-[0-9]* ->*}"
PRIORITY=0
# find the matching priority line and echo the priority
# the echo to stdout seems to be what prio_callout uses
for LINE in ${LIST}
do
	DISK=${LINE%->*}
	if [ "${DEV}" = "${DISK}" ];then
		PRIORITY="${LINE##*->}"
		break
	fi
done
echo ${PRIORITY}

That's the main script.  We create it dynamically using a script named
priomaker:

priomaker:
#!/bin/bash
# Copyright 2009 - John A. Sullivan III - SSI Services, LP
cd /usr/local/sbin
LIST="$(ls -l1 /dev/disk/by-path | grep ip-.*[a-z]$)"
# The DEVS= line is too long to edit with sed so we will construct the priority script from parts
cat mpath_prio_ssi.head > mpath_prio_ssi
echo -e "DEVS=\"${LIST}\"\n" >> mpath_prio_ssi
cat mpath_prio_ssi.tail >> mpath_prio_ssi
chmod a+x mpath_prio_ssi

Here are the head and tail scripts:
mpath_prio_ssi.head:
#!/bin/bash
# Copyright 2009 - John A. Sullivan III - SSI Services, LP
# if not passed any device name, return a priority of 0
if [ -z "${1}" ];then
	echo 0
	exit
fi


mpath_prio_ssi.tail:
# The iqns map as follows:
# base  = iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9
# ld02 = iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7
# ns01 = iqn.1986-03.com.sun:02:17f534f0-74af-e61b-a716-b8ac8e219dac
# p01 = iqn.1986-03.com.sun:02:99ea3d86-36a1-6c1f-9da0-a6c10dd9f966
# scanner01 = iqn.1986-03.com.sun:02:7e8e4e27-5bec-6467-e44f-b0c48ef1ffcf
# win = iqn.1986-03.com.sun:02:47c5e722-10d3-66c7-a952-d3d79732da9c

# Edit this list to set priorities (-><priority value>)
LIST="172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->99
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->49
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->24
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:adb0cf37-9a23-6fc9-922a-eb4540bee1c9->11
172.x.x.78:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->49
172.x.x.46:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->99
172.x.x.62:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->11
172.x.x.30:3260-iscsi-iqn.1986-03.com.sun:02:520e823d-342c-6668-9477-fad130b148d7->24"

FOUND=0
IFSORIG=${IFS}
IFS=$'\n'
for LINE in ${DEVS}
do
	ENTRY=${LINE%/${1}}
	if [ ${#ENTRY} -ne ${#LINE} ];then # We found the line
		FOUND=1
		break
	fi
done
if [ "$FOUND" = "0" ];then  # This is not an iSCSI device
	echo 0
	exit
fi
DEV="${ENTRY##* ip-}"
#DEV="${DEV%% ->*}" # the pattern changed in CentOS 5.3
#DEV="$(echo ${DEV} | sed 's/-lun-[0-9][0-9]* ->.*//')"
DEV="${DEV%%-lun-[0-9]* ->*}"
PRIORITY=0
for LINE in ${LIST}
do
	DISK=${LINE%->*}
	if [ "${DEV}" = "${DISK}" ];then
		PRIORITY="${LINE##*->}"
		break
	fi
done
echo ${PRIORITY}

That's it.  I hope it is helpful to someone else.  I also very much hope
someone can tell us why this breaks in 5.3 when it worked fine in 5.2.
It now seems /bin/bash cannot find mpath_prio_ssi.  Thanks - John
-- 
John A. Sullivan III
Open Source Development Corporation
+1 207-985-7880
jsullivan@opensourcedevel.com

http://www.spiritualoutreach.com
Making Christianity intelligible to secular society
