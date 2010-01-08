From: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: [PATCH] drivers/md: remove unnecessary casts of void *
Date: Fri, 8 Jan 2010 15:42:35 -0700
Message-ID: <201001081542.35552.hartleys@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754309Ab0AHWml@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, dm-devel@redhat.com
Cc: neilb@suse.de
List-Id: dm-devel.ids

drivers/md: Remove unnecessary casts of void *

void pointers do not need to be cast to other pointer types.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Neil Brown <neilb@suse.de>

---

 drivers/md/bitmap.c         |    8 ++++----
 drivers/md/dm-crypt.c       |    4 ++--
 drivers/md/dm-io.c          |    8 ++++----
 drivers/md/dm-kcopyd.c      |    4 ++--
 drivers/md/dm-linear.c      |    6 +++---
 drivers/md/dm-log.c         |   24 ++++++++++++------------
 drivers/md/dm-mpath.c       |   12 ++++++------
 drivers/md/dm-raid1.c       |   10 +++++-----
 drivers/md/dm-round-robin.c |   10 +++++-----
 drivers/md/dm-stripe.c      |    6 +++---
 drivers/md/dm.c             |    2 +-
 drivers/md/faulty.c         |    6 +++---
 drivers/md/multipath.c      |    2 +-
 drivers/md/raid1.c          |    8 ++++----
 drivers/md/raid10.c         |   10 +++++-----
 drivers/md/raid5.c          |   10 +++++-----
 16 files changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 26ac8aa..24d4b79 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -505,7 +505,7 @@ void bitmap_update_sb(struct bitmap *bitmap)
 		return;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	sb->events = cpu_to_le64(bitmap->mddev->events);
 	if (bitmap->mddev->events < bitmap->events_cleared) {
 		/* rocking back to read-only */
@@ -526,7 +526,7 @@ void bitmap_print_sb(struct bitmap *bitmap)
 
 	if (!bitmap || !bitmap->sb_page)
 		return;
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	printk(KERN_DEBUG "%s: bitmap file superblock:\n", bmname(bitmap));
 	printk(KERN_DEBUG "         magic: %08x\n", le32_to_cpu(sb->magic));
 	printk(KERN_DEBUG "       version: %d\n", le32_to_cpu(sb->version));
@@ -575,7 +575,7 @@ static int bitmap_read_sb(struct bitmap *bitmap)
 		return err;
 	}
 
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 
 	chunksize = le32_to_cpu(sb->chunksize);
 	daemon_sleep = le32_to_cpu(sb->daemon_sleep) * HZ;
@@ -661,7 +661,7 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 		return 0;
 	}
 	spin_unlock_irqrestore(&bitmap->lock, flags);
-	sb = (bitmap_super_t *)kmap_atomic(bitmap->sb_page, KM_USER0);
+	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
 		case MASK_SET: sb->state |= cpu_to_le32(bits);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a936372..5c867e7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1221,7 +1221,7 @@ bad_cipher:
 
 static void crypt_dtr(struct dm_target *ti)
 {
-	struct crypt_config *cc = (struct crypt_config *) ti->private;
+	struct crypt_config *cc = ti->private;
 
 	destroy_workqueue(cc->io_queue);
 	destroy_workqueue(cc->crypt_queue);
@@ -1269,7 +1269,7 @@ static int crypt_map(struct dm_target *ti, struct bio *bio,
 static int crypt_status(struct dm_target *ti, status_type_t type,
 			char *result, unsigned int maxlen)
 {
-	struct crypt_config *cc = (struct crypt_config *) ti->private;
+	struct crypt_config *cc = ti->private;
 	unsigned int sz = 0;
 
 	switch (type) {
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 10f457c..7364793 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -189,7 +189,7 @@ static void list_get_page(struct dpages *dp,
 		  struct page **p, unsigned long *len, unsigned *offset)
 {
 	unsigned o = dp->context_u;
-	struct page_list *pl = (struct page_list *) dp->context_ptr;
+	struct page_list *pl = dp->context_ptr;
 
 	*p = pl->page;
 	*len = PAGE_SIZE - o;
@@ -198,7 +198,7 @@ static void list_get_page(struct dpages *dp,
 
 static void list_next_page(struct dpages *dp)
 {
-	struct page_list *pl = (struct page_list *) dp->context_ptr;
+	struct page_list *pl = dp->context_ptr;
 	dp->context_ptr = pl->next;
 	dp->context_u = 0;
 }
@@ -217,7 +217,7 @@ static void list_dp_init(struct dpages *dp, struct page_list *pl, unsigned offse
 static void bvec_get_page(struct dpages *dp,
 		  struct page **p, unsigned long *len, unsigned *offset)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
+	struct bio_vec *bvec = dp->context_ptr;
 	*p = bvec->bv_page;
 	*len = bvec->bv_len;
 	*offset = bvec->bv_offset;
@@ -225,7 +225,7 @@ static void bvec_get_page(struct dpages *dp,
 
 static void bvec_next_page(struct dpages *dp)
 {
-	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
+	struct bio_vec *bvec = dp->context_ptr;
 	dp->context_ptr = bvec + 1;
 }
 
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index addf834..1b39608 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -310,7 +310,7 @@ static int run_complete_job(struct kcopyd_job *job)
 
 static void complete_io(unsigned long error, void *context)
 {
-	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct kcopyd_job *job = context;
 	struct dm_kcopyd_client *kc = job->kc;
 
 	if (error) {
@@ -464,7 +464,7 @@ static void segment_complete(int read_err, unsigned long write_err,
 	/* FIXME: tidy this function */
 	sector_t progress = 0;
 	sector_t count = 0;
-	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct kcopyd_job *job = context;
 	struct dm_kcopyd_client *kc = job->kc;
 
 	mutex_lock(&job->lock);
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 82f7d6e..87f9c7c 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -64,7 +64,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 static void linear_dtr(struct dm_target *ti)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 
 	dm_put_device(ti, lc->dev);
 	kfree(lc);
@@ -97,7 +97,7 @@ static int linear_map(struct dm_target *ti, struct bio *bio,
 static int linear_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
@@ -115,7 +115,7 @@ static int linear_status(struct dm_target *ti, status_type_t type,
 static int linear_ioctl(struct dm_target *ti, unsigned int cmd,
 			unsigned long arg)
 {
-	struct linear_c *lc = (struct linear_c *) ti->private;
+	struct linear_c *lc = ti->private;
 	return __blkdev_driver_ioctl(lc->dev->bdev, lc->dev->mode, cmd, arg);
 }
 
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 7035582..a744e7c 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -521,7 +521,7 @@ static void destroy_log_context(struct log_c *lc)
 
 static void core_dtr(struct dm_dirty_log *log)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 
 	vfree(lc->clean_bits);
 	destroy_log_context(lc);
@@ -559,7 +559,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 
 static void disk_dtr(struct dm_dirty_log *log)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 
 	dm_put_device(lc->ti, lc->log_dev);
 	vfree(lc->disk_header);
@@ -590,7 +590,7 @@ static int disk_resume(struct dm_dirty_log *log)
 {
 	int r;
 	unsigned i;
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	size_t size = lc->bitset_uint32_count * sizeof(uint32_t);
 
 	/* read the disk header */
@@ -651,26 +651,26 @@ static int disk_resume(struct dm_dirty_log *log)
 
 static uint32_t core_get_region_size(struct dm_dirty_log *log)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	return lc->region_size;
 }
 
 static int core_resume(struct dm_dirty_log *log)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	lc->sync_search = 0;
 	return 0;
 }
 
 static int core_is_clean(struct dm_dirty_log *log, region_t region)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	return log_test_bit(lc->clean_bits, region);
 }
 
 static int core_in_sync(struct dm_dirty_log *log, region_t region, int block)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	return log_test_bit(lc->sync_bits, region);
 }
 
@@ -722,20 +722,20 @@ static int disk_flush(struct dm_dirty_log *log)
 
 static void core_mark_region(struct dm_dirty_log *log, region_t region)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	log_clear_bit(lc, lc->clean_bits, region);
 }
 
 static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 	if (likely(!lc->flush_failed))
 		log_set_bit(lc, lc->clean_bits, region);
 }
 
 static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 
 	if (lc->sync_search >= lc->region_count)
 		return 0;
@@ -759,7 +759,7 @@ static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 				 int in_sync)
 {
-	struct log_c *lc = (struct log_c *) log->context;
+	struct log_c *lc = log->context;
 
 	log_clear_bit(lc, lc->recovering_bits, region);
 	if (in_sync) {
@@ -773,7 +773,7 @@ static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 
 static region_t core_get_sync_count(struct dm_dirty_log *log)
 {
-        struct log_c *lc = (struct log_c *) log->context;
+        struct log_c *lc = log->context;
 
         return lc->sync_count;
 }
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index e81345a..6fd7921 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -913,7 +913,7 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 {
 	int r;
 	struct dm_mpath_io *mpio;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	mpio = mempool_alloc(m->mpio_pool, GFP_ATOMIC);
 	if (!mpio)
@@ -1266,7 +1266,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
  */
 static void multipath_presuspend(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 
 	queue_if_no_path(m, 0, 1);
 }
@@ -1286,7 +1286,7 @@ static void multipath_postsuspend(struct dm_target *ti)
  */
 static void multipath_resume(struct dm_target *ti)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	unsigned long flags;
 
 	mutex_lock(&m->work_mutex);
@@ -1319,7 +1319,7 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 {
 	int sz = 0;
 	unsigned long flags;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	struct priority_group *pg;
 	struct pgpath *p;
 	unsigned pg_num;
@@ -1423,7 +1423,7 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 {
 	int r = -EINVAL;
 	struct dm_dev *dev;
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	action_fn action;
 
 	mutex_lock(&m->work_mutex);
@@ -1491,7 +1491,7 @@ out:
 static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 			   unsigned long arg)
 {
-	struct multipath *m = (struct multipath *) ti->private;
+	struct multipath *m = ti->private;
 	struct block_device *bdev = NULL;
 	fmode_t mode = 0;
 	unsigned long flags;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ad779bd..4d00b4c 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -579,7 +579,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 static void write_callback(unsigned long error, void *context)
 {
 	unsigned i, ret = 0;
-	struct bio *bio = (struct bio *) context;
+	struct bio *bio = context;
 	struct mirror_set *ms;
 	int should_wake = 0;
 	unsigned long flags;
@@ -1117,7 +1117,7 @@ err_free_context:
 
 static void mirror_dtr(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 
 	del_timer_sync(&ms->timer);
 	flush_workqueue(ms->kmirrord_wq);
@@ -1185,7 +1185,7 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio,
 			 int error, union map_info *map_context)
 {
 	int rw = bio_rw(bio);
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct mirror *m = NULL;
 	struct dm_bio_details *bd = NULL;
 	struct dm_raid1_read_record *read_record = map_context->ptr;
@@ -1250,7 +1250,7 @@ out:
 
 static void mirror_presuspend(struct dm_target *ti)
 {
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
 	struct bio_list holds;
@@ -1347,7 +1347,7 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 			 char *result, unsigned int maxlen)
 {
 	unsigned int m, sz = 0;
-	struct mirror_set *ms = (struct mirror_set *) ti->private;
+	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 	char buffer[ms->nr_mirrors + 1];
 
diff --git a/drivers/md/dm-round-robin.c b/drivers/md/dm-round-robin.c
index 24752f4..3b299ba 100644
--- a/drivers/md/dm-round-robin.c
+++ b/drivers/md/dm-round-robin.c
@@ -73,7 +73,7 @@ static int rr_create(struct path_selector *ps, unsigned argc, char **argv)
 
 static void rr_destroy(struct path_selector *ps)
 {
-	struct selector *s = (struct selector *) ps->context;
+	struct selector *s = ps->context;
 
 	free_paths(&s->valid_paths);
 	free_paths(&s->invalid_paths);
@@ -110,7 +110,7 @@ static int rr_status(struct path_selector *ps, struct dm_path *path,
 static int rr_add_path(struct path_selector *ps, struct dm_path *path,
 		       int argc, char **argv, char **error)
 {
-	struct selector *s = (struct selector *) ps->context;
+	struct selector *s = ps->context;
 	struct path_info *pi;
 	unsigned repeat_count = RR_MIN_IO;
 
@@ -144,7 +144,7 @@ static int rr_add_path(struct path_selector *ps, struct dm_path *path,
 
 static void rr_fail_path(struct path_selector *ps, struct dm_path *p)
 {
-	struct selector *s = (struct selector *) ps->context;
+	struct selector *s = ps->context;
 	struct path_info *pi = p->pscontext;
 
 	list_move(&pi->list, &s->invalid_paths);
@@ -152,7 +152,7 @@ static void rr_fail_path(struct path_selector *ps, struct dm_path *p)
 
 static int rr_reinstate_path(struct path_selector *ps, struct dm_path *p)
 {
-	struct selector *s = (struct selector *) ps->context;
+	struct selector *s = ps->context;
 	struct path_info *pi = p->pscontext;
 
 	list_move(&pi->list, &s->valid_paths);
@@ -163,7 +163,7 @@ static int rr_reinstate_path(struct path_selector *ps, struct dm_path *p)
 static struct dm_path *rr_select_path(struct path_selector *ps,
 				      unsigned *repeat_count, size_t nr_bytes)
 {
-	struct selector *s = (struct selector *) ps->context;
+	struct selector *s = ps->context;
 	struct path_info *pi = NULL;
 
 	if (!list_empty(&s->valid_paths)) {
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e0efc1a..397f9af 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -199,7 +199,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 static void stripe_dtr(struct dm_target *ti)
 {
 	unsigned int i;
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 
 	for (i = 0; i < sc->stripes; i++)
 		dm_put_device(ti, sc->stripe[i].dev);
@@ -211,7 +211,7 @@ static void stripe_dtr(struct dm_target *ti)
 static int stripe_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 	sector_t offset, chunk;
 	uint32_t stripe;
 
@@ -247,7 +247,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio,
 static int stripe_status(struct dm_target *ti,
 			 status_type_t type, char *result, unsigned int maxlen)
 {
-	struct stripe_c *sc = (struct stripe_c *) ti->private;
+	struct stripe_c *sc = ti->private;
 	char buffer[sc->stripes + 1];
 	unsigned int sz = 0;
 	unsigned int i;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3167480..92fb121 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2014,7 +2014,7 @@ static void event_callback(void *context)
 {
 	unsigned long flags;
 	LIST_HEAD(uevents);
-	struct mapped_device *md = (struct mapped_device *) context;
+	struct mapped_device *md = context;
 
 	spin_lock_irqsave(&md->uevent_lock, flags);
 	list_splice_init(&md->uevent_list, &uevents);
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 713acd0..608a8d3 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -171,7 +171,7 @@ static void add_sector(conf_t *conf, sector_t start, int mode)
 static int make_request(struct request_queue *q, struct bio *bio)
 {
 	mddev_t *mddev = q->queuedata;
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int failit = 0;
 
 	if (bio_data_dir(bio) == WRITE) {
@@ -224,7 +224,7 @@ static int make_request(struct request_queue *q, struct bio *bio)
 
 static void status(struct seq_file *seq, mddev_t *mddev)
 {
-	conf_t *conf = (conf_t*)mddev->private;
+	conf_t *conf = mddev->private;
 	int n;
 
 	if ((n=atomic_read(&conf->counters[WriteTransient])) != 0)
@@ -327,7 +327,7 @@ static int run(mddev_t *mddev)
 
 static int stop(mddev_t *mddev)
 {
-	conf_t *conf = (conf_t *)mddev->private;
+	conf_t *conf = mddev->private;
 
 	kfree(conf);
 	mddev->private = NULL;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 32a662f..bbcc406 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -84,7 +84,7 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
 static void multipath_end_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	struct multipath_bh * mp_bh = (struct multipath_bh *)(bio->bi_private);
+	struct multipath_bh *mp_bh = bio->bi_private;
 	multipath_conf_t *conf = mp_bh->mddev->private;
 	mdk_rdev_t *rdev = conf->multipaths[mp_bh->path].rdev;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 859bd3f..f6e8e19 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -262,7 +262,7 @@ static inline void update_head_pos(int disk, r1bio_t *r1_bio)
 static void raid1_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int mirror;
 	conf_t *conf = r1_bio->mddev->private;
 
@@ -307,7 +307,7 @@ static void raid1_end_read_request(struct bio *bio, int error)
 static void raid1_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	conf_t *conf = r1_bio->mddev->private;
 	struct bio *to_put = NULL;
@@ -1218,7 +1218,7 @@ abort:
 
 static void end_sync_read(struct bio *bio, int error)
 {
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	int i;
 
 	for (i=r1_bio->mddev->raid_disks; i--; )
@@ -1241,7 +1241,7 @@ static void end_sync_read(struct bio *bio, int error)
 static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r1bio_t * r1_bio = (r1bio_t *)(bio->bi_private);
+	r1bio_t *r1_bio = bio->bi_private;
 	mddev_t *mddev = r1_bio->mddev;
 	conf_t *conf = mddev->private;
 	int i;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d119b7b..717ffc2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -254,7 +254,7 @@ static inline void update_head_pos(int slot, r10bio_t *r10_bio)
 static void raid10_end_read_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
 
@@ -295,7 +295,7 @@ static void raid10_end_read_request(struct bio *bio, int error)
 static void raid10_end_write_request(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	int slot, dev;
 	conf_t *conf = r10_bio->mddev->private;
 
@@ -1219,7 +1219,7 @@ abort:
 
 static void end_sync_read(struct bio *bio, int error)
 {
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	conf_t *conf = r10_bio->mddev->private;
 	int i,d;
 
@@ -1256,7 +1256,7 @@ static void end_sync_read(struct bio *bio, int error)
 static void end_sync_write(struct bio *bio, int error)
 {
 	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
-	r10bio_t * r10_bio = (r10bio_t *)(bio->bi_private);
+	r10bio_t *r10_bio = bio->bi_private;
 	mddev_t *mddev = r10_bio->mddev;
 	conf_t *conf = mddev->private;
 	int i,d;
@@ -1280,7 +1280,7 @@ static void end_sync_write(struct bio *bio, int error)
 			md_done_sync(mddev, s, 1);
 			break;
 		} else {
-			r10bio_t *r10_bio2 = (r10bio_t *)r10_bio->master_bio;
+			r10bio_t *r10_bio2 = r10_bio->master_bio;
 			put_buf(r10_bio);
 			r10_bio = r10_bio2;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e84204e..234813c 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1618,7 +1618,7 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 static void error(mddev_t *mddev, mdk_rdev_t *rdev)
 {
 	char b[BDEVNAME_SIZE];
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	pr_debug("raid5: error called\n");
 
 	if (!test_bit(Faulty, &rdev->flags)) {
@@ -4057,7 +4057,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 	 * As the reads complete, handle_stripe will copy the data
 	 * into the destination stripe and release that stripe.
 	 */
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	sector_t first_sector, last_sector;
 	int raid_disks = conf->previous_raid_disks;
@@ -4266,7 +4266,7 @@ static sector_t reshape_request(mddev_t *mddev, sector_t sector_nr, int *skipped
 /* FIXME go_faster isn't used */
 static inline sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	struct stripe_head *sh;
 	sector_t max_sector = mddev->dev_sectors;
 	int sync_blocks;
@@ -5130,7 +5130,7 @@ abort:
 
 static int stop(mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 
 	md_unregister_thread(mddev->thread);
 	mddev->thread = NULL;
@@ -5179,7 +5179,7 @@ static void printall(struct seq_file *seq, raid5_conf_t *conf)
 
 static void status(struct seq_file *seq, mddev_t *mddev)
 {
-	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	raid5_conf_t *conf = mddev->private;
 	int i;
 
 	seq_printf(seq, " level %d, %dk chunk, algorithm %d", mddev->level,
