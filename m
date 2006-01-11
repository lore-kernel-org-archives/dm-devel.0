From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] device-mapper snaphot: barriers not supported
Date: Wed, 11 Jan 2006 15:04:26 +0000
Message-ID: <20060111150426.GF4474@agk.surrey.redhat.com>
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

The snapshot and origin targets are incapable of handling barriers and 
need to indicate this.

http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-snapshot-barriers-not-supported.patch

Index: linux-2.6.14-rc2/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.14-rc2.orig/drivers/md/dm-snap.c	2006-01-06 14:27:50.000000000 +0000
+++ linux-2.6.14-rc2/drivers/md/dm-snap.c	2006-01-06 14:36:26.000000000 +0000
@@ -799,6 +799,9 @@ static int snapshot_map(struct dm_target
 	if (!s->valid)
 		return -EIO;
 
+	if (unlikely(bio_barrier(bio)))
+		return -EOPNOTSUPP;
+
 	/*
 	 * Write to snapshot - higher level takes care of RW/RO
 	 * flags so we should only get this if we are
@@ -1065,6 +1068,9 @@ static int origin_map(struct dm_target *
 	struct dm_dev *dev = (struct dm_dev *) ti->private;
 	bio->bi_bdev = dev->bdev;
 
+	if (unlikely(bio_barrier(bio)))
+		return -EOPNOTSUPP;
+
 	/* Only tell snapshots if this is a write */
 	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : 1;
 }
