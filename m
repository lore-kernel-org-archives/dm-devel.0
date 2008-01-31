From: Erich Focht <efocht@hpce.nec.com>
Subject: [PATCH] remove device mapper max_sectors restriction
Date: Thu, 31 Jan 2008 19:09:10 +0100
Message-ID: <200801311909.11752.efocht@hpce.nec.com>
Reply-To: efocht@hpce.nec.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
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
To: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

The maximum size of a bio is restricted by DM to BLK_DEF_MAX_SECTORS
although the I/O size can be increased for each member device above this
value by using the /sys/block/queue/max_sectors interface.

IMHO the limitation when loading the dm table is unnecessary, the values
for sub-devices are checked while set through the sysfs interface and
the restrictions of the sub-devices are combined, the minimal values are
used for the DM queue. Chopping this additionally to BLK_DEF_MAX_SECTORS
makes it impossible to use IOs bigger than 512KB on big RAIDs accessed
through multipath, even if the devices may support them. The trivial patch
removes this limitation. Sub-devices' max_sectors need to be set before
creating the DM device.

Patch is against 2.6.24. For older kernels max_hw_sectors needs to be set
additionally.



Signed-off-by: Erich Focht <efocht@hpce.nec.com>
---
 dm-table.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.24/drivers/md/dm-table.c.orig	2008-01-31 17:06:30.000000000 +0100
+++ linux-2.6.24/drivers/md/dm-table.c	2008-01-31 17:34:03.000000000 +0100
@@ -901,10 +901,10 @@
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
-	 * Make sure we obey the optimistic sub devices
+	 * Make sure we obey the minimum of the sub devices
 	 * restrictions.
 	 */
-	blk_queue_max_sectors(q, t->limits.max_sectors);
+	q->max_sectors = t->limits.max_sectors;
 	q->max_phys_segments = t->limits.max_phys_segments;
 	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
