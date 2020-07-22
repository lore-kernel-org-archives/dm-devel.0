From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: revert adc0daad366b to fix
	recalculation
Date: Wed, 22 Jul 2020 14:46:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2007221444390.6426@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Marian Csontos <mcsontos@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Mike

Please submit this to Linus and to RHEL-8.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

The patch adc0daad366b62ca1bce3e2958a40b0b71a8b8b3 broke recalculation on
dm-integrity. The patch replaces a private variable "suspending" with a
call to "dm_suspended".

The problem is that dm_suspended returns true not only during suspend, but
also during resume. This race condition could occur:
1. dm_integrity_resume calls queue_work(ic->recalc_wq, &ic->recalc_work)
2. integrity_recalc (&ic->recalc_work) preempts the current thread
3. integrity_recalc calls if (unlikely(dm_suspended(ic->ti))) goto unlock_ret;
4. integrity_recalc exits and no recalculating is done.

In order to fix this race condition, we stop using dm_suspended and start
using the variable "suspending" (that is only set during suspend, not
during resume).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: adc0daad366b ("dm: report suspended device during destroy")
Cc: stable@vger.kernel.org	# v4.18+

---
 drivers/md/dm-integrity.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-06-29 14:49:59.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2020-07-22 15:48:49.000000000 +0200
@@ -204,13 +204,12 @@ struct dm_integrity_c {
 	__u8 log2_blocks_per_bitmap_bit;
 
 	unsigned char mode;
+	int suspending;
 
 	int failed;
 
 	struct crypto_shash *internal_hash;
 
-	struct dm_target *ti;
-
 	/* these variables are locked with endio_wait.lock */
 	struct rb_root in_progress;
 	struct list_head wait_list;
@@ -2420,7 +2419,7 @@ static void integrity_writer(struct work
 	unsigned prev_free_sectors;
 
 	/* the following test is not needed, but it tests the replay code */
-	if (unlikely(dm_suspended(ic->ti)) && !ic->meta_dev)
+	if (READ_ONCE(ic->suspending) && !ic->meta_dev)
 		return;
 
 	spin_lock_irq(&ic->endio_wait.lock);
@@ -2481,7 +2480,7 @@ static void integrity_recalc(struct work
 
 next_chunk:
 
-	if (unlikely(dm_suspended(ic->ti)))
+	if (unlikely(READ_ONCE(ic->suspending)))
 		goto unlock_ret;
 
 	range.logical_sector = le64_to_cpu(ic->sb->recalc_sector);
@@ -2909,6 +2908,8 @@ static void dm_integrity_postsuspend(str
 
 	del_timer_sync(&ic->autocommit_timer);
 
+	WRITE_ONCE(ic->suspending, 1);
+
 	if (ic->recalc_wq)
 		drain_workqueue(ic->recalc_wq);
 
@@ -2937,6 +2938,8 @@ static void dm_integrity_postsuspend(str
 #endif
 	}
 
+	WRITE_ONCE(ic->suspending, 0);
+
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 
 	ic->journal_uptodate = true;
@@ -3767,7 +3770,6 @@ static int dm_integrity_ctr(struct dm_ta
 	}
 	ti->private = ic;
 	ti->per_io_data_size = sizeof(struct dm_integrity_io);
-	ic->ti = ti;
 
 	ic->in_progress = RB_ROOT;
 	INIT_LIST_HEAD(&ic->wait_list);
