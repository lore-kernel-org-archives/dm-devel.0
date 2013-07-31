From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Subject: dm-cache with zero hit rate
Date: Wed, 31 Jul 2013 20:50:17 +0200
Message-ID: <20130731185017.GA13215@uio.no>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

I recently set up dm-cache below my main LVM, so that /dev/md2 (a RAID-0 of
two SSDs) has an LVM with /dev/mapper/cache-blocks and
/dev/mapper/cache-metadata, which then back /dev/md1 (a RAID-6 of rotating
disks), where my main LVM, including the root device etc., lies.

After a fair amount of fighting with udev and initramfs-tools, plus upping
the block size to 2048 since 512 complained about not enough RAM (on a 24GB
machine!), this seems to boot up and work, but I seem to get absolutely zero
cache hits.

dmsetup table for the device:

  cache: 0 23440891904 cache 254:0 254:1 9:1 2048 1 writeback default 4 random_threshold 8 sequential_threshold 512

dmsetup status for it:

  cache: 0 23440891904 cache 913/8192 0 170976 0 9614 0 0 0 0 0 2 migration_threshold 2048 4 random_threshold 8 sequential_threshold 512

Note in particular 0/170976 cached reads and 0/9614 cached writes.

Is this normal? Is there any good reason why an LVM on top of a dm-cache
device would not be supported? Or do I just need to wait a few more
hours/weeks/days until it starts being aggressive?

/* Steinar */
-- 
Homepage: http://www.sesse.net/
