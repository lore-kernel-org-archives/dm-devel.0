From: Tim Kirk <kirk@ysbl.york.ac.uk>
Subject: (no subject)
Date: Thu, 14 Sep 2006 12:02:16 +0100
Message-ID: <8859E1A9-9C74-4188-A678-F97FD77A86FF@ysbl.york.ac.uk>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

Not certain if this is where I should post this, but I've not been  
able to find anything or anywhere else that seems able to help me  
with this.

I have a PC with an A8V Deluxe motherboard using all 4 SATA channels  
for 4 drives. This machine worked how I needed it to under Fedora  
Core 4, and I have just reinstalled it with FC5 only to find that it  
will not let me run the 4 SATA drives as four separate drives.

After booting I find that the third and fourth drives are taken over  
by dm, and have a /dev/dm-0 and /dev/dm-1 that are not usable due to  
invalid partition tables and assorted other errors (not valid block  
devices etc...).

Using 'dmsetup remove_all' and then 'fdisk /dev/sdc', 'fdisk /dev/ 
sdd' (to give me a single partition on each drive), 'mke2fs -j /dev/ 
sdc1', 'mke2fs -j /dev/sdd1' gives me two mountable, usable, drives.

When I reboot the machine though these drives are remapped as /dev/dm- 
o and /dev/dm-1 and are now unmountable. If I use 'dmsetup  
remove_all' again the drives are now available to be reformatted  
again, but I have reformat them to make use of them.

Surely there is some way to tell device-mapper to leave things alone?  
I simply need four drives that I can use as four separate units - no  
RAIDing, nothing fancy, but this it seems impossible to tell the OS  
that...

Cheers,

Tim Kirk

More Detailed Information Below -

kudzu -ps

class: HD
bus: SCSI
detached: 0
device: sda
desc: "ATA HDS722525VLSA80"
host: 1
id: 0
channel: 0
lun: 0
-
class: HD
bus: SCSI
detached: 0
device: sdb
desc: "ATA HDS722525VLSA80"
host: 2
id: 0
channel: 0
lun: 0
-
class: HD
bus: SCSI
detached: 0
device: sdc
desc: "ATA HDS722525VLSA80"
host: 3
id: 0
channel: 0
lun: 0
-
class: HD
bus: SCSI
detached: 0
device: sdd
desc: "ATA HDS722525VLSA80"
host: 4
id: 0
channel: 0
lun: 0
-
class: RAID
bus: PCI
detached: 0
driver: sata_via
desc: "VIA Technologies, Inc. VIA VT6420 SATA RAID Controller"
vendorId: 1106
deviceId: 3149
subVendorId: 1043
subDeviceId: 80ed
pciType: 1
pcidom:    0
pcibus:  0
pcidev:  f
pcifn:  0
-
class: RAID
bus: PCI
detached: 0
driver: sata_promise
desc: "Promise Technology, Inc. PDC20378 (FastTrak 378/SATA 378)"
vendorId: 105a
deviceId: 3373
subVendorId: 1043
subDeviceId: 80f5
pciType: 1
pcidom:    0
pcibus:  0
pcidev:  8
pcifn:  0
-

Straight after reboot  (snipped out /dev/sda & /dev/sdb) :

[root@bragg1 ~]# fdisk -l

Disk /dev/sdc: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1       30401   244196001   83  Linux

Disk /dev/sdd: 250.0 GB, 250059350016 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sdd1               1       30401   244196001   83  Linux

Disk /dev/dm-0: 250.0 GB, 250059292672 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/dm-0p1               1       30401   244196001   83  Linux

Disk /dev/dm-1: 250.0 GB, 250056705024 bytes
255 heads, 63 sectors/track, 30400 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/dm-1 doesn't contain a valid partition table

Then :

[root@bragg1 ~]# fdisk /dev/dm1

Unable to open /dev/dm1

[root@bragg1 ~]# fdisk /dev/dm-0

The number of cylinders for this disk is set to 30401.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
    (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/dm-0: 250.0 GB, 250059292672 bytes
255 heads, 63 sectors/track, 30401 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/dm-0p1               1       30401   244196001   83  Linux

Command (m for help): q

So I have 1 disk I can use.

I then go through the dmsetup remove_all, fdisk, mke2fs rigmarole and  
then have two discs I can mount (I only have to fdisk /dev/sdc, then  
use 'p' to check that the partition table is what I want, and 'w' to  
write it and exit and the disk is fine for writing a filesystem onto  
- so the partition table is there as far as fdisk is concerned, but  
is not being read properly at some over level in the OS):

[root@bragg1 ~]# df -l
Filesystem           1K-blocks      Used Available Use% Mounted on
<snipped other drives>
/dev/sdc1            240362656    192672 237728024   1% /xray/bragg1c
/dev/sdd1            240362656    192672 237728024   1% /xray/bragg1d

This seems fine - exactly what I want. Then I try to reboot (I've had  
to make the drives 'noauto' and not to be fsck'd in /etc/fstab to get  
through the boot process without a 'cannot find /dev/sdc1' error).

And I get this :

[root@bragg1 ~]# mount -t ext3 /dev/sdc1 /xray/bragg1c
mount: /dev/sdc1 is not a valid block device
[root@bragg1 ~]# mount -t ext3 /dev/sdd1 /xray/bragg1d
mount: /dev/sdd1 is not a valid block device

What do I have to do to get the boot process to leave my hard drives  
formatted how they were before the reboot?
