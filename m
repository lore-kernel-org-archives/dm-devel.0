From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] Support discard if at least one underlying
 device supports it
Date: Fri, 2 Jul 2010 11:19:53 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007021119070.7296@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Support discard if at least one underlying device supports it

The previous code was too restrictive. It required that every underlying
device supports discard to advertise discard support.

If one of the underlying devices doesn't support discard and other does,
it makes still sense to advertise discard support and forward discards only
to the device that supports them.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6.35-rc3-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.35-rc3-fast.orig/drivers/md/dm-table.c	2010-07-02 16:06:14.000000000 +0200
+++ linux-2.6.35-rc3-fast/drivers/md/dm-table.c	2010-07-02 16:07:32.000000000 +0200
@@ -1243,12 +1243,12 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
-static int device_discard_incapable(struct dm_target *ti, struct dm_dev *dev,
-				    sector_t start, sector_t len, void *data)
+static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
-	return !q || !blk_queue_discard(q);
+	return q && blk_queue_discard(q);
 }
 
 bool dm_table_supports_discards(struct dm_table *t)
@@ -1260,7 +1260,7 @@ bool dm_table_supports_discards(struct d
 		return 0;
 
 	/*
-	 * Ensure underlying devices support discards.
+	 * Ensure that at least one underlying device supports discards.
 	 * t->devices includes internal dm devices such as mirror logs
 	 * so we need to use iterate_devices here, which targets
 	 * supporting discard must provide.
@@ -1268,12 +1268,12 @@ bool dm_table_supports_discards(struct d
 	while (i < dm_table_get_num_targets(t)) {
 		ti = dm_table_get_target(t, i++);
 
-		if (!ti->type->iterate_devices ||
-		    ti->type->iterate_devices(ti, device_discard_incapable, NULL))
-			return 0;
+		if (ti->type->iterate_devices &&
+		    ti->type->iterate_devices(ti, device_discard_capable, NULL))
+			return 1;
 	}
 
-	return 1;
+	return 0;
 }
 
 EXPORT_SYMBOL(dm_vcalloc);
