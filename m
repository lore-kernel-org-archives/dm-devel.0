From: Kevin Corry <kevcorry@us.ibm.com>
Subject: [PATCH] Add I/O stats for DM devices
Date: Thu, 8 Sep 2005 15:56:28 -0500
Message-ID: <200509081556.28286.kevcorry@us.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: DevMapper <dm-devel@redhat.com>
List-Id: dm-devel.ids

Got a request to add I/O statistics for DM devices, so they will show up
when running the iostat command, so I wrote up this patch. The code was
taken from the various MD personalities. As such, it only keeps track of
the number of reads/writes and the number of sectors read/written. It
doesn't keep track of any of the time-based measurements. See
struct disk_stats in include/linux/genhd.h for more details.

-- 
Kevin Corry
kevcorry@us.ibm.com
http://www.ibm.com/linux/
http://evms.sourceforge.net/



Add I/O statistics for Device-Mapper devices. Only keeps track of count and
size of I/Os, not completion times. Patch is against 2.6.12.

--- diff/drivers/md/dm.c 2005-08-25 11:29:04.000000000 -0500
+++ source/drivers/md/dm.c 2005-08-25 11:26:49.000000000 -0500
@@ -570,6 +570,14 @@
 
  down_read(&md->lock);
 
+ if (bio_data_dir(bio) == WRITE) {
+  disk_stat_inc(dm_disk(md), writes);
+  disk_stat_add(dm_disk(md), write_sectors, bio_sectors(bio));
+ } else {
+  disk_stat_inc(dm_disk(md), reads);
+  disk_stat_add(dm_disk(md), read_sectors, bio_sectors(bio));
+ }
+
  /*
   * If we're suspended we have to queue
   * this io for later.
