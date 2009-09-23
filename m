From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Snapshot: remove redundant valid test
Date: Wed, 23 Sep 2009 10:19:08 -0500
Message-ID: <200909231519.n8NFJ8K3028667@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-snapshot-remove-redundant-valid-test.patch

There is another valid test when we take the lock, the previous test can
be dropped.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1043,15 +1043,11 @@ static int snapshot_map(struct dm_target
 
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
-	/* Full snapshots are not usable */
-	/* To get here the table must be live so s->active is always set. */
-	if (!s->valid)
-		return -EIO;
-
 	/* FIXME: should only take write lock if we need
 	 * to copy an exception */
 	down_write(&s->lock);
 
+	/* Full snapshots are not usable */
 	if (!s->valid) {
 		r = -EIO;
 		goto out_unlock;
