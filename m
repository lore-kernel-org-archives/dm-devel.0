From: Michel Dubois <michel.dubois.mtl@gmail.com>
Subject: Re: Recover filenames from failed RAID0
Date: Sun, 17 Jul 2016 15:10:03 -0400
Message-ID: <CAAVC+N78o675MpkJN=VO_zZhh7ePer1zU-ePLJi4eNH04ih3mw@mail.gmail.com>
References: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Keith Busch <keith.busch@intel.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, NeilBrown <neilb@suse.com>, linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Dear linux-raid mailing list,

I have a RAID0 array of four 3TB disks that failed on the "third" disk.

I am aware of the non-redundancy of RAID0 but I would like to recover
the filenames from that RAID0. If I could recover some data it would
be a bonus.

Below you'll find the outputs of the following commands
 mdadm --examine /dev/sd[abcd]1
 fdisk -l

where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.

What could be my next step?

I thank you for your time

Michel Dubois

======================
mdadm --examine /dev/sd[abcd]1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db60 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db72 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
  Creation Time : Mon Apr 23 19:55:36 2012
     Raid Level : raid1
  Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
     Array Size : 20980800 (20.01 GiB 21.48 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 0

    Update Time : Mon Jun 27 21:12:23 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 1a57db86 - correct
         Events : 164275


      Number   Major   Minor   RaidDevice State
this     3       8       33        3      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       8       33        3      active sync   /dev/sdc1

======================
fdisk -l

WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sda: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x03afffbe

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1      267350  2147483647+  ee  EFI GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x142a889c

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1      267350  2147483647+  ee  EFI GPT

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util
fdisk doesn't support GPT. Use GNU Parted.


Disk /dev/sdc: 3000.5 GB, 3000592982016 bytes
255 heads, 63 sectors/track, 364801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x3daebd50

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      267350  2147483647+  ee  EFI GPT

Disk /dev/md0: 21.4 GB, 21484339200 bytes
2 heads, 4 sectors/track, 5245200 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table
