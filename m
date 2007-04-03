From: syrius.ml@no-log.org
Subject: bio too big device md1 (16 > 8)
Date: Tue, 03 Apr 2007 02:05:50 +0200
Message-ID: <87odm6wdxc.87mz1qwdxc@87lkhawdxc.message.id>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,

i'm using 2.6.21-rc5-git9 +
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-merge-max_hw_sector.patch 
( i've been testing with and without it, and first encountered it on
2.6.18-debian )

I've setup a raid1 array md1 (it was created in a degraded mode using
the debian installer)
(md0 is also a small raid1 array created in degraded mode, but i did
not have any issue with it)

md1 hold a lvm physical volume holding a vg and several lvs

mdadm -D /dev/md1:
/dev/md1:
        Version : 00.90.03
  Creation Time : Sun Mar 25 16:34:42 2007
     Raid Level : raid1
     Array Size : 290607744 (277.15 GiB 297.58 GB)
    Device Size : 290607744 (277.15 GiB 297.58 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Apr  3 01:37:23 2007
          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0

           UUID : af8d2807:e573935d:04be1e12:bc7defbb
         Events : 0.422096

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1       0        0        1      removed


the problem i'm encountering is when i add /dev/md2 to /dev/md1.

mdadm -D /dev/md2
/dev/md2:
        Version : 00.90.03
  Creation Time : Sun Apr  1 15:06:43 2007
     Raid Level : linear
     Array Size : 290607808 (277.15 GiB 297.58 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Sun Apr  1 15:06:43 2007
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

       Rounding : 64K

           UUID : 887ecdeb:5f205eb6:4cd470d6:4cbda83c (local to host odo)
         Events : 0.1

    Number   Major   Minor   RaidDevice State
       0      34        4        0      active sync   /dev/hdg4
       1      57        2        1      active sync   /dev/hdk2
       2      91        3        2      active sync   /dev/hds3
       3      89        2        3      active sync   /dev/hdo2

I use mdadm --manage --add /dev/md1 /dev/md2
when I do so here is what happen:
md: bind<md2>
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:hda3
 disk 1, wo:1, o:1, dev:md2
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) 
for reconstruction.
md: using 128k window, over a total of 290607744 blocks.
bio too big device md1 (16 > 8)
Device dm-7, XFS metadata write error block 0x243ec0 in dm-7
bio too big device md1 (16 > 8)
I/O error in filesystem ("dm-8") meta-data dev dm-8 block 0x1b5b6550       ("xfs_trans_read_buf") error 5 buf count 8192
bio too big device md1 (16 > 8)
I/O error in filesystem ("dm-8") meta-data dev dm-8 block 0x1fb3b00       ("xfs_trans_read_buf") error 5 buf count 8192

every filesystems on md1 get corrupted.
I manually fail md2 then reboot and so i can boot the fs again.
(but md1 is still degraded)

Any idea ?
I can provide more information if needed. (the only weird thing is
/dev/hdo that doesn't seem to be lba48-ready, but i guess that
shouldn't be a geometry issue.)

-- 
