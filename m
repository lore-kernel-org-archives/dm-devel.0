From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Implement merge method for snapshot origin
Date: Tue, 4 May 2010 23:34:00 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1005042327320.16138@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, Daire Byrne <daire.byrne@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This improves performance when reading the snapshot origin.

Note: in my testing, it actually degraded performance in some settings, I 
traced it to Maxtor disks having problems with > 512-sector requests. 
Reducing the number of sectors to /sys/block/sd*/queue/max_sectors_kb to 
256 fixed the read performance. I think we don't have to care about weird 
disks that actually degrade performance because of large requests being 
sent to them.

Mikulas

---

Implement merge method for snapshot origin

Without merge method, dm asks the upper layers to submit smallest possible
bios --- one page. Submitting such small bios impacts performance negatively
when reading or writing the origin device.

Without this patch, CPU consumption when reading the origin on lvm on md-raid0
was 6 to 12%, with this patch, it drops to 1 to 4%.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.34-rc5-fast/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.34-rc5-fast.orig/drivers/md/dm-snap.c	2010-04-29 15:34:59.000000000 +0200
+++ linux-2.6.34-rc5-fast/drivers/md/dm-snap.c	2010-04-29 15:37:11.000000000 +0200
@@ -2171,6 +2171,21 @@
 	return 0;
 }
 
+static int origin_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct dm_dev *dev = ti->private;
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = dev->bdev;
+	bvm->bi_sector = bvm->bi_sector;
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
 static int origin_iterate_devices(struct dm_target *ti,
 				  iterate_devices_callout_fn fn, void *data)
 {
@@ -2188,6 +2203,7 @@
 	.map     = origin_map,
 	.resume  = origin_resume,
 	.status  = origin_status,
+	.merge	 = origin_merge,
 	.iterate_devices = origin_iterate_devices,
 };
 
