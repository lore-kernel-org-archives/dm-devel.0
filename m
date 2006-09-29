From: "govind raj" <agovinda04@hotmail.com>
Subject: Incorrect creation of partition table
Date: Fri, 29 Sep 2006 19:55:18 +0530
Message-ID: <BAY109-F1628C528AB5898811DEB0ED6180@phx.gbl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi all,

We are currently using EVMS 2.5.4/device-mapper: 4.4.0  on Intel XScale 
processor (8032x) running
Linux kernel version 2.6.15.4.

While the same version of EVMS is working fine on the Intel P4 processor, if
we port the code to this Xscale processor and run it, we are experiencing
some unpredictable behaviours when creating a EVMS segment. Even though it
says that it creates the segment, if we subsequently do a 'fdisk -l', we see
various behaviors. Sometime the fdisk for this drive, says that the "Does
not contain valid partition" and sometimes we find sdb1, sdb2 etc partition
are getting created. We start getting two segments as sdb2 and sdb5 even if
we just create one segment.

We are enclosing the output of the relevant commands below (The same
commands works fine on the Intel P4 processor with the same Linux version
and the EVMS version):

#echo create:segment,sdc_freespace1, | /usr/local/arm/evms/sbin/evms

EVMS Command Line Interpreter Version 2.5.4

EVMS: The create command created segment: sdc1
#
#fdisk -l

Device Boot    Start       End    Blocks   Id  System
/dev/sdc1               1           1           0    0  Empty
Partition 1 does not end on cylinder boundary.
#

It looks like  the partition table is not correctly created from the above
observations.

On further debugging this problem, we found that device node from EVMS is
getting successfully created  from the relevant commands ( attached below).
From the looks of it, it looks like the partition table  for that disk node
is not getting correctly written. Is this partition data created by device
mapper or by some other module?

Can anyone throw more light into the possible causes of this problem and how
it may be resolved?

The verbose mode creation output:
-----------------------------------------------------------------------------------------------------------------------------------------
bash-3.00# echo create:segment,sdb_freespace1, | ./evms -s -d Error -v1

EVMS Command Line Interpreter Version 2.5.4

Loading module: /usr/local/arm/evms/lib/evms/2.5.4/bbr-1.1.14.so
Validating plug-in: Bad Block Relocation Feature
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/bsd-1.0.8.so
Validating plug-in: BSD Segment Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/disk-1.2.12.so
Validating plug-in: Local Disk Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/dos-1.1.15.so
Validating plug-in: DOS Segment Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/drivelink-3.0.6.so
Validating plug-in: Drive Linking Feature
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/error-1.0.2.so
Validating plug-in: Error Device Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/ext2-1.1.13.so
Validating plug-in: Ext2/3 File System Interface Module
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/lvm-1.1.14.so
Validating plug-in: LVM Region Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/lvm2-1.0.4.so
Validating plug-in: LVM2 Region Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/mac-1.0.8.so
Validating plug-in: MAC Segment Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/md-1.1.19.so
Validating plug-in: MD Linear Raid Region Manager
Validating plug-in: MD Raid 1 Region Manager
Validating plug-in: MD RAID0 Region Manager
Validating plug-in: MD RAID 4/5 Region Manager
Validating plug-in: MD Multipath Region Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/multipath-1.0.4.so
Validating plug-in: Multipath Segment Manager
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/reiser-1.1.14.so
Validating plug-in: ReiserFS File System Interface Module
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/replace-1.1.3.so
Validating plug-in: EVMS Replace
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/snapshot-3.1.10.so
Validating plug-in: Snapshot Feature
Loading module: /usr/local/arm/evms/lib/evms/2.5.4/swap-1.1.13.so
Validating plug-in: Swap File System Interface Module
Setup plug-in: Local Disk Manager
Setup plug-in: Error Device Manager
Setup plug-in: EVMS Replace
Setup plug-in: BSD Segment Manager
Setup plug-in: DOS Segment Manager
Setup plug-in: MAC Segment Manager
Setup plug-in: Multipath Segment Manager
Setup plug-in: LVM Region Manager
Setup plug-in: LVM2 Region Manager
Setup plug-in: MD Linear Raid Region Manager
Setup plug-in: MD Raid 1 Region Manager
Setup plug-in: MD RAID0 Region Manager
Setup plug-in: MD RAID 4/5 Region Manager
Setup plug-in: MD Multipath Region Manager
Setup plug-in: Bad Block Relocation Feature
Setup plug-in: Drive Linking Feature
Setup plug-in: Snapshot Feature
Setup plug-in: Ext2/3 File System Interface Module
Setup plug-in: ReiserFS File System Interface Module
Setup plug-in: Swap File System Interface Module
Discovering disks...
Discovering disks
Discovering disks.
Discovering segments...
Discovering segments
Discovering segments.
Discovering segments..
Discovering segments...
Discovering segments
Discovering segments.
Discovering segments..
Discovering segments...
Discovering segments
Discovering segments.
Discovering segments..
Discovering regions...
Discovering regions
Discovering regions.
Discovering regions..
Discovering regions...
Discovering regions
Discovering regions.
Discovering regions..
Discovering regions...
Discovering regions
Discovering regions.
Discovering regions..
Discovering regions...
Discovering regions
Cleaning up the /dev/evms tree...
Cleaning up the /dev/evms tree
Cleaning up the /dev/evms tree.
Cleaning up the /dev/evms tree..
Cleaning up the /dev/evms tree...
Cleaning up the /dev/evms tree
Cleaning up the /dev/evms tree.
Finished cleaning up the /dev/evms tree.
Discovery finished.
EVMS: The create command created segment: sdb1
All pending changes are now being committed to disk.
Phase 0:  Committing changes on segment sdb_mbr...
Processing the Kill Sectors List...
Phase 1:  Committing changes on segment sdb_mbr...
Phase 1:  Writing stop data on object sdb1...
Phase 2:  Writing stop data on object sdb1...
Activating volumes...
Cleaning up the /dev/evms tree...
Cleaning up the /dev/evms tree
Cleaning up the /dev/evms tree.
Cleaning up the /dev/evms tree..
---------------------------------------------------------------------------------------------------------------------------------------
we are also able to see the device for particular segment sdb1.

#ls -l /dev/evms/.nodes/
brw-r-----    1 root     root       8,  16 Jan  1 05:31 sdb
brw-r-----    1 root     root     253,   0 Jan  1 05:36 sdb1
- Hide quoted text -

Thanks in advance for your inputs,
A.govind
