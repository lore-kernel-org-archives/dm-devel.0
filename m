From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 4 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 02:49:57 -0500
Message-ID: <a939371b93535e05463c9b921a9e0f22@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
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
To: device-mapper development <dm-devel@redhat.com>
Cc: Kergon Alasdair <agk@redhat.com>
List-Id: dm-devel.ids

This patch adds the components necessary for clustering support.  It 
introduces a new log function - is_remote_recovering().  With this 
function, we can check if other machines are recovering a region, which 
means we can not simultaneously write.  This function displaces the 
former idea of having in_sync() return more that two states - which 
would have changed its predicate nature.

  brassow

diff -urN linux-2.6.12-00003/drivers/md/dm-log.c 
linux-2.6.12-00004/drivers/md/dm-log.c
--- linux-2.6.12-00003/drivers/md/dm-log.c	2005-06-30 
01:44:47.547265107 -0500
+++ linux-2.6.12-00004/drivers/md/dm-log.c	2005-06-30 
01:44:58.277954335 -0500
@@ -545,6 +545,11 @@
  	return log_test_bit(lc->clean_bits, region);
  }

+static int core_is_remote_recovering(struct dirty_log *log, region_t 
region)
+{
+	return 0;
+}
+
  static int core_in_sync(struct dirty_log *log, region_t region, int 
block)
  {
  	struct log_c *lc = (struct log_c *) log->context;
@@ -748,10 +753,12 @@
  static struct dirty_log_type _core_type = {
  	.name = "core",
  	.module = THIS_MODULE,
+	.multi_node = 0,
  	.ctr = core_ctr,
  	.dtr = core_dtr,
  	.get_region_size = core_get_region_size,
  	.is_clean = core_is_clean,
+	.is_remote_recovering = core_is_remote_recovering,
  	.in_sync = core_in_sync,
  	.flush = core_flush,
  	.mark_region = core_mark_region,
@@ -767,12 +774,14 @@
  static struct dirty_log_type _disk_type = {
  	.name = "disk",
  	.module = THIS_MODULE,
+	.multi_node = 0,
  	.ctr = disk_ctr,
  	.dtr = disk_dtr,
  	.suspend = disk_flush,
  	.resume = disk_resume,
  	.get_region_size = core_get_region_size,
  	.is_clean = core_is_clean,
+	.is_remote_recovering = core_is_remote_recovering,
  	.in_sync = core_in_sync,
  	.flush = disk_flush,
  	.mark_region = core_mark_region,
diff -urN linux-2.6.12-00003/drivers/md/dm-log.h 
linux-2.6.12-00004/drivers/md/dm-log.h
--- linux-2.6.12-00003/drivers/md/dm-log.h	2005-06-30 
00:19:01.183294866 -0500
+++ linux-2.6.12-00004/drivers/md/dm-log.h	2005-06-30 
00:21:14.994699410 -0500
@@ -23,6 +23,7 @@
  	const char *name;
  	struct module *module;
  	unsigned int use_count;
+	unsigned int multi_node;

  	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
  		   unsigned int argc, char **argv);
@@ -48,6 +49,16 @@
  	int (*is_clean)(struct dirty_log *log, region_t region);

  	/*
+	 * Returns: 0, 1
+	 *
+	 * This is necessary for cluster mirroring. It provides
+	 * a way to detect recovery on another node, so we
+	 * aren't writing concurrently.  This function is likely
+	 * to block (when a cluster log is used).
+	 */
+	int (*is_remote_recovering)(struct dirty_log *log, region_t region);
+
+	/*
  	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
  	 *
  	 * A predicate function to check the area given by
diff -urN linux-2.6.12-00003/drivers/md/dm-raid1.c 
linux-2.6.12-00004/drivers/md/dm-raid1.c
--- linux-2.6.12-00003/drivers/md/dm-raid1.c	2005-06-30 
01:56:10.058877081 -0500
+++ linux-2.6.12-00004/drivers/md/dm-raid1.c	2005-06-30 
01:56:19.457727576 -0500
@@ -559,6 +559,7 @@
  	struct bio_list writes;
  	struct bio_list failures;
  	struct work_struct failure_work;
+	struct completion failure_completion;

  	/* recovery */
  	atomic_t suspended;
@@ -847,7 +848,7 @@
  				      0) == RH_CLEAN))
  			m = choose_mirror(ms, NULL);
  		else {
-			m = ms->default_mirror;;
+			m = ms->default_mirror;

  			/* If the default fails, we give up .*/
  			if (unlikely(m && atomic_read(&m->error_count)))
@@ -895,6 +896,17 @@
  	}
  	dm_table_event(ms->ti->table);

+	if (log->type->multi_node) {
+		DMERR("Event signaled.  Waiting to start failure handling.");
+		wait_for_completion(&ms->failure_completion);
+		DMINFO("Wait complete");
+	}
+
+	/*
+	 * Device must be suspended to prevent corruption in
+	 * cluster context.
+	 */
+
  	/* Take list out to handle endios. */
  	spin_lock(&ms->lock);
  	failed_writes = ms->failures;
@@ -904,6 +916,10 @@
  	while ((bio = bio_list_pop(&failed_writes))) {
  		bio_endio(bio, bio->bi_size, 0);
  	}
+
+	if (log->type->multi_node) {
+		DMERR("Failure handling complete.");
+	}
  }

  static void write_callback(unsigned long error, void *context)
@@ -976,9 +992,11 @@
  	unsigned int i;
  	struct io_region io[ms->nr_mirrors], *dest = io;
  	struct mirror *m;
+	struct dirty_log *log = ms->rh.log;

  	for (i = 0, m = ms->mirror; i < ms->nr_mirrors; i++, m++) {
-		if (likely(!atomic_read(&m->error_count)))
+		if (likely(!atomic_read(&m->error_count)) ||
+		    log->type->multi_node)
  			map_region(dest++, m, bio);
  	}

@@ -1001,6 +1019,9 @@
  	int state;
  	struct bio *bio;
  	struct bio_list sync, nosync, recover, *this_list = NULL;
+	struct bio_list tmp;
+	struct dirty_log *log = ms->rh.log;
+	region_t region;

  	if (!writes->head)
  		return;
@@ -1011,9 +1032,17 @@
  	bio_list_init(&sync);
  	bio_list_init(&nosync);
  	bio_list_init(&recover);
+	bio_list_init(&tmp);

  	while ((bio = bio_list_pop(writes))) {
-		state = rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1);
+		region = bio_to_region(&ms->rh, bio);
+
+		if(log->type->is_remote_recovering(log, region)){
+			bio_list_add(&tmp, bio);
+			continue;
+		}
+						
+		state = rh_state(&ms->rh, region, 1);
  		switch (state) {
  		case RH_CLEAN:
  		case RH_DIRTY:
@@ -1031,6 +1060,7 @@

  		bio_list_add(this_list, bio);
  	}
+	bio_list_merge(writes, &tmp);

  	/*
  	 * Increment the pending counts for any regions that will
@@ -1133,7 +1163,9 @@

  	bio_list_init(&ms->failures);
  	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
-	
+
+	init_completion(&ms->failure_completion);
+
  	return ms;
  }

@@ -1456,6 +1488,7 @@
  	struct mirror_set *ms = (struct mirror_set *)ti->private;

  	atomic_set(&ms->suspended, 1);
+	complete(&ms->failure_completion);
  }
