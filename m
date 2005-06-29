From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 6 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:32:41 -0500
Message-ID: <a0771bfd8ae0f3061e75950e1b6fc413@redhat.com>
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

This patch adds the necessary components to do cluster mirroring 
properly, _if_ the log type supports it.

  brassow

diff -urN linux-2.6.12-006/drivers/md/dm-log.c 
linux-2.6.12-007/drivers/md/dm-log.c
--- linux-2.6.12-006/drivers/md/dm-log.c	2005-06-29 09:54:33.001960796 
-0500
+++ linux-2.6.12-007/drivers/md/dm-log.c	2005-06-29 11:57:48.224957146 
-0500
@@ -705,6 +705,7 @@
  static struct dirty_log_type _core_type = {
  	.name = "core",
  	.module = THIS_MODULE,
+	.multi_node = 0,
  	.ctr = core_ctr,
  	.dtr = core_dtr,
  	.get_region_size = core_get_region_size,
@@ -722,6 +723,7 @@
  static struct dirty_log_type _disk_type = {
  	.name = "disk",
  	.module = THIS_MODULE,
+	.multi_node = 0,
  	.ctr = disk_ctr,
  	.dtr = disk_dtr,
  	.suspend = disk_flush,
diff -urN linux-2.6.12-006/drivers/md/dm-log.h 
linux-2.6.12-007/drivers/md/dm-log.h
--- linux-2.6.12-006/drivers/md/dm-log.h	2005-06-29 09:54:24.957955783 
-0500
+++ linux-2.6.12-007/drivers/md/dm-log.h	2005-06-29 11:58:43.001589620 
-0500
@@ -29,6 +29,7 @@
  	const char *name;
  	struct module *module;
  	unsigned int use_count;
+	unsigned int multi_node;

  	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
  		   unsigned int argc, char **argv);
diff -urN linux-2.6.12-006/drivers/md/dm-raid1.c 
linux-2.6.12-007/drivers/md/dm-raid1.c
--- linux-2.6.12-006/drivers/md/dm-raid1.c	2005-06-29 
11:44:57.552713175 -0500
+++ linux-2.6.12-007/drivers/md/dm-raid1.c	2005-06-29 
12:08:09.838784593 -0500
@@ -573,6 +573,7 @@
  	struct bio_list writes;
  	struct bio_list failures;
  	struct work_struct failure_work;
+	struct completion failure_completion;

  	/* recovery */
  	atomic_t suspended;
@@ -861,7 +862,7 @@
  				      0) == RH_CLEAN))
  			m = choose_mirror(ms, NULL);
  		else {
-			m = ms->default_mirror;;
+			m = ms->default_mirror;

  			/* If the default fails, we give up .*/
  			if (unlikely(m && atomic_read(&m->error_count)))
@@ -890,9 +891,21 @@
  	struct bio *bio;
  	struct bio_list failed_writes;
  	struct mirror_set *ms = (struct mirror_set *)data;
+	struct dirty_log *log = ms->rh.log;

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
@@ -902,6 +915,10 @@
  	while ((bio = bio_list_pop(&failed_writes))) {
  		bio_endio(bio, bio->bi_size, 0);
  	}
+
+	if (log->type->multi_node) {
+		DMERR("Failure handling complete.");
+	}
  }

  static void write_callback(unsigned long error, void *context)
@@ -966,7 +983,7 @@
  		}
  	}

-	bio_endio(bio, bio->bi_size, 0);
+	bio_endio(bio, bio->bi_size, ret);
  }

  static void do_write(struct mirror_set *ms, struct bio *bio)
@@ -974,9 +991,11 @@
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

@@ -999,6 +1018,7 @@
  	int state;
  	struct bio *bio;
  	struct bio_list sync, nosync, recover, *this_list = NULL;
+	struct bio_list tmp;

  	if (!writes->head)
  		return;
@@ -1009,6 +1029,7 @@
  	bio_list_init(&sync);
  	bio_list_init(&nosync);
  	bio_list_init(&recover);
+	bio_list_init(&tmp);

  	while ((bio = bio_list_pop(writes))) {
  		state = rh_state(&ms->rh, bio_to_region(&ms->rh, bio), 1);
@@ -1025,10 +1046,15 @@
  		case RH_RECOVERING:
  			this_list = &recover;
  			break;
+
+		case RH_REMOTE_RECOVERING:
+			this_list = &tmp;
+			break;
  		}

  		bio_list_add(this_list, bio);
  	}
+	bio_list_merge(writes, &tmp);

  	/*
  	 * Increment the pending counts for any regions that will
@@ -1132,6 +1158,8 @@
  	bio_list_init(&ms->failures);
  	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
  	
+	init_completion(&ms->failure_completion);
+
  	return ms;
  }

@@ -1451,6 +1479,7 @@
  	struct mirror_set *ms = (struct mirror_set *)ti->private;

  	atomic_set(&ms->suspended, 1);
+	complete(&ms->failure_completion);
  }
