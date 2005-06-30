From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 2 of 6] device failure tolerance
Date: Thu, 30 Jun 2005 02:41:37 -0500
Message-ID: <fa7c520768c0fbaa2b3f7199a4721f4b@redhat.com>
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

This patch add device failure detection for writes.  It introduces to 
new log functions - [sg]et_default_mirror().  These functions give the 
ability to tolerate a device failing and then returning after a reboot. 
  Before, it was possible for the following to cause incorrect results:
1) device fails
2) new writes occur
3) machine reboot
4) device is back
5) no way of knowing which device to recover from

  brassow

diff -urN linux-2.6.12-00001/drivers/md/dm-log.c 
linux-2.6.12-00002/drivers/md/dm-log.c
--- linux-2.6.12-00001/drivers/md/dm-log.c	2005-06-29 
19:23:58.371949200 -0500
+++ linux-2.6.12-00002/drivers/md/dm-log.c	2005-06-30 
01:44:10.452796237 -0500
@@ -124,6 +124,8 @@
  	 */
  	uint32_t version;
  	sector_t nr_regions;
+	int32_t default_mirror;
+	int32_t nr_mirrors;
  };

  struct log_c {
@@ -192,6 +194,8 @@
  	disk->magic = cpu_to_le32(core->magic);
  	disk->version = cpu_to_le32(core->version);
  	disk->nr_regions = cpu_to_le64(core->nr_regions);
+	disk->default_mirror = cpu_to_le32(core->default_mirror);
+	disk->nr_mirrors = cpu_to_le32(core->nr_mirrors);
  }

  static void header_from_disk(struct log_header *core, struct 
log_header *disk)
@@ -199,6 +203,8 @@
  	core->magic = le32_to_cpu(disk->magic);
  	core->version = le32_to_cpu(disk->version);
  	core->nr_regions = le64_to_cpu(disk->nr_regions);
+	core->default_mirror = le32_to_cpu(disk->default_mirror);
+	core->nr_mirrors = le32_to_cpu(disk->nr_mirrors);
  }

  static int read_header(struct log_c *log)
@@ -215,9 +221,13 @@

  	/* New log required? */
  	if (log->sync != DEFAULTSYNC || log->header.magic != MIRROR_MAGIC) {
+		DMERR("resetting log header.");
  		log->header.magic = MIRROR_MAGIC;
  		log->header.version = MIRROR_DISK_VERSION;
  		log->header.nr_regions = 0;
+		log->header.default_mirror = -1;
+		log->header.nr_mirrors = -1;
+		
  	}

  	if (log->header.version != MIRROR_DISK_VERSION) {
@@ -514,7 +524,7 @@
  	lc->header.nr_regions = lc->region_count;

  	/* write out the log */
-	if ((r = write_bits(lc)) || (r = write_header(lc))){
+	if ((r = write_bits(lc)) || (r = write_header(lc))) {
  		DMERR("A write failure has occurred on a mirror log device.");
  		fail_log_device(lc);
  	} else {
@@ -636,6 +646,60 @@
          return lc->sync_count;
  }

+static int core_set_default_mirror(struct dirty_log *log,
+				   int new_default, int nr_mirrors,
+				   int unsync_regions)
+{
+        struct log_c *lc = (struct log_c *) log->context;
+	lc->header.default_mirror = new_default;
+	lc->header.nr_mirrors = nr_mirrors;
+
+	if (unsync_regions) {
+		size_t bitset_size;
+		bitset_size =
+			dm_round_up(lc->region_count,
+				    sizeof(*lc->clean_bits) << BYTE_SHIFT);
+		bitset_size >>= BYTE_SHIFT;
+		memset(lc->sync_bits, 0, bitset_size);
+		memset(lc->clean_bits, 0, bitset_size);
+		lc->sync_count = 0;
+	}
+
+	/* This is core, so it is not persistent */
+	return 0;
+}
+
+static int core_get_default_mirror(struct dirty_log *log,
+				   int *nr_mirrors)
+{
+        struct log_c *lc = (struct log_c *) log->context;
+	*nr_mirrors = lc->header.nr_mirrors;
+	return lc->header.default_mirror;
+}
+
+static int disk_set_default_mirror(struct dirty_log *log,
+				   int new_default, int nr_mirrors,
+				   int unsync_regions)
+{
+	int r = 0;
+        struct log_c *lc = (struct log_c *) log->context;
+	lc->header.default_mirror = new_default;
+	lc->header.nr_mirrors = nr_mirrors;
+
+	if (unsync_regions) {
+		size_t bitset_size;
+		bitset_size =
+			dm_round_up(lc->region_count,
+				    sizeof(*lc->clean_bits) << BYTE_SHIFT);
+		bitset_size >>= BYTE_SHIFT;
+		memset(lc->sync_bits, 0, bitset_size);
+		memset(lc->clean_bits, 0, bitset_size);
+		lc->sync_count = 0;
+		r = write_bits(lc);
+	}
+	return r ? r : write_header(lc);
+}
+
  #define	DMEMIT_SYNC \
  	if (lc->sync != DEFAULTSYNC) \
  		DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
@@ -695,6 +759,8 @@
  	.get_resync_work = core_get_resync_work,
  	.complete_resync_work = core_complete_resync_work,
  	.get_sync_count = core_get_sync_count,
+	.set_default_mirror = core_set_default_mirror,
+	.get_default_mirror = core_get_default_mirror,
  	.status = core_status,
  };

@@ -714,6 +780,8 @@
  	.get_resync_work = core_get_resync_work,
  	.complete_resync_work = core_complete_resync_work,
  	.get_sync_count = core_get_sync_count,
+	.set_default_mirror = disk_set_default_mirror,
+	.get_default_mirror = core_get_default_mirror,
  	.status = disk_status,
  };

diff -urN linux-2.6.12-00001/drivers/md/dm-log.h 
linux-2.6.12-00002/drivers/md/dm-log.h
--- linux-2.6.12-00001/drivers/md/dm-log.h	2005-06-17 
14:48:29.000000000 -0500
+++ linux-2.6.12-00002/drivers/md/dm-log.h	2005-06-30 
00:14:44.758118870 -0500
@@ -103,6 +103,32 @@
          region_t (*get_sync_count)(struct dirty_log *log);

  	/*
+	 * If the primary mirror fails, we must have a way of
+	 * remembering which mirror is now the primary. Otherwise,
+	 * the following could happen:
+	 * 1) primary fails, but we continue (because that's what
+	 *    mirrors do)
+	 * 2) machine dies and comes back up with the failed device
+	 *    suddenly usable again.
+	 * 3) If the new primary were not recorded, we would
+	 *    choose the wrong primary by mistake, and bring about
+	 *    destruction.
+	 * These fuctions also set and get the number of mirrors,
+	 * allowing the caller to determine if a pheonix device
+	 * is present.  Allowing reads to the pheonix will be
+	 * sure to produce inconsistencies.  Once detected, the
+	 * caller should set_default_mirror w/ unsync_regions = 1
+	 * - forcing the pheonix back into sync due to recovery.
+	 * (get_default_mirror should only be called when
+	 * starting up or resuming.  Same for set w/ unsync_regions)
+	 */
+	int (*set_default_mirror)(struct dirty_log *log,
+				  int new_default, int nr_mirrors,
+				  int unsync_regions);
+	int (*get_default_mirror)(struct dirty_log *log,
+				  int *nr_mirrors);
+
+	/*
  	 * Support function for mirror status requests.
  	 */
  	int (*status)(struct dirty_log *log, status_type_t status_type,
diff -urN linux-2.6.12-00001/drivers/md/dm-raid1.c 
linux-2.6.12-00002/drivers/md/dm-raid1.c
--- linux-2.6.12-00001/drivers/md/dm-raid1.c	2005-06-17 
14:48:29.000000000 -0500
+++ linux-2.6.12-00002/drivers/md/dm-raid1.c	2005-06-30 
01:51:48.500842746 -0500
@@ -28,6 +28,8 @@
  	queue_work(_kmirrord_wq, &_kmirrord_work);
  }

+static struct workqueue_struct *_mir_mond_wq;
+
  /*-----------------------------------------------------------------
   * Region hash
   *
@@ -539,7 +541,8 @@
   * Mirror set structures.
   *---------------------------------------------------------------*/
  struct mirror {
-	atomic_t error_count;
+	atomic_t error_count;  /* Error counter to flag mirror failure */
+	struct mirror_set *ms;
  	struct dm_dev *dev;
  	sector_t offset;
  };
@@ -550,16 +553,23 @@
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
@@ -607,7 +617,7 @@
  	unsigned long flags = 0;

  	/* fill in the source */
-	m = ms->mirror + DEFAULT_MIRROR;
+	m = ms->default_mirror;
  	from.bdev = m->dev->bdev;
  	from.sector = m->offset + region_to_sector(reg->rh, reg->key);
  	if (reg->key == (ms->nr_regions - 1)) {
@@ -623,7 +633,7 @@

  	/* fill in the destinations */
  	for (i = 0, dest = to; i < ms->nr_mirrors; i++) {
-		if (i == DEFAULT_MIRROR)
+		if (&ms->mirror[i] == ms->default_mirror)
  			continue;

  		m = ms->mirror + i;
@@ -673,12 +683,74 @@
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
@@ -690,6 +762,9 @@
  	bio->bi_sector = m->offset + (bio->bi_sector - ms->ti->begin);
  }

+/*-----------------------------------------------------------------
+ * Reads
+ *---------------------------------------------------------------*/
  static void do_reads(struct mirror_set *ms, struct bio_list *reads)
  {
  	region_t region;
@@ -703,9 +778,9 @@
  		 * We can only read balance if the region is in sync.
  		 */
  		if (rh_in_sync(&ms->rh, region, 0))
-			m = choose_mirror(ms, bio->bi_sector);
+			m = choose_mirror(ms, NULL);
  		else
-			m = ms->mirror + DEFAULT_MIRROR;
+			m = ms->default_mirror;

  		map_bio(ms, m, bio);
  		generic_make_request(bio);
@@ -722,36 +797,104 @@
   * RECOVERING:	delay the io until recovery completes
   * NOSYNC:	increment pending, just write to the default mirror
   *---------------------------------------------------------------*/
+static void write_failure_handler(void *data)
+{
+	struct bio *bio;
+	struct bio_list failed_writes;
+	struct mirror_set *ms = (struct mirror_set *)data;
+	struct dirty_log *log = ms->rh.log;
+	int ret_nr, r, good;
+
+	/* Sloppy */
+	for (r = 0, ret_nr = 0, good = 0; r < ms->nr_mirrors; r++) {
+		if (!atomic_read(&(ms->mirror[r].error_count)))
+			good++;
+
+		if (ms->default_mirror == &ms->mirror[r])
+			ret_nr = r;
+	}
+
+	r = log->type->set_default_mirror(log, ret_nr, good, 0);
+	if (r) {
+		DMERR("Unable to set default mirror in the log.");
+		/* FIXME: should we ASSERT? */
+	}
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
-	bio_endio(bio, bio->bi_size, 0);
+
+	bio_endio(bio, bio->bi_size, ret);
  }

  static void do_write(struct mirror_set *ms, struct bio *bio)
@@ -829,7 +972,7 @@
  		rh_delay(&ms->rh, bio);

  	while ((bio = bio_list_pop(&nosync))) {
-		map_bio(ms, ms->mirror + DEFAULT_MIRROR, bio);
+		map_bio(ms, ms->default_mirror, bio);
  		generic_make_request(bio);
  	}
  }
@@ -891,11 +1034,15 @@

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
@@ -903,6 +1050,11 @@
  		return NULL;
  	}

+	atomic_set(&ms->read_count, MIN_READS);
+
+	bio_list_init(&ms->failures);
+	INIT_WORK(&ms->failure_work, write_failure_handler, ms);
+	
  	return ms;
  }

@@ -940,6 +1092,8 @@
  	}

  	ms->mirror[mirror].offset = offset;
+	atomic_set(&(ms->mirror[mirror].error_count), 0);
+	ms->mirror[mirror].ms = ms;

  	return 0;
  }
@@ -1134,7 +1288,7 @@
  		return 0;
  	}

-	m = choose_mirror(ms, bio->bi_sector);
+	m = choose_mirror(ms, NULL);
  	if (!m)
  		return -EIO;

@@ -1158,6 +1312,13 @@
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
@@ -1173,10 +1334,32 @@
  {
  	struct mirror_set *ms = (struct mirror_set *) ti->private;
  	struct dirty_log *log = ms->rh.log;
+	int default_nr, mirror_count;
+
  	if (log->type->resume && log->type->resume(log))
  		/* FIXME: need better error handling */
  		DMWARN("log resume failed");
+
+	default_nr = log->type->get_default_mirror(log, &mirror_count);
+	if (default_nr < 0) {
+		/* First time read, need to set */
+		/* FIXME: Assert if this fails? */
+		log->type->set_default_mirror(log, DEFAULT_MIRROR,
+					      ms->nr_mirrors, 0);
+		default_nr = DEFAULT_MIRROR;
+	} else if (mirror_count != ms->nr_mirrors) {
+		/* FIXME: Assert if this fails? */
+		DMERR("Bad device count, forcing resync.");
+		log->type->set_default_mirror(log, default_nr,
+					      ms->nr_mirrors, 1);
+	}
+
+	spin_lock_irq(&ms->choose_lock);
+	ms->default_mirror = &ms->mirror[default_nr];
+	spin_unlock_irq(&ms->choose_lock);
+
  	rh_start_recovery(&ms->rh);
+	atomic_set(&ms->suspended, 0);
  }

  static int mirror_status(struct dm_target *ti, status_type_t type,
@@ -1216,6 +1399,7 @@
  	.dtr	 = mirror_dtr,
  	.map	 = mirror_map,
  	.end_io	 = mirror_end_io,
+	.presuspend = mirror_presuspend,
  	.postsuspend = mirror_postsuspend,
  	.resume	 = mirror_resume,
  	.status	 = mirror_status,
@@ -1233,16 +1417,25 @@
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
