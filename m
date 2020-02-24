From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/7] dm: report suspended device during destroy
Date: Mon, 24 Feb 2020 10:20:28 +0100
Message-ID: <20200224092046.953935440@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-suspended-on-unload.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

The function dm_suspended returns true if the target is suspended.
However, when the target is being suspended during unload, it returns
false.

This patch makes dm_suspended return true after the presuspend hook before
the presuspend hook - just like during a normal suspend. It allows
simplifying the dm-integrity and dm-writecache targets so that they don't
have to maintain suspended flags on their own.

I tested it with the lvm2 testsuite and cryptsetup testsuite and the are
no regressions.

This patch should be backported to the stable kernels because the
following patch ("dm-writecache: fix a crash when unloading") depends on
it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |   12 +++++-------
 drivers/md/dm.c           |    1 +
 2 files changed, 6 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2020-02-21 13:23:08.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2020-02-21 13:23:08.000000000 +0100
@@ -2368,6 +2368,7 @@ static void __dm_destroy(struct mapped_d
 	map = dm_get_live_table(md, &srcu_idx);
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
+		set_bit(DMF_SUSPENDED, &md->flags);
 		dm_table_postsuspend_targets(map);
 	}
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-02-21 13:23:08.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-02-21 13:35:41.000000000 +0100
@@ -201,12 +201,13 @@ struct dm_integrity_c {
 	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
-	int suspending;
 
 	int failed;
 
 	struct crypto_shash *internal_hash;
 
+	struct dm_target *ti;
+
 	/* these variables are locked with endio_wait.lock */
 	struct rb_root in_progress;
 	struct list_head wait_list;
@@ -2320,7 +2321,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (READ_ONCE(ic->suspending) && !ic->meta_dev)
+	if (unlikely(dm_suspended(ic->ti)) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2381,7 +2382,7 @@ static void integrity_recalc(struct work
 
 next_chunk:
 
-	if (unlikely(READ_ONCE(ic->suspending)))
+	if (unlikely(dm_suspended(ic->ti)))
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
@@ -2809,8 +2810,6 @@ static void dm_integrity_postsuspend(str
 
 	del_timer_sync(&ic->autocommit_timer);
 
-	WRITE_ONCE(ic->suspending, 1);
-
 	if (ic->recalc_wq)
 		drain_workqueue(ic->recalc_wq);
 
@@ -2839,8 +2838,6 @@ static void dm_integrity_postsuspend(str
 #endif
 	}
 
-	WRITE_ONCE(ic->suspending, 0);
-
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 
 	ic->journal_uptodate = true;
@@ -3651,6 +3648,7 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 	ti->private = ic;
 	ti->per_io_data_size = sizeof(struct dm_integrity_io);
+	ic->ti = ti;
 
 	ic->in_progress = RB_ROOT;
 	INIT_LIST_HEAD(&ic->wait_list);
