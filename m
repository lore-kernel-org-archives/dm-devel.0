From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5/7] dm writecache: implement the "cleaner" policy
Date: Mon, 24 Feb 2020 10:20:32 +0100
Message-ID: <20200224092051.903718800@debian-a64.vm>
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
Content-Disposition: inline; filename=dm-writecache-cleaner.patch
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Nikhil Kshirsagar <nkshirsa@redhat.com>, Alasdair Kergon <agk@redhat.com>, David Teigland <teigland@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

The messages flush or flush_on_suspend flush the whole cache. However,
flushing can take some time and the process would be in an interruptible
state during the flush.

This patch implements an alternate flusing method - the "cleaner" option.
When this option is activated (either by a message or in the constructor
arguments), the cache will not promote new writes (however, writes to
already cached blocks are promoted, to avoid data corruption due to
misordered writes) and it will gradually writeback any cached data. The
userspace can then monitor the cleaning process with "dmsetup status".
When the number of cached bloks drops to zero, the userspace can unload
the dm-writecache target and replace it with dm-linear or other targets.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   48 ++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 43 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-02-24 10:18:30.000000000 +0100
+++ linux-2.6/drivers/md/dm-writecache.c	2020-02-24 10:19:04.000000000 +0100
@@ -160,6 +160,7 @@ struct dm_writecache {
 	bool autocommit_time_set:1;
 	bool writeback_fua_set:1;
 	bool flush_on_suspend:1;
+	bool cleaner:1;
 
 	unsigned writeback_all;
 	struct workqueue_struct *writeback_wq;
@@ -1021,6 +1022,28 @@ static int process_flush_on_suspend_mesg
 	return 0;
 }
 
+static void activate_cleaner(struct dm_writecache *wc)
+{
+	wc->flush_on_suspend = true;
+	wc->cleaner = true;
+	wc->freelist_high_watermark = wc->n_blocks;
+	wc->freelist_low_watermark = wc->n_blocks;
+}
+
+static int process_cleaner_mesg(unsigned argc, char **argv, struct dm_writecache *wc)
+{
+	if (argc != 1)
+		return -EINVAL;
+
+	wc_lock(wc);
+	activate_cleaner(wc);
+	if (!dm_suspended(wc->ti))
+		writecache_verify_watermark(wc);
+	wc_unlock(wc);
+
+	return 0;
+}
+
 static int writecache_message(struct dm_target *ti, unsigned argc, char **argv,
 			      char *result, unsigned maxlen)
 {
@@ -1031,6 +1054,8 @@ static int writecache_message(struct dm_
 		r = process_flush_mesg(argc, argv, wc);
 	else if (!strcasecmp(argv[0], "flush_on_suspend"))
 		r = process_flush_on_suspend_mesg(argc, argv, wc);
+	else if (!strcasecmp(argv[0], "cleaner"))
+		r = process_cleaner_mesg(argc, argv, wc);
 	else
 		DMERR("unrecognised message received: %s", argv[0]);
 
@@ -1206,10 +1231,14 @@ read_next_block:
 					goto bio_copy;
 				}
 				found_entry = true;
+			} else {
+				if (unlikely(wc->cleaner))
+					goto direct_write;
 			}
 			e = writecache_pop_from_freelist(wc, (sector_t)-1);
 			if (unlikely(!e)) {
 				if (!found_entry) {
+direct_write:
 					e = writecache_find_entry(wc, bio->bi_iter.bi_sector, WFE_RETURN_FOLLOWING);
 					if (e) {
 						sector_t next_boundary = read_original_sector(wc, e) - bio->bi_iter.bi_sector;
@@ -2071,6 +2100,8 @@ static int writecache_ctr(struct dm_targ
 				goto invalid_optional;
 			wc->autocommit_jiffies = msecs_to_jiffies(autocommit_msecs);
 			wc->autocommit_time_set = true;
+		} else if (!strcasecmp(string, "cleaner")) {
+			wc->cleaner = true;
 		} else if (!strcasecmp(string, "fua")) {
 			if (WC_MODE_PMEM(wc)) {
 				wc->writeback_fua = true;
@@ -2248,6 +2279,9 @@ overflow:
 	do_div(x, 100);
 	wc->freelist_low_watermark = x;
 
+	if (wc->cleaner)
+		activate_cleaner(wc);
+
 	r = writecache_alloc_entries(wc);
 	if (r) {
 		ti->error = "Cannot allocate memory";
@@ -2291,9 +2325,9 @@ static void writecache_status(struct dm_
 		extra_args = 0;
 		if (wc->start_sector)
 			extra_args += 2;
-		if (wc->high_wm_percent_set)
+		if (wc->high_wm_percent_set && !wc->cleaner)
 			extra_args += 2;
-		if (wc->low_wm_percent_set)
+		if (wc->low_wm_percent_set && !wc->cleaner)
 			extra_args += 2;
 		if (wc->max_writeback_jobs_set)
 			extra_args += 2;
@@ -2301,19 +2335,21 @@ static void writecache_status(struct dm_
 			extra_args += 2;
 		if (wc->autocommit_time_set)
 			extra_args += 2;
+		if (wc->cleaner)
+			extra_args++;
 		if (wc->writeback_fua_set)
 			extra_args++;
 
 		DMEMIT("%u", extra_args);
 		if (wc->start_sector)
 			DMEMIT(" start_sector %llu", (unsigned long long)wc->start_sector);
-		if (wc->high_wm_percent_set) {
+		if (wc->high_wm_percent_set && !wc->cleaner) {
 			x = (uint64_t)wc->freelist_high_watermark * 100;
 			x += wc->n_blocks / 2;
 			do_div(x, (size_t)wc->n_blocks);
 			DMEMIT(" high_watermark %u", 100 - (unsigned)x);
 		}
-		if (wc->low_wm_percent_set) {
+		if (wc->low_wm_percent_set && !wc->cleaner) {
 			x = (uint64_t)wc->freelist_low_watermark * 100;
 			x += wc->n_blocks / 2;
 			do_div(x, (size_t)wc->n_blocks);
@@ -2325,6 +2361,8 @@ static void writecache_status(struct dm_
 			DMEMIT(" autocommit_blocks %u", wc->autocommit_blocks);
 		if (wc->autocommit_time_set)
 			DMEMIT(" autocommit_time %u", jiffies_to_msecs(wc->autocommit_jiffies));
+		if (wc->cleaner)
+			DMEMIT(" cleaner");
 		if (wc->writeback_fua_set)
 			DMEMIT(" %sfua", wc->writeback_fua ? "" : "no");
 		break;
@@ -2333,7 +2371,7 @@ static void writecache_status(struct dm_
 
 static struct target_type writecache_target = {
 	.name			= "writecache",
-	.version		= {1, 1, 1},
+	.version		= {1, 2, 0},
 	.module			= THIS_MODULE,
 	.ctr			= writecache_ctr,
 	.dtr			= writecache_dtr,
