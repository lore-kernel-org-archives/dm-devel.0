From: NeilBrown <neilb@suse.de>
Subject: [PATCH 11/24] md/raid5: add simple plugging infrastructure.
Date: Tue, 01 Jun 2010 19:56:19 +1000
Message-ID: <20100601095619.565.67150.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

md/raid5 uses the plugging infrastructure provided by the block layer
and 'struct request_queue'.  However when we plug raid5 under dm there
is no request queue so we cannot use that.

So create a similar infrastructure that is much lighter weight and use
it for raid5.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c    |   45 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h    |   20 ++++++++++++++++++++
 drivers/md/raid5.c |   39 +++++++++++++++++++++++++--------------
 drivers/md/raid5.h |    3 +++
 4 files changed, 93 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index da860f7..e44b9c6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -384,6 +384,51 @@ void md_barrier_request(mddev_t *mddev, struct bio *bio)
 }
 EXPORT_SYMBOL(md_barrier_request);
 
+/* Support for plugging.
+ * This mirrors the plugging support in request_queue, but does not
+ * require having a whole queue
+ */
+static void plugger_work(struct work_struct *work)
+{
+	struct plug_handle *plug =
+		container_of(work, struct plug_handle, unplug_work);
+	plug->unplug_fn(plug);
+}
+static void plugger_timeout(unsigned long data)
+{
+	struct plug_handle *plug = (void *)data;
+	kblockd_schedule_work(NULL, &plug->unplug_work);
+}
+void plugger_init(struct plug_handle *plug,
+		  void (*unplug_fn)(struct plug_handle *))
+{
+	plug->unplug_flag = 0;
+	plug->unplug_fn = unplug_fn;
+	init_timer(&plug->unplug_timer);
+	plug->unplug_timer.function = plugger_timeout;
+	plug->unplug_timer.data = (unsigned long)plug;
+	INIT_WORK(&plug->unplug_work, plugger_work);
+}
+EXPORT_SYMBOL_GPL(plugger_init);
+
+void plugger_set_plug(struct plug_handle *plug)
+{
+	if (!test_and_set_bit(PLUGGED_FLAG, &plug->unplug_flag))
+		mod_timer(&plug->unplug_timer, jiffies + msecs_to_jiffies(3)+1);
+}
+EXPORT_SYMBOL_GPL(plugger_set_plug);
+
+int plugger_remove_plug(struct plug_handle *plug)
+{
+	if (test_and_clear_bit(PLUGGED_FLAG, &plug->unplug_flag)) {
+		del_timer(&plug->unplug_timer);
+		return 1;
+	} else
+		return 0;
+}
+EXPORT_SYMBOL_GPL(plugger_remove_plug);
+
+
 static inline mddev_t *mddev_get(mddev_t *mddev)
 {
 	atomic_inc(&mddev->active);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6318175..f210482 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -29,6 +29,26 @@
 typedef struct mddev_s mddev_t;
 typedef struct mdk_rdev_s mdk_rdev_t;
 
+/* generic plugging support - like that provided with request_queue,
+ * but does not require a request_queue
+ */
+struct plug_handle {
+	void			(*unplug_fn)(struct plug_handle *);
+	struct timer_list	unplug_timer;
+	struct work_struct	unplug_work;
+	unsigned long		unplug_flag;
+};
+#define	PLUGGED_FLAG 1
+void plugger_init(struct plug_handle *plug,
+		  void (*unplug_fn)(struct plug_handle *));
+void plugger_set_plug(struct plug_handle *plug);
+int plugger_remove_plug(struct plug_handle *plug);
+static inline void plugger_flush(struct plug_handle *plug)
+{
+	del_timer_sync(&plug->unplug_timer);
+	cancel_work_sync(&plug->unplug_work);
+}
+
 /*
  * MD's 'extended' device
  */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c0746af..6b1802c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -201,11 +201,11 @@ static void __release_stripe(raid5_conf_t *conf, struct stripe_head *sh)
 		if (test_bit(STRIPE_HANDLE, &sh->state)) {
 			if (test_bit(STRIPE_DELAYED, &sh->state)) {
 				list_add_tail(&sh->lru, &conf->delayed_list);
-				blk_plug_device(conf->mddev->queue);
+				plugger_set_plug(&conf->plug);
 			} else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
 				   sh->bm_seq - conf->seq_write > 0) {
 				list_add_tail(&sh->lru, &conf->bitmap_list);
-				blk_plug_device(conf->mddev->queue);
+				plugger_set_plug(&conf->plug);
 			} else {
 				clear_bit(STRIPE_BIT_DELAY, &sh->state);
 				list_add_tail(&sh->lru, &conf->handle_list);
@@ -365,7 +365,7 @@ static struct stripe_head *__find_stripe(raid5_conf_t *conf, sector_t sector,
 }
 
 static void unplug_slaves(mddev_t *mddev);
-static void raid5_unplug_device(struct request_queue *q);
+static void raid5_unplug_device(raid5_conf_t *conf);
 
 static struct stripe_head *
 get_active_stripe(raid5_conf_t *conf, sector_t sector,
@@ -395,7 +395,7 @@ get_active_stripe(raid5_conf_t *conf, sector_t sector,
 						     < (conf->max_nr_stripes *3/4)
 						     || !conf->inactive_blocked),
 						    conf->device_lock,
-						    raid5_unplug_device(conf->mddev->queue)
+						    raid5_unplug_device(conf)
 					);
 				conf->inactive_blocked = 0;
 			} else
@@ -3532,7 +3532,7 @@ static void raid5_activate_delayed(raid5_conf_t *conf)
 			list_add_tail(&sh->lru, &conf->hold_list);
 		}
 	} else
-		blk_plug_device(conf->mddev->queue);
+		plugger_set_plug(&conf->plug);
 }
 
 static void activate_bit_delay(raid5_conf_t *conf)
@@ -3573,23 +3573,33 @@ static void unplug_slaves(mddev_t *mddev)
 	rcu_read_unlock();
 }
 
-static void raid5_unplug_device(struct request_queue *q)
+static void raid5_unplug_device(raid5_conf_t *conf)
 {
-	mddev_t *mddev = q->queuedata;
-	raid5_conf_t *conf = mddev->private;
 	unsigned long flags;
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 
-	if (blk_remove_plug(q)) {
+	if (plugger_remove_plug(&conf->plug)) {
 		conf->seq_flush++;
 		raid5_activate_delayed(conf);
 	}
-	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(conf->mddev->thread);
 
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
-	unplug_slaves(mddev);
+	unplug_slaves(conf->mddev);
+}
+
+static void raid5_unplug(struct plug_handle *plug)
+{
+	raid5_conf_t *conf = container_of(plug, raid5_conf_t, plug);
+	raid5_unplug_device(conf);
+}
+
+static void raid5_unplug_queue(struct request_queue *q)
+{
+	mddev_t *mddev = q->queuedata;
+	raid5_unplug_device(mddev->private);
 }
 
 int md_raid5_congested(mddev_t *mddev, int bits)
@@ -3999,7 +4009,7 @@ static int make_request(mddev_t *mddev, struct bio * bi)
 				 * add failed due to overlap.  Flush everything
 				 * and wait a while
 				 */
-				raid5_unplug_device(mddev->queue);
+				raid5_unplug_device(conf);
 				release_stripe(sh);
 				schedule();
 				goto retry;
@@ -5089,6 +5099,7 @@ static int run(mddev_t *mddev)
 		       mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
+	plugger_init(&conf->plug, raid5_unplug);
 	if (mddev->queue) {
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
@@ -5108,7 +5119,7 @@ static int run(mddev_t *mddev)
 
 	mddev->queue->queue_lock = &conf->device_lock;
 
-	mddev->queue->unplug_fn = raid5_unplug_device;
+	mddev->queue->unplug_fn = raid5_unplug_queue;
 
 	chunk_size = mddev->chunk_sectors << 9;
 	blk_queue_io_min(mddev->queue, chunk_size);
@@ -5140,7 +5151,7 @@ static int stop(mddev_t *mddev)
 	mddev->thread = NULL;
 	if (mddev->queue)
 		mddev->queue->backing_dev_info.congested_fn = NULL;
-	blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+	plugger_flush(&conf->plug); /* the unplug fn references 'conf'*/
 	free_conf(conf);
 	mddev->private = NULL;
 	mddev->to_remove = &raid5_attrs_group;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 936caf8..edf90a8 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -398,6 +398,9 @@ struct raid5_private_data {
 					    * (fresh device added).
 					    * Cleared when a sync completes.
 					    */
+
+	struct plug_handle	plug;
+
 	/* per cpu variables */
 	struct raid5_percpu {
 		struct page	*spare_page; /* Used when checking P/Q in raid6 */


