From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 20/20] dm cache policy mq: introduce
	three promotion threshold tunables
Date: Fri, 20 Dec 2013 18:37:33 -0500
Message-ID: <1387582653-13647-21-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Internally the mq policy maintains a promotion threshold variable.  If
the hit count of a block not in the cache goes above this threshold it
gets promoted to the cache.

This patch introduces three new tunables that allow you to tweak the
promotion threshold by adding a small value.  These adjustments depend
on the io type:

   read_promote_adjustment:    READ io, default 4
   write_promote_adjustment:   WRITE io, default 8
   discard_promote_adjustment: READ/WRITE io to a discarded block, default 1

If you're trying to quickly warm a new cache device you may wish to
reduce these to encourage promotion.  Remember to switch them back to
their defaults after the cache fills though.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/cache-policies.txt | 16 ++++++-
 drivers/md/dm-cache-policy-mq.c                | 64 +++++++++++++++++---------
 2 files changed, 57 insertions(+), 23 deletions(-)

diff --git a/Documentation/device-mapper/cache-policies.txt b/Documentation/device-mapper/cache-policies.txt
index df52a84..66c2774 100644
--- a/Documentation/device-mapper/cache-policies.txt
+++ b/Documentation/device-mapper/cache-policies.txt
@@ -40,8 +40,11 @@ on hit count on entry. The policy aims to take different cache miss
 costs into account and to adjust to varying load patterns automatically.
 
 Message and constructor argument pairs are:
-	'sequential_threshold <#nr_sequential_ios>' and
-	'random_threshold <#nr_random_ios>'.
+	'sequential_threshold <#nr_sequential_ios>'
+	'random_threshold <#nr_random_ios>'
+	'read_promote_adjustment <value>'
+	'write_promote_adjustment <value>'
+	'discard_promote_adjustment <value>'
 
 The sequential threshold indicates the number of contiguous I/Os
 required before a stream is treated as sequential.  The random threshold
@@ -55,6 +58,15 @@ since spindles tend to have good bandwidth. The io_tracker counts
 contiguous I/Os to try to spot when the io is in one of these sequential
 modes.
 
+Internally the mq policy maintains a promotion threshold variable.  If
+the hit count of a block not in the cache goes above this threshold it
+gets promoted to the cache.  The read, write and discard promote adjustment
+tunables allow you to tweak the promotion threshold by adding a small
+value based on the io type.  They default to 4, 8 and 1 respectively.
+If you're trying to quickly warm a new cache device you may wish to
+reduce these to encourage promotion.  Remember to switch them back to
+their defaults after the cache fills though.
+
 cleaner
 -------
 
diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 7f1aaa3..e63e36c 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -390,6 +390,10 @@ struct mq_policy {
 	 */
 	unsigned promote_threshold;
 
+	unsigned discard_promote_adjustment;
+	unsigned read_promote_adjustment;
+	unsigned write_promote_adjustment;
+
 	/*
 	 * The hash table allows us to quickly find an entry by origin
 	 * block.  Both pre_cache and cache entries are in here.
@@ -399,6 +403,10 @@ struct mq_policy {
 	struct hlist_head *table;
 };
 
+#define DEFAULT_DISCARD_PROMOTE_ADJUSTMENT 1
+#define DEFAULT_READ_PROMOTE_ADJUSTMENT 4
+#define DEFAULT_WRITE_PROMOTE_ADJUSTMENT 8
+
 /*----------------------------------------------------------------*/
 
 /*
@@ -641,25 +649,21 @@ static int demote_cblock(struct mq_policy *mq, dm_oblock_t *oblock)
  * We bias towards reads, since they can be demoted at no cost if they
  * haven't been dirtied.
  */
-#define DISCARDED_PROMOTE_THRESHOLD 1
-#define READ_PROMOTE_THRESHOLD 4
-#define WRITE_PROMOTE_THRESHOLD 8
-
 static unsigned adjusted_promote_threshold(struct mq_policy *mq,
 					   bool discarded_oblock, int data_dir)
 {
 	if (data_dir == READ)
-		return mq->promote_threshold + READ_PROMOTE_THRESHOLD;
+		return mq->promote_threshold + mq->read_promote_adjustment;
 
 	if (discarded_oblock && (any_free_cblocks(mq) || any_clean_cblocks(mq))) {
 		/*
 		 * We don't need to do any copying at all, so give this a
 		 * very low threshold.
 		 */
-		return DISCARDED_PROMOTE_THRESHOLD;
+		return mq->discard_promote_adjustment;
 	}
 
-	return mq->promote_threshold + WRITE_PROMOTE_THRESHOLD;
+	return mq->promote_threshold + mq->write_promote_adjustment;
 }
 
 static bool should_promote(struct mq_policy *mq, struct entry *e,
@@ -808,7 +812,7 @@ static int no_entry_found(struct mq_policy *mq, dm_oblock_t oblock,
 			  bool can_migrate, bool discarded_oblock,
 			  int data_dir, struct policy_result *result)
 {
-	if (adjusted_promote_threshold(mq, discarded_oblock, data_dir) == 1) {
+	if (adjusted_promote_threshold(mq, discarded_oblock, data_dir) <= 1) {
 		if (can_migrate)
 			insert_in_cache(mq, oblock, result);
 		else
@@ -1134,20 +1138,28 @@ static int mq_set_config_value(struct dm_cache_policy *p,
 			       const char *key, const char *value)
 {
 	struct mq_policy *mq = to_mq_policy(p);
-	enum io_pattern pattern;
 	unsigned long tmp;
 
-	if (!strcasecmp(key, "random_threshold"))
-		pattern = PATTERN_RANDOM;
-	else if (!strcasecmp(key, "sequential_threshold"))
-		pattern = PATTERN_SEQUENTIAL;
-	else
-		return -EINVAL;
-
 	if (kstrtoul(value, 10, &tmp))
 		return -EINVAL;
 
-	mq->tracker.thresholds[pattern] = tmp;
+	if (!strcasecmp(key, "random_threshold")) {
+		mq->tracker.thresholds[PATTERN_RANDOM] = tmp;
+
+	} else if (!strcasecmp(key, "sequential_threshold")) {
+		mq->tracker.thresholds[PATTERN_SEQUENTIAL] = tmp;
+
+	} else if (!strcasecmp(key, "discard_promote_adjustment"))
+		mq->discard_promote_adjustment = tmp;
+
+	else if (!strcasecmp(key, "read_promote_adjustment"))
+		mq->read_promote_adjustment = tmp;
+
+	else if (!strcasecmp(key, "write_promote_adjustment"))
+		mq->write_promote_adjustment = tmp;
+
+	else
+		return -EINVAL;
 
 	return 0;
 }
@@ -1157,9 +1169,16 @@ static int mq_emit_config_values(struct dm_cache_policy *p, char *result, unsign
 	ssize_t sz = 0;
 	struct mq_policy *mq = to_mq_policy(p);
 
-	DMEMIT("4 random_threshold %u sequential_threshold %u",
+	DMEMIT("10 random_threshold %u "
+	       "sequential_threshold %u "
+	       "discard_promote_adjustment %u "
+	       "read_promote_adjustment %u "
+	       "write_promote_adjustment %u",
 	       mq->tracker.thresholds[PATTERN_RANDOM],
-	       mq->tracker.thresholds[PATTERN_SEQUENTIAL]);
+	       mq->tracker.thresholds[PATTERN_SEQUENTIAL],
+	       mq->discard_promote_adjustment,
+	       mq->read_promote_adjustment,
+	       mq->write_promote_adjustment);
 
 	return 0;
 }
@@ -1212,6 +1231,9 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 	mq->hit_count = 0;
 	mq->generation = 0;
 	mq->promote_threshold = 0;
+	mq->discard_promote_adjustment = DEFAULT_DISCARD_PROMOTE_ADJUSTMENT;
+	mq->read_promote_adjustment = DEFAULT_READ_PROMOTE_ADJUSTMENT;
+	mq->write_promote_adjustment = DEFAULT_WRITE_PROMOTE_ADJUSTMENT;
 	mutex_init(&mq->lock);
 	spin_lock_init(&mq->tick_lock);
 
@@ -1243,7 +1265,7 @@ bad_pre_cache_init:
 
 static struct dm_cache_policy_type mq_policy_type = {
 	.name = "mq",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.hint_size = 4,
 	.owner = THIS_MODULE,
 	.create = mq_create
@@ -1251,7 +1273,7 @@ static struct dm_cache_policy_type mq_policy_type = {
 
 static struct dm_cache_policy_type default_policy_type = {
 	.name = "default",
-	.version = {1, 1, 0},
+	.version = {1, 2, 0},
 	.hint_size = 4,
 	.owner = THIS_MODULE,
 	.create = mq_create
-- 
1.8.1.4
