From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 09/13] dm headers: adjust dm-raid1
	identifiers to have "dm_" prefix
Date: Wed,  5 Mar 2008 19:56:00 +0100
Message-ID: <1204743364-3248-10-git-send-email-hjm@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-raid1.c |   73 +++++++++++++++++++++++++------------------------
 1 files changed, 37 insertions(+), 36 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index 37afe35..0fa37f4 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2003 Sistina Software Limited.
+ * Copyright (C) 2004-2008 Red Hat GmbH
  *
  * This file is released under the GPL.
  */
@@ -7,10 +8,10 @@
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
-#include "dm-io.h"
-#include "dm-log.h"
-#include "kcopyd.h"
 
+#include <linux/dm-io.h>
+#include <linux/dm-log.h>
+#include <linux/dm-kcopyd.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
@@ -49,9 +50,9 @@ static DECLARE_WAIT_QUEUE_HEAD(_kmirrord_recovery_stopped);
  *   quiesced_regions: These regions have been spun down, ready
  *   for recovery.  rh_recovery_start() will remove regions from
  *   this list and hand them to kmirrord, which will schedule the
- *   recovery io with kcopyd.
+ *   recovery io with dm-kcopyd.
  *
- *   recovered_regions: Regions that kcopyd has successfully
+ *   recovered_regions: Regions that dm-kcopyd has successfully
  *   recovered.  rh_update_states() will now schedule any delayed
  *   io, up the recovery_count, and remove the region from the
  *   hash.
@@ -74,7 +75,7 @@ struct region_hash {
 	unsigned region_shift;
 
 	/* holds persistent region state */
-	struct dirty_log *log;
+	struct dm_dirty_log *log;
 
 	/* hash table */
 	rwlock_t hash_lock;
@@ -133,7 +134,7 @@ struct mirror_set {
 	struct dm_target *ti;
 	struct list_head list;
 	struct region_hash rh;
-	struct kcopyd_client *kcopyd_client;
+	struct dm_kcopyd_client *dm_kcopyd_client;
 	uint64_t features;
 
 	spinlock_t lock;	/* protects the lists */
@@ -184,7 +185,7 @@ static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw);
 #define MIN_REGIONS 64
 #define MAX_RECOVERY 1
 static int rh_init(struct region_hash *rh, struct mirror_set *ms,
-		   struct dirty_log *log, uint32_t region_size,
+		   struct dm_dirty_log *log, uint32_t region_size,
 		   region_t nr_regions)
 {
 	unsigned int nr_buckets, max_buckets;
@@ -249,7 +250,7 @@ static void rh_exit(struct region_hash *rh)
 	}
 
 	if (rh->log)
-		dm_destroy_dirty_log(rh->log);
+		dm_dirty_log_destroy(rh->log);
 	if (rh->region_pool)
 		mempool_destroy(rh->region_pool);
 	vfree(rh->buckets);
@@ -790,7 +791,7 @@ static int recover(struct mirror_set *ms, struct region *reg)
 {
 	int r;
 	unsigned int i;
-	struct io_region from, to[KCOPYD_MAX_REGIONS], *dest;
+	struct dm_io_region from, to[DM_KCOPYD_MAX_REGIONS], *dest;
 	struct mirror *m;
 	unsigned long flags = 0;
 
@@ -821,10 +822,10 @@ static int recover(struct mirror_set *ms, struct region *reg)
 		dest++;
 	}
 
-	/* hand to kcopyd */
-	set_bit(KCOPYD_IGNORE_ERROR, &flags);
-	r = kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to, flags,
-			recovery_complete, reg);
+	/* hand to dm-kcopyd */
+	set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+	r = dm_kcopyd_copy(ms->dm_kcopyd_client, &from, ms->nr_mirrors - 1,
+			   to, flags, recovery_complete, reg);
 
 	return r;
 }
@@ -833,7 +834,7 @@ static void do_recovery(struct mirror_set *ms)
 {
 	int r;
 	struct region *reg;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	/*
 	 * Start quiescing some regions.
@@ -909,7 +910,7 @@ static void map_bio(struct mirror *m, struct bio *bio)
 	bio->bi_sector = map_sector(m, bio);
 }
 
-static void map_region(struct io_region *io, struct mirror *m,
+static void map_region(struct dm_io_region *io, struct mirror *m,
 		       struct bio *bio)
 {
 	io->bdev = m->dev->bdev;
@@ -951,7 +952,7 @@ static void read_callback(unsigned long error, void *context)
 /* Asynchronous read. */
 static void read_async_bio(struct mirror *m, struct bio *bio)
 {
-	struct io_region io;
+	struct dm_io_region io;
 	struct dm_io_request io_req = {
 		.bi_rw = READ,
 		.mem.type = DM_IO_BVEC,
@@ -997,7 +998,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
  * We do different things with the write io depending on the
  * state of the region that it's in:
  *
- * SYNC: 	increment pending, use kcopyd to write to *all* mirrors
+ * SYNC: 	increment pending, use dm-kcopyd to write to *all* mirrors
  * RECOVERING:	delay the io until recovery completes
  * NOSYNC:	increment pending, just write to the default mirror
  *---------------------------------------------------------------*/
@@ -1019,7 +1020,7 @@ static void __bio_mark_nosync(struct mirror_set *ms,
 {
 	unsigned long flags;
 	struct region_hash *rh = &ms->rh;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 	struct region *reg;
 	region_t region = bio_to_region(rh, bio);
 	int recovering = 0;
@@ -1107,7 +1108,7 @@ out:
 static void do_write(struct mirror_set *ms, struct bio *bio)
 {
 	unsigned int i;
-	struct io_region io[ms->nr_mirrors], *dest = io;
+	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
@@ -1303,7 +1304,7 @@ static void do_mirror(struct work_struct *work)
 static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 					uint32_t region_size,
 					struct dm_target *ti,
-					struct dirty_log *dl)
+					struct dm_dirty_log *dl)
 {
 	size_t len;
 	struct mirror_set *ms = NULL;
@@ -1403,12 +1404,12 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 /*
  * Create dirty log: log_type #log_params <log_params>
  */
-static struct dirty_log *create_dirty_log(struct dm_target *ti,
+static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 					  unsigned int argc, char **argv,
 					  unsigned int *args_used)
 {
 	unsigned int param_count;
-	struct dirty_log *dl;
+	struct dm_dirty_log *dl;
 
 	if (argc < 2) {
 		ti->error = "Insufficient mirror log arguments";
@@ -1427,7 +1428,7 @@ static struct dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	dl = dm_create_dirty_log(argv[0], ti, param_count, argv + 2);
+	dl = dm_dirty_log_create(argv[0], ti, param_count, argv + 2);
 	if (!dl) {
 		ti->error = "Error creating mirror dirty log";
 		return NULL;
@@ -1435,7 +1436,7 @@ static struct dirty_log *create_dirty_log(struct dm_target *ti,
 
 	if (!_check_region_size(ti, dl->type->get_region_size(dl))) {
 		ti->error = "Invalid region size";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return NULL;
 	}
 
@@ -1496,7 +1497,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int r;
 	unsigned int nr_mirrors, m, args_used;
 	struct mirror_set *ms;
-	struct dirty_log *dl;
+	struct dm_dirty_log *dl;
 
 	dl = create_dirty_log(ti, argc, argv, &args_used);
 	if (!dl)
@@ -1506,9 +1507,9 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argc -= args_used;
 
 	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
-	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS + 1) {
+	    nr_mirrors < 2 || nr_mirrors > DM_KCOPYD_MAX_REGIONS + 1) {
 		ti->error = "Invalid number of mirrors";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -EINVAL;
 	}
 
@@ -1516,13 +1517,13 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (argc < nr_mirrors * 2) {
 		ti->error = "Too few mirror arguments";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -EINVAL;
 	}
 
 	ms = alloc_context(nr_mirrors, dl->type->get_region_size(dl), ti, dl);
 	if (!ms) {
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -ENOMEM;
 	}
 
@@ -1571,7 +1572,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err_destroy_wq;
 	}
 
-	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
+	r = dm_kcopyd_client_create(DM_IO_PAGES, &ms->dm_kcopyd_client);
 	if (r)
 		goto err_destroy_wq;
 
@@ -1590,7 +1591,7 @@ static void mirror_dtr(struct dm_target *ti)
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
 	flush_workqueue(ms->kmirrord_wq);
-	kcopyd_client_destroy(ms->kcopyd_client);
+	dm_kcopyd_client_destroy(ms->dm_kcopyd_client);
 	destroy_workqueue(ms->kmirrord_wq);
 	free_context(ms, ti, ms->nr_mirrors);
 }
@@ -1734,7 +1735,7 @@ out:
 static void mirror_presuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 1);
 
@@ -1763,7 +1764,7 @@ static void mirror_presuspend(struct dm_target *ti)
 static void mirror_postsuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
@@ -1773,7 +1774,7 @@ static void mirror_postsuspend(struct dm_target *ti)
 static void mirror_resume(struct dm_target *ti)
 {
 	struct mirror_set *ms = ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 0);
 	if (log->type->resume && log->type->resume(log))
@@ -1811,7 +1812,7 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 	char buffer[ms->nr_mirrors + 1];
 
 	switch (type) {
-- 
1.5.4.1
