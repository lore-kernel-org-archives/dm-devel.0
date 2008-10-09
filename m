From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: Re: [PATCH] Fix Null pointer Exception
Date: Thu, 9 Oct 2008 16:17:49 +0100
Message-ID: <20081009151749.GO23898@agk.fab.redhat.com>
References: <48C5478B.2040401@linux.vnet.ibm.com>
	<20080908172153.05268f6d.akpm@linux-foundation.org>
	<20080923165628.GI5288@agk.fab.redhat.com>
	<48DA3DF1.6060403@linux.vnet.ibm.com>
	<20081007211840.GC23898@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20081007211840.GC23898@agk.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: raspl@linux.vnet.ibm.com, device-mapper development <dm-devel@redhat.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, heiko.carstens@de.ibm.coms
List-Id: dm-devel.ids

On Tue, Oct 07, 2008 at 10:18:40PM +0100, Alasdair G Kergon wrote:
> Meanwhile I will not be applying that patch, though I may take a patch
> to provide clean diagnostics should a situation like this occur again.
 
I'm thinking of something like this:


From: Alasdair G Kergon <agk@redhat.com>

Detect and report buggy drivers that destroy their request_queue.

Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Stefan Raspl <raspl@linux.vnet.ibm.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

---
 drivers/md/dm-table.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

Index: linux-2.6.27-rc8/drivers/md/dm-table.c
===================================================================
--- linux-2.6.27-rc8.orig/drivers/md/dm-table.c	2008-10-09 14:53:35.000000000 +0100
+++ linux-2.6.27-rc8/drivers/md/dm-table.c	2008-10-09 14:56:26.000000000 +0100
@@ -478,6 +478,13 @@ void dm_set_device_limits(struct dm_targ
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct io_restrictions *rs = &ti->limits;
+	char b[BDEVNAME_SIZE];
+
+	if (unlikely(!q)) {
+		DMWARN("%s: Cannot set limits for nonexistent device %s",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		return;
+	}
 
 	/*
 	 * Combine the device limits low.
@@ -943,7 +950,14 @@ int dm_table_any_congested(struct dm_tab
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
-		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+		char b[BDEVNAME_SIZE];
+
+		if (likely(q))
+			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
+		else
+			DMWARN_LIMIT("%s: any_congested: nonexistent device %s",
+				     dm_device_name(t->md),
+				     bdevname(dd->bdev, b));
 	}
 
 	return r;
@@ -956,8 +970,14 @@ void dm_table_unplug_all(struct dm_table
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
+		char b[BDEVNAME_SIZE];
 
-		blk_unplug(q);
+		if (likely(q))
+			blk_unplug(q);
+		else
+			DMWARN_LIMIT("%s: Cannot unplug nonexistent device %s",
+				     dm_device_name(t->md),
+				     bdevname(dd->bdev, b));
 	}
 }
 
