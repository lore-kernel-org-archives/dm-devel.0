From: Hirokazu Takahashi <taka@valinux.co.jp>
Subject: [RFC][PATCH 7/10] I/O context inheritance
Date: Tue, 22 Apr 2008 22:57:17 +0900 (JST)
Message-ID: <20080422.225717.102033295.taka@valinux.co.jp>
References: <20080422.224935.00673711.taka@valinux.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080422.224935.00673711.taka@valinux.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids


The raid5 module makes use of temporary bios to issue several I/O requests
in the same stripe, whenever it gets a write I/O request. In this case,
the temporary bios should inherit the iocontext from the source bio.

And the module also makes use of temporary bios to sync physical disks
under the same md device. In this case, these bios point the iocontext of
one of the kernel threads in the module.

Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>


--- linux-2.6.25.bio0/include/linux/raid/raid5.h	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/include/linux/raid/raid5.h	2008-04-22 15:53:09.000000000 +0900
@@ -169,6 +169,7 @@ struct stripe_head {
 	spinlock_t		lock;
 	int			bm_seq;	/* sequence number for bitmap flushes */
 	int			disks;			/* disks in stripe */
+	struct io_context	*io_context;
 	/* stripe_operations
 	 * @pending - pending ops flags (set for request->issue->complete)
 	 * @ack - submitted ops flags (set for issue->complete)
--- linux-2.6.25.bio0/drivers/md/raid5.c	2008-04-22 15:48:32.000000000 +0900
+++ linux-2.6.25/drivers/md/raid5.c	2008-04-22 18:51:13.000000000 +0900
@@ -148,6 +148,8 @@ static void __release_stripe(raid5_conf_
 			}
 			atomic_dec(&conf->active_stripes);
 			if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
+				put_io_context(sh->io_context);
+				sh->io_context = NULL;
 				list_add_tail(&sh->lru, &conf->inactive_list);
 				wake_up(&conf->wait_for_stripe);
 				if (conf->retry_read_aligned)
@@ -235,7 +237,7 @@ static int grow_buffers(struct stripe_he
 
 static void raid5_build_block (struct stripe_head *sh, int i);
 
-static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks)
+static void init_stripe(struct stripe_head *sh, sector_t sector, int pd_idx, int disks, struct bio *bi)
 {
 	raid5_conf_t *conf = sh->raid_conf;
 	int i;
@@ -253,6 +255,10 @@ static void init_stripe(struct stripe_he
 	sh->sector = sector;
 	sh->pd_idx = pd_idx;
 	sh->state = 0;
+	if (bi)
+		sh->io_context = ioc_object_link(bi->bi_io_context);
+	else
+		sh->io_context = ioc_object_link(current->io_context);
 
 	sh->disks = disks;
 
@@ -291,7 +297,7 @@ static void unplug_slaves(mddev_t *mddev
 static void raid5_unplug_device(struct request_queue *q);
 
 static struct stripe_head *get_active_stripe(raid5_conf_t *conf, sector_t sector, int disks,
-					     int pd_idx, int noblock)
+				     int pd_idx, int noblock, struct bio *bi)
 {
 	struct stripe_head *sh;
 
@@ -321,7 +327,7 @@ static struct stripe_head *get_active_st
 					);
 				conf->inactive_blocked = 0;
 			} else
-				init_stripe(sh, sector, pd_idx, disks);
+				init_stripe(sh, sector, pd_idx, disks, bi);
 		} else {
 			if (atomic_read(&sh->count)) {
 			  BUG_ON(!list_empty(&sh->lru));
@@ -412,10 +418,19 @@ static void ops_run_io(struct stripe_hea
 		bi = &sh->dev[i].req;
 
 		bi->bi_rw = rw;
-		if (rw == WRITE)
+		if (rw == WRITE) {
 			bi->bi_end_io = raid5_end_write_request;
-		else
+			if (sh->dev[i].towrite) {
+				bi->bi_io_context = sh->dev[i].towrite->bi_io_context;
+			}
+		} else {
 			bi->bi_end_io = raid5_end_read_request;
+			if (sh->dev[i].toread) {
+				bi->bi_io_context = sh->dev[i].toread->bi_io_context;
+			}
+		}
+		if (!bi->bi_io_context)
+			bi->bi_io_context = sh->io_context;
 
 		rcu_read_lock();
 		rdev = rcu_dereference(conf->disks[i].rdev);
@@ -2551,7 +2566,7 @@ static void handle_stripe_expansion(raid
 						conf->max_degraded, &dd_idx,
 						&pd_idx, conf);
 			sh2 = get_active_stripe(conf, s, conf->raid_disks,
-						pd_idx, 1);
+						pd_idx, 1, NULL);
 			if (sh2 == NULL)
 				/* so far only the early blocks of this stripe
 				 * have been requested.  When later blocks
@@ -3512,7 +3527,7 @@ static int make_request(struct request_q
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK));
+		sh = get_active_stripe(conf, new_sector, disks, pd_idx, (bi->bi_rw&RWA_MASK), bi);
 		if (sh) {
 			if (unlikely(conf->expand_progress != MaxSector)) {
 				/* expansion might have moved on while waiting for a
@@ -3650,7 +3665,7 @@ static sector_t reshape_request(mddev_t 
 		int skipped = 0;
 		pd_idx = stripe_to_pdidx(sector_nr+i, conf, conf->raid_disks);
 		sh = get_active_stripe(conf, sector_nr+i,
-				       conf->raid_disks, pd_idx, 0);
+				       conf->raid_disks, pd_idx, 0, NULL);
 		set_bit(STRIPE_EXPANDING, &sh->state);
 		atomic_inc(&conf->reshape_stripes);
 		/* If any of this stripe is beyond the end of the old
@@ -3701,7 +3716,7 @@ static sector_t reshape_request(mddev_t 
 		pd_idx = stripe_to_pdidx(first_sector, conf,
 					 conf->previous_raid_disks);
 		sh = get_active_stripe(conf, first_sector,
-				       conf->previous_raid_disks, pd_idx, 0);
+			       conf->previous_raid_disks, pd_idx, 0, NULL);
 		set_bit(STRIPE_EXPAND_SOURCE, &sh->state);
 		set_bit(STRIPE_HANDLE, &sh->state);
 		release_stripe(sh);
@@ -3791,9 +3806,9 @@ static inline sector_t sync_request(mdde
 	bitmap_cond_end_sync(mddev->bitmap, sector_nr);
 
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
-	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1);
+	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1, NULL);
 	if (sh == NULL) {
-		sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 0);
+		sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 0, NULL);
 		/* make sure we don't swamp the stripe cache if someone else
 		 * is trying to get access
 		 */
@@ -3857,7 +3872,7 @@ static int  retry_aligned_read(raid5_con
 			/* already done this stripe */
 			continue;
 
-		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1);
+		sh = get_active_stripe(conf, sector, conf->raid_disks, pd_idx, 1, raid_bio);
 
 		if (!sh) {
 			/* failed to get a stripe - must wait */
