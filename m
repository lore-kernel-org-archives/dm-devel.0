From: Arno Wagner <wagner@tik.ee.ethz.ch>
Subject: Re: device-mapper: device /dev/hdc too small for target
Date: Tue, 7 Feb 2006 19:41:06 +0100
Message-ID: <20060207184106.GB22775@tik.ee.ethz.ch>
References: <43E8DAD6.3030208@kreno.be>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <43E8DAD6.3030208@kreno.be>
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

Is it possible that you are using the wrong target type, 
e.g. RAID0/1/5? That would explain the complaint about hdc being
too small. Maybe you do not have linear in as target type
in the new system?

If you do a 'cat /proc/mdstat', it needs to list the
'linear' target, like this:

root ~>cat /proc/mdstat 
Personalities : [linear] [raid0] [raid1] [raid5] [raid10] 
...             ^^^^^^^^  

Arno


On Tue, Feb 07, 2006 at 06:37:26PM +0100, Thomas Berton wrote:
> Hello,
> I'm encountering some problems with device-mapper when migrating my lvm 
> system to a new debian system.
> I must say I had to play around with pvcreate and vgcfgrestore to get 
> /dev/hdb recognized again on the new system but after fixing that issue 
> I'm stuck with following problem:
> Booting the new system with the lvm disks it seems that the 
> device-mapper is having troubles putting together the lvm device:
> 
> output from dmesg:
> device-mapper: 4.1.0-ioctl (2003-12-10) initialised: dm@uk.sistina.com
> device-mapper: device /dev/hdc too small for target
> device-mapper: : dm-linear: Device lookup failed
> 
> device-mapper: error adding target to table
> 
> Starting the lvm service gives the following:
> storage:~# /etc/init.d/lvm start
> Setting up LVM Volume Groups...
> Reading all physical volumes.  This may take a while...
> Found volume group "storage" using metadata type lvm2
> /dev/storage: opendir failed: No such file or directory
> device-mapper ioctl cmd 9 failed: Invalid argument
> Couldn't load device 'storage-storage1'.
> 1 logical volume(s) in volume group "storage" now active
> storage:~#
> 
> Nevertheless other lvm commands seem to display correct information 
> about the lvm.
> Below is the output from pvscan, lvscan, lvmdiskscan, pvdisplay and 
> vgdisplay.
> The lvm is appearing in the /dev/mapper folder, but no link is made in 
> the /dev folder btw.
> Mounting the lvm fails, gives the error of bad superblock (ext3 
> filesystem).
> The lvm has been created using the full disks and not working on 
> partitions.
> I'm hoping someone on this list can help me out or give me some pointers 
> on how to continue and getting the disks right and making my lvm 
> mountable again.
> Thx in advance,
> Thomas.
> 
> storage:~# pvscan
> PV /dev/hda   VG storage   lvm2 [279.46 GB / 0    free]
> PV /dev/hdc   VG storage   lvm2 [189.92 GB / 0    free]
> PV /dev/hdb   VG storage   lvm2 [279.46 GB / 0    free]
> Total: 3 [748.84 GB] / in use: 3 [748.84 GB] / in no VG: 0 [0   ]
> storage:~#
> 
> storage:~# lvscan
> ACTIVE            '/dev/storage/storage1' [748.84 GB] inherit
> storage:~#
> 
> storage:~# lvmdiskscan
> /dev/hda  [      279.46 GB] LVM physical volume
> /dev/hdc  [      189.92 GB] LVM physical volume
> /dev/sda1 [       18.63 GB]
> /dev/sda2 [      957.00 MB]
> /dev/sda3 [        4.66 GB]
> /dev/sda5 [      956.97 MB]
> /dev/sda6 [        2.80 GB]
> /dev/hdb  [      279.46 GB] LVM physical volume
> 0 disks
> 5 partitions
> 3 LVM physical volume whole disks
> 0 LVM physical volumes
> storage:~#
> 
> storage:~# pvdisplay
> --- Physical volume ---
> PV Name               /dev/hda
> VG Name               storage
> PV Size               279.46 GB / not usable 0
> Allocatable           yes (but full)
> PE Size (KByte)       4096
> Total PE              71541
> Free PE               0
> Allocated PE          71541
> PV UUID               ZDOYsq-1rGU-bngq-QVZu-DqvG-I7AO-r7Rnl5
> 
> --- Physical volume ---
> PV Name               /dev/hdc
> VG Name               storage
> PV Size               189.92 GB / not usable 0
> Allocatable           yes (but full)
> PE Size (KByte)       4096
> Total PE              48620
> Free PE               0
> Allocated PE          48620
> PV UUID               VT7Lkj-n4V1-G8mV-a6GF-kspp-Zs61-3YzXD3
> 
> --- Physical volume ---
> PV Name               /dev/hdb
> VG Name               storage
> PV Size               279.46 GB / not usable 0
> Allocatable           yes (but full)
> PE Size (KByte)       4096
> Total PE              71541
> Free PE               0
> Allocated PE          71541
> PV UUID               jJqtAX-XxMz-nIEC-2ast-7y40-XPFG-rN0Rzz
> storage:~#
> 
> storage:~# vgdisplay
> --- Volume group ---
> VG Name               storage
> System ID
> Format                lvm2
> Metadata Areas        3
> Metadata Sequence No  12
> VG Access             read/write
> VG Status             resizable
> MAX LV                0
> Cur LV                1
> Open LV               0
> Max PV                0
> Cur PV                3
> Act PV                3
> VG Size               748.84 GB
> PE Size               4.00 MB
> Total PE              191702
> Alloc PE / Size       191702 / 748.84 GB
> Free  PE / Size       0 / 0
> VG UUID               59Yxut-UcZa-MBUS-KH8Y-5wZP-Eh1x-1E33Wl
> 
> storage:~#
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Arno Wagner, Dipl. Inform., CISSP --- CSG, ETH Zurich, wagner@tik.ee.ethz.ch 
GnuPG:  ID: 1E25338F  FP: 0C30 5782 9D93 F785 E79C  0296 797F 6B50 1E25 338F
----
Cuddly UI's are the manifestation of wishful thinking. -- Dylan Evans
Windows is the "under-3" toy of the OS world. -- Matthew D. Fuller
