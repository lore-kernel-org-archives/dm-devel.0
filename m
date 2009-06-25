From: Frans Pop <elendil@planet.nl>
Subject: Re: [2.6.31-rc1] device-mapper: target device sda6 is misaligned
Date: Thu, 25 Jun 2009 19:53:32 +0200
Message-ID: <200906251953.34253.elendil@planet.nl>
References: <200906250904.57149.elendil@planet.nl> <200906251840.07617.elendil@planet.nl> <20090625172041.GA22891@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755593AbZFYRxl@vger.kernel.org>
In-Reply-To: <20090625172041.GA22891@redhat.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, martin.petersen@oracle.com
List-Id: dm-devel.ids

On Thursday 25 June 2009, Mike Snitzer wrote:
> > I'm afraid those files don't exist on my systems (none of them: arm,
> > s390 and x86_64 notebook). Some kernel config option I'm missing
> > maybe?
>
> You should definitely have the topology attributes in the associated
> device's sysfs tree.

Ah, sorry. I'd switched back to .30 for the arm system because of this.
(And on the s390 box I looked for sda instead of dasdb; duh!)

Here are the values for arm:

$ cat /sys/block/sda/sda6/alignment_offset
0
$ cat /sys/block/sda/queue/physical_block_size
512
$ cat /sys/block/sda/queue/logical_block_size
512

And here's the lot for the s390 emulator:

# grep . /sys/block/dasdb/dasdb*/alignment_offset
/sys/block/dasdb/dasdb1/alignment_offset:0
/sys/block/dasdb/dasdb2/alignment_offset:0
# grep . /sys/block/dasdb/queue/physical_block_size
4096
# grep . /sys/block/dasdb/queue/logical_block_size
4096

# pvs -o +pe_start
  PV          VG     Fmt  Attr PSize   PFree 1st PE
  /dev/dasdb1 mordor lvm2 a-   388.00M    0  192.00K
  /dev/dasdb2 mordor lvm2 a-   388.00M    0  192.00K
# dmsetup ls
mordor-home     (254, 0)
# dmsetup table
mordor-home: 0 794624 linear 94:5 384
mordor-home: 794624 794624 linear 94:6 384

# fdasd -p /dev/dasdb
reading volume label ..: VOL1
reading vtoc ..........: ok

Disk /dev/dasdb:
  cylinders ............: 1113
  tracks per cylinder ..: 15
  blocks per track .....: 12
  bytes per block ......: 4096
  volume label .........: VOL1
  volume serial ........: 0X0121
  max partitions .......: 3

 ------------------------------- tracks -------------------------------
               Device      start      end   length   Id  System
          /dev/dasdb1          2     8346     8345    1  Linux native
          /dev/dasdb2       8347    16694     8348    2  Linux native
