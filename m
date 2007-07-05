From: David Shaw <dshaw@jabberwocky.com>
Subject: Data corruption with linear target on 2.6.21
Date: Thu, 5 Jul 2007 16:42:14 -0400
Message-ID: <20070705204214.GA29158@jabberwocky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Hi everyone,

I have a problem with data corruption using devmapper.  I've done some
work tracking it down, and hopefully you folks can point me further in
the right direction.

The kernel I'm using is 2.6.21-1.3228.fc7 (i.e. Fedora 7).  LVM2 is
lvm2-2.02.24-1.fc7.  The dmsetup and libdevmapper is
device-mapper-1.02.17-7.fc7.

The original setup that showed the problem is this:

Starting with two 500GB SATA drives (interface card uses a Silicon
3124 chipset), /dev/sdd and /dev/sde.  I partitioned each into two
250GB chunks (250*1000*1000*1000, not 250*1024*1024*1024), and set up
two RAID 1 sets such that /dev/md0 is /dev/sdd1+/dev/sde1 and /dev/md2
is /dev/sdd2+/dev/sde2.  I then created a volume group ("storage") on
top of /dev/md0 and /dev/md1.  Finally, I allocated two logical
volumes on top of that: "one" is -L300GB and "two" is -L100GB.

mke2fs -j -m0 on /dev/storage/one and /dev/storage/two, and it would
seem everything was fine, but after copying data to the two volumes,
they would fail a fsck in pretty dramatic fashion (dozens of errors
indicating pretty severe filesystem corruption).

I'll skip all the steps I tried when reducing this down to a simple
reproducible test case, but the end result is this:

1) Take a 500GB disk (as before, it's SATA plugged into a card using
   the sata_sil24 driver)

2) echo "0 482344960 linear 8:32 0" | dmsetup create one
   echo "0 209715200 linear 8:32 482345000" | dmsetup create two

3) mke2fs -j -m0 /dev/mapper/one
   mke2fs -j -m0 /dev/mapper/two
   mount /dev/mapper/one /one
   mount /dev/mapper/two /two

4) cd /one ; \
   for i in `seq 0 3`; do dd if=/dev/zero bs=4K count=1M of=$i; done ; \
   cd ; \
   umount /one

   cd /two ; \
   for i in `seq 0 3`; do dd if=/dev/zero bs=4K count=1M of=$i; done ; \
   cd ; \
   umount /two

5) fsck -f /dev/mapper/one
   fsck -f /dev/mapper/two

Both filesystems return many errors on fsck.  This is very repeatable.

Note that this simplified reproduction case uses only the device
mapper: RAID is not involved, nor is LVM.  "dmsetup table" says:

two: 0 209715200 linear 8:32 482345000
one: 0 482344960 linear 8:32 0

Just to be sure, I have run memtest86+ on the machine and badblocks on
the disk.  Both came up clean.  Partitioning the disk and mke2fs-ing
the partitions directly (i.e. no device-mapper), works fine.  It's
only when using the device-mapper does the corruption happen.  There
is nothing of interest logged in /var/log/messages or dmesg (I see the
usual messages around 'mount', but that's it).

Any suggestions?

David
