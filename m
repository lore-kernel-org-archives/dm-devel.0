From: "Wood, Brian J" <brian.j.wood@intel.com>
Subject: Question about using dmraid45 patch
Date: Thu, 29 Mar 2007 10:04:04 -0700
Message-ID: <D44F48C7D79D2943A073C8FA0F49A3CCC64CA6@orsmsx418.amr.corp.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
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

Hello, I'm new to the dm-devel mail list, so hopefully my question won't
get flamed too badly :)

I need some help with a setup issue in dmraid, specifically raid5. I'm
trying to use Heinz Mauelshagen's patch for dmraid45 and having problems
getting it to compile in the kernel (or as a module). It's been a number
of years since I've worked with Linux, so I might be missing something
blatantly easy.=20

I have downloaded the source for both 2.6.18.1 (which the patch
specifically applies to) and 2.6.18.8 which RHEL5 uses. When I used the
2.6.18.8 kernel I applied the patch, I copied the .config over from the
kernel directory, and used "menu gconfig" to active (as a module) the
dmraid45 in device mapper under device drivers. I compiled the kernel,
copied over the files, edited grub and rebooted into the new
kernel...all seemed to go fine. I rebooted again when into the OPROM and
setup a raid5 volume (I have the system loaded onto a raid0 volume; the
system has 5 SATA disks total). After booting back into the new kernel I
ran the command "dmraid -tay" to list my active tables (I hope that's
the right way to describe it) and got:

[root@localhost ~]# dmraid -tay
isw_dfbhbdaedb_Volume0: 0 312592896 striped 2 256 /dev/sda 0 /dev/sdb 0
isw_bffiiabjc_Volume1: 0 312592896 raid45 core 2 65536 nosync raid5_la 1
128 3 -1 /dev/sdc 0 /dev/sdd 0 /dev/sde 0
isw_dfbhbdaedb_Volume01: 0 1108422 linear
/dev/mapper/isw_dfbhbdaedb_Volume0 63
isw_dfbhbdaedb_Volume02: 0 2104515 linear
/dev/mapper/isw_dfbhbdaedb_Volume0 1108485
isw_dfbhbdaedb_Volume03: 0 309379770 linear
/dev/mapper/isw_dfbhbdaedb_Volume0 3213000

I then tried to activate the volumes and got:

[root@localhost ~]# dmraid -ay
RAID set "isw_dfbhbdaedb_Volume0" already active
ERROR: device-mapper target type "raid45" not in kernel

I then used lsmod to see if my module was active and saw this:
[root@localhost ~]# lsmod | grep -e "dm"
dm_snapshot            48824  0=20
dm_zero                35200  0=20
dm_mirror              46976  0=20
dm_log                 42496  1 dm_mirror
dm_mod                 92880  17 dm_snapshot,dm_zero,dm_mirror,dm_log

nothing to do with raid5.

I ran insmod and got the error::
[root@localhost ~]# insmod
/lib/modules/2.6.18.1/kernel/drivers/md/dm-raid4-5.ko=20
insmod: error inserting 'drivers/md/dm-raid4-5.ko': -1 Unknown symbol in
module

I wanted to do a test at this point to see if it might be the kernel
.config file I had from the RHEL5 2.6.18.8 release, so I used a fresh
drop of kernel 2.6.18.1 (the one listed inside the patch code), applied
the dmraid45 patch, and used "make gconfig" to configure the kernel. I
went into device drivers and unselected everything except device mapper
support and the new subcategory of RAID4/5 target to be inserted as part
of the kernel. I even unselected Loadable Module Support just to make
sure :)
I then set make to use -d to get a little more info on the error, here's
what it showed when trying to compile:


    Successfully remade target file `drivers/md/xor.o'.
    Pruning file `FORCE'.
   Finished prerequisites of target file `drivers/md/built-in.o'.
  Must remake target `drivers/md/built-in.o'.
Putting child 0x006bc870 (drivers/md/built-in.o) PID 30056 on the chain.
Live child 0x006bc870 (drivers/md/built-in.o) PID 30056=20
  LD      drivers/md/built-in.o
drivers/md/dm-mem-cache.o: In function `pl_elem':
/usr/src/kernels/linux-2.6.18.1/drivers/md/dm-mem-cache.h:18: multiple
definition of `pl_elem'
drivers/md/dm-raid4-5.o:/usr/src/kernels/linux-2.6.18.1/drivers/md/dm-me
m-cache.h:18: first defined here
Reaping losing child 0x006bc870 PID 30056=20
make[2]: *** [drivers/md/built-in.o] Error 1
Removing child 0x006bc870 PID 30056 from chain.
Reaping losing child 0x00697ed0 PID 29856=20
make[1]: *** [drivers/md] Error 2
Removing child 0x00697ed0 PID 29856 from chain.
Reaping losing child 0x006c4de0 PID 26812=20
make: *** [drivers] Error 2
Removing child 0x006c4de0 PID 26812 from chain.


Is there something I'm not setting in the build environment to build
this as part of the kernel or as a module? I looked in the raid4-5
readme.txt and it just says to apply the patch and have device mapper
installed (which RHEL5 does). I'm using gnu make version 3.81, gcc
version 4.1.1, and the version of RHEL5 is x86_64 (I've also tried this
same operation with i386). As something else to add I've tried this
entire operation with OpenSuSE 10.2 for x86_64 and i386.



Thank you for the help,=20

Brian Wood
Intel Corporation=20
Digital Enterprise Group
Manageability & Platform Software Division
brian.j.wood@intel.com
