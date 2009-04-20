From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 14/17] bottom-layer barrier support
Date: Mon, 20 Apr 2009 04:02:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904200402010.6097@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904200357240.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358000.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200358300.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200359520.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400160.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200400500.6097@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904200401280.6097@hs20-bc2-1.build.redhat.com>
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

dm-snapshot-flush.patch

Flush support for dm-snapshot target.

This patch just forwars the flush request to origin and snapshot device,
it doesn't flush exception store metadata.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux-2.6.30-rc1-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.30-rc1-devel.orig/drivers/md/dm-snap.c	2009-04-10 06:24:53.000000000 +0200
+++ linux-2.6.30-rc1-devel/drivers/md/dm-snap.c	2009-04-10 06:33:48.000000000 +0200
@@ -678,6 +678,7 @@ static int snapshot_ctr(struct dm_target
 
 	ti->private = s;
 	ti->split_io = s->store->chunk_size;
+	ti->num_flush_requests = 1;
 
 	return 0;
 
@@ -1030,6 +1031,11 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
+	if (unlikely(bio_empty_barrier(bio))) {
+		bio->bi_bdev = s->store->cow->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	/* Full snapshots are not usable */
@@ -1338,6 +1344,8 @@ static int origin_ctr(struct dm_target *
 	}
 
 	ti->private = dev;
+	ti->num_flush_requests = 1;
+
 	return 0;
 }
 
@@ -1353,6 +1361,9 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = ti->private;
 	bio->bi_bdev = dev->bdev;
 
+	if (unlikely(bio_empty_barrier(bio)))
+		return DM_MAPIO_REMAPPED;
+
 	/* Only tell snapshots if this is a write */
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
 }
