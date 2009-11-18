From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/7] A framework for holding bios until suspend
Date: Wed, 18 Nov 2009 07:11:05 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0911180710370.21358@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0911180703410.21358@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0911180709570.21358@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

A framework for holding bios until suspend and then resubmitting them
with either DM_ENDIO_REQUEUE (if the suspend was noflush) or terminating
them with -EIO.

The bio can be held with the function hold_bio. So far it is unused,
it will be used in later patches.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux-2.6.31-fast-new/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.31-fast-new.orig/drivers/md/dm-raid1.c	2009-10-06 18:15:10.000000000 +0200
+++ linux-2.6.31-fast-new/drivers/md/dm-raid1.c	2009-10-06 18:15:14.000000000 +0200
@@ -57,6 +57,7 @@ struct mirror_set {
 	struct bio_list reads;
 	struct bio_list writes;
 	struct bio_list failures;
+	struct bio_list hold;	/* bios are waiting until suspend */
 
 	struct dm_region_hash *rh;
 	struct dm_kcopyd_client *kcopyd_client;
@@ -415,6 +416,20 @@ static void map_region(struct dm_io_regi
 	io->count = bio->bi_size >> 9;
 }
 
+static void hold_bio(struct mirror_set *ms, struct bio *bio)
+{
+	if (atomic_read(&ms->suspend)) {
+		if (dm_noflush_suspending(ms->ti))
+			bio_endio(bio, DM_ENDIO_REQUEUE);
+		else
+			bio_endio(bio, -EIO);
+	} else {
+		spin_lock_irq(&ms->lock);
+		bio_list_add(&ms->hold, bio);
+		spin_unlock_irq(&ms->lock);
+	}
+}
+
 /*-----------------------------------------------------------------
  * Reads
  *---------------------------------------------------------------*/
@@ -760,6 +775,7 @@ static void do_mirror(struct work_struct
 	bio_list_init(&ms->reads);
 	bio_list_init(&ms->writes);
 	bio_list_init(&ms->failures);
+	bio_list_init(&ms->hold);
 	spin_unlock_irqrestore(&ms->lock, flags);
 
 	dm_rh_update_states(ms->rh, errors_handled(ms));
@@ -1192,6 +1208,9 @@ static void mirror_presuspend(struct dm_
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
+	struct bio_list hold;
+	struct bio *bio;
+
 	atomic_set(&ms->suspend, 1);
 
 	/*
@@ -1214,6 +1233,23 @@ static void mirror_presuspend(struct dm_
 	 * we know that all of our I/O has been pushed.
 	 */
 	flush_workqueue(ms->kmirrord_wq);
+
+	/*
+	 * Once we set ms->suspend and flush the workqueue,
+	 * no more entries are being added to ms->hold list.
+	 * Process the list now.
+	 *
+	 * (note that bios can still arive concurrently with
+	 * or after presuspend, but they are never put to
+	 * hold list because of ms->suspend != 0).
+	 */
+	spin_lock_irq(&ms->lock);
+	hold = ms->hold;
+	bio_list_init(&ms->hold);
+	spin_unlock_irq(&ms->lock);
+
+	while ((bio = bio_list_pop(&hold)))
+		hold_bio(ms, bio);
 }
 
 static void mirror_postsuspend(struct dm_target *ti)
