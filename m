From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 4 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:25:59 -0500
Message-ID: <63489c95183742b85c025a9aca71a3d5@redhat.com>
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

This patch adds detection of device failure for writes.  It also 
contains the read balancing code as a byproduct.

  brassow

diff -urN linux-2.6.12-004/drivers/md/dm-raid1.c 
linux-2.6.12-005/drivers/md/dm-raid1.c
--- linux-2.6.12-004/drivers/md/dm-raid1.c	2005-06-28 
16:46:37.000000000 -0500
+++ linux-2.6.12-005/drivers/md/dm-raid1.c	2005-06-29 
10:48:36.137827465 -0500
@@ -28,6 +28,8 @@
  	queue_work(_kmirrord_wq, &_kmirrord_work);
  }

+static struct workqueue_struct *_mir_mond_wq;
+
  /*-----------------------------------------------------------------
   * Region hash
   *
@@ -553,7 +555,8 @@
   * Mirror set structures.
   *---------------------------------------------------------------*/
  struct mirror {
-	atomic_t error_count;
+	atomic_t error_count;  /* Error counter to flag mirror failure */
+	struct mirror_set *ms;
  	struct dm_dev *dev;
  	sector_t offset;
  };
@@ -564,16 +567,23 @@
  	struct region_hash rh;
  	struct kcopyd_client *kcopyd_client;

-	spinlock_t lock;	/* protects the next two lists */
+	spinlock_t lock;	/* protects the lists */
  	struct bio_list reads;
  	struct bio_list writes;
+	struct bio_list failures;
+	struct work_struct failure_work;

  	/* recovery */
+	atomic_t suspended;
  	region_t nr_regions;
  	int in_sync;

  	unsigned int nr_mirrors;
-	struct mirror mirror[0];
+	spinlock_t choose_lock; /* protects select in choose_mirror(). */
+	atomic_t read_count;    /* Read counter for read balancing. */
+	unsigned int read_mirror;       /* Last mirror read. */
+	struct mirror *default_mirror;  /* Default mirror. */
+ 	struct mirror mirror[0];
  };

  /*
@@ -621,7 +631,7 @@
  	unsigned long flags = 0;

  	/* fill in the source */
-	m = ms->mirror + DEFAULT_MIRROR;
+	m = ms->default_mirror;
  	from.bdev = m->dev->bdev;
  	from.sector = m->offset + region_to_sector(reg->rh, reg->key);
  	if (reg->key == (ms->nr_regions - 1)) {
@@ -637,7 +647,7 @@

  	/* fill in the destinations */
  	for (i = 0, dest = to; i < ms->nr_mirrors; i++) {
-		if (i == DEFAULT_MIRROR)
+		if (&ms->mirror[i] == ms->default_mirror)
  			continue;

  		m = ms->mirror + i;
@@ -687,12 +697,74 @@
  }

  /*-----------------------------------------------------------------
- * Reads
+ * Misc Functions
   *---------------------------------------------------------------*/
-static struct mirror *choose_mirror(struct mirror_set *ms, sector_t 
sector)
+#define MIN_READS       128
+/*
+ * choose_mirror
+ * @ms: the mirror set
+ * @m: mirror that has failed, or NULL if just choosing
+ *
+ * Returns: chosen mirror, or NULL on failure
+ */
+static struct mirror *choose_mirror(struct mirror_set *ms, struct 
mirror *m)
+{
+	int i, retry;
+	unsigned long flags;
+	struct mirror *ret = NULL;
+
+	spin_lock_irqsave(&ms->choose_lock, flags);
+
+	if (unlikely(m == ms->default_mirror)) {
+		i = DEFAULT_MIRROR;
+		atomic_set(&ms->read_count, MIN_READS);
+	} else {
+		i = ms->read_mirror;
+	}
+
+	for (retry = 0; retry < ms->nr_mirrors; ) {
+		i %= ms->nr_mirrors;
+		ret = ms->mirror + i;
+
+		if (unlikely(atomic_read(&ret->error_count))) {
+			retry++;
+			i++;
+		} else {
+			/*
+			 * Guarantee that a number of read IOs
+			 * get queued to the same mirror.
+			 */
+			if (atomic_dec_and_test(&ms->read_count)) {
+				atomic_set(&ms->read_count, MIN_READS);
+				i++;
+			}
+
+			ms->read_mirror = i;
+			break;
+		}
+	}
+
+	/* Check for failure of default mirror, reset if necessary */
+	if (unlikely(m == ms->default_mirror)) {
+		ms->default_mirror = ret;
+	}
+
+	spin_unlock_irqrestore(&ms->choose_lock, flags);
+
+	if (unlikely(atomic_read(&ret->error_count))) {
+		DMERR("All mirror devices are dead. Unable to choose mirror.");
+		return NULL;
+	}
+
+	return ret;
+}
+
+static void fail_mirror(struct mirror *m)
  {
-	/* FIXME: add read balancing */
-	return ms->mirror + DEFAULT_MIRROR;
+	DMINFO("incrementing error_count on %s", m->dev->name);
+	atomic_inc(&m->error_count);
+
+	choose_mirror(m->ms, m);
  }

  /*
@@ -704,6 +776,9 @@
  	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
  }

+/*-----------------------------------------------------------------
+ * Reads
+ *---------------------------------------------------------------*/
  static void do_reads(struct mirror_set *ms, struct bio_list *reads)
  {
  	region_t region;
@@ -717,9 +792,9 @@
  		 * We can only read balance if the region is in sync.
  		 */
  		if (rh_in_sync(&ms->rh, region, 0) == RH_CLEAN)
-			m = choose_mirror(ms, bio->bi_sector);
+			m = choose_mirror(ms, NULL);
  		else
-			m = ms->mirror + DEFAULT_MIRROR;
+			m = ms->default_mirror;;

  		map_bio(ms, m, bio);
  		generic_make_request(bio);
@@ -736,35 +811,87 @@
   * RECOVERING:	delay the io until recovery completes
   * NOSYNC:	increment pending, just write to the default mirror
   *---------------------------------------------------------------*/
+static void write_failure_handler(void *data)
+{
+	struct bio *bio;
+	struct bio_list failed_writes;
+	struct mirror_set *ms = (struct mirror_set *)data;
+
+	dm_table_event(ms->ti->table);
+
+	/* Take list out to handle endios. */
+	spin_lock(&ms->lock);
+	failed_writes = ms->failures;
+	bio_list_init(&ms->failures);
+	spin_unlock(&ms->lock);
+
+	while ((bio = bio_list_pop(&failed_writes))) {
+		bio_endio(bio, bio->bi_size, 0);
+	}
+}
+
  static void write_callback(unsigned long error, void *context)
  {
-	unsigned int i;
-	int uptodate = 1;
+	unsigned int i, ret = 0;
  	struct bio *bio = (struct bio *) context;
  	struct mirror_set *ms;
-
+
  	ms = bio_get_ms(bio);
  	bio_set_ms(bio, NULL);
-
+
  	/*
  	 * NOTE: We don't decrement the pending count here,
  	 * instead it is done by the targets endio function.
  	 * This way we handle both writes to SYNC and NOSYNC
  	 * regions with the same code.
  	 */
+	if (unlikely(error)) {
+		int uptodate = 0, run;
+
+		DMERR("Error during write occurred.");

-	if (error) {
  		/*
-		 * only error the io if all mirrors failed.
-		 * FIXME: bogus
+		 * Test all bits - if all failed, fail io.
+		 * Otherwise, go through hassle of failing a device...
  		 */
-		uptodate = 0;
-		for (i = 0; i < ms->nr_mirrors; i++)
-			if (!test_bit(i, &error)) {
+		for (i = 0; i < ms->nr_mirrors; i++) {
+			if (test_bit(i, &error))
+				fail_mirror(ms->mirror + i);
+			else
  				uptodate = 1;
-				break;
+		}
+
+		if (likely(uptodate)) {
+			spin_lock(&ms->lock);
+			if (atomic_read(&ms->suspended)) {
+				/*
+				 * The device is suspended, it is
+				 * safe to complete I/O.
+				 */
+				spin_unlock(&ms->lock);
+			} else {
+				/*
+				 * Need to raise event.  Since raising
+				 * events can block, we need to do it in
+				 * seperate thread.
+				 */
+				run = !ms->failures.head;
+				bio_list_add(&ms->failures, bio);
+				spin_unlock(&ms->lock);
+			
+				if (run) {
+					queue_work(_mir_mond_wq,
+						   &ms->failure_work);
+				}
+				return;
  			}
+		} else {
+			DMERR("All replicated volumes dead, failing I/O");
+			/* None of the writes succeeded, fail the I/O. */
+			ret = -EIO;
+		}
  	}
+
  	bio_endio(bio, bio->bi_size, 0);
  }

@@ -843,7 +970,7 @@
  		rh_delay(&ms->rh, bio);

  	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->mirror + DEFAULT_MIRROR, bio);
+		map_bio(ms, ms->default_mirror, bio);
  		generic_make_request(bio);
  	}
  }
@@ -905,11 +1032,15 @@

  	memset(ms, 0, len);
  	spin_lock_init(&ms->lock);
+	spin_lock_init(&ms->choose_lock);

  	ms->ti = ti;
  	ms->nr_mirrors = nr_mirrors;
  	ms->nr_regions = dm_sector_div_up(ti->len, region_size);
  	ms->in_sync = 0;
+	ms->default_mirror = &ms->mirror[DEFAULT_MIRROR];
+
+	atomic_set(&ms->suspended, 0);

  	if (rh_init(&ms->rh, ms, dl, region_size, ms->nr_regions)) {
  		ti->error = "dm-mirror: Error creating dirty region hash";
@@ -917,6 +1048,11 @@
  		return NULL;
  	}

+	atomic_set(&ms->read_count, MIN_READS);
+
+	bio_list_init(&ms->failures);
+	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
+	
  	return ms;
  }

@@ -954,6 +1090,8 @@
  	}

  	ms->mirror[mirror].offset = offset;
+	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	ms->mirror[mirror].ms = ms;

  	return 0;
  }
@@ -1148,7 +1286,7 @@
  		return 0;
  	}

-	m = choose_mirror(ms, bio->bi_sector);
+	m = choose_mirror(ms, NULL);
  	if (!m)
  		return -EIO;

@@ -1172,6 +1310,13 @@
  	return 0;
  }

+static void mirror_presuspend(struct dm_target *ti){
+	struct mirror_set *ms = (struct mirror_set *)ti->private;
+
+	atomic_set(&ms->suspended, 1);
+}
+
+
  static void mirror_postsuspend(struct dm_target *ti)
  {
  	struct mirror_set *ms = (struct mirror_set *) ti->private;
@@ -1191,6 +1336,7 @@
  		/* FIXME: need better error handling */
  		DMWARN("log resume failed");
  	rh_start_recovery(&ms->rh);
+	atomic_set(&ms->suspended, 0);
  }

  static int mirror_status(struct dm_target *ti, status_type_t type,
@@ -1233,6 +1379,7 @@
  	.dtr	 = mirror_dtr,
  	.map	 = mirror_map,
  	.end_io	 = mirror_end_io,
+	.presuspend = mirror_presuspend,
  	.postsuspend = mirror_postsuspend,
  	.resume	 = mirror_resume,
  	.status	 = mirror_status,
@@ -1250,16 +1397,25 @@
  	if (!_kmirrord_wq) {
  		DMERR("couldn't start kmirrord");
  		dm_dirty_log_exit();
-		return r;
+		return -ENOMEM;
  	}
  	INIT_WORK(&_kmirrord_work, do_work, NULL);

+	_mir_mond_wq = create_workqueue("mir_mond");
+	if (!_mir_mond_wq) {
+		DMERR("couldn't start mir_mond");
+		dm_dirty_log_exit();
+		destroy_workqueue(_kmirrord_wq);
+		return -ENOMEM;
+	}
+
  	r = dm_register_target(&mirror_target);
  	if (r < 0) {
  		DMERR("%s: Failed to register mirror target",
  		      mirror_target.name);
  		dm_dirty_log_exit();
  		destroy_workqueue(_kmirrord_wq);
+		destroy_workqueue(_mir_mond_wq);
  	}

  	return r;
