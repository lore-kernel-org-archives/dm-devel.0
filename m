From: Steven Wilton <swilton@fluentit.com.au>
Subject: Patch - writeback delay
Date: Thu, 3 Mar 2016 22:25:39 +0800
Message-ID: <56D84963.7000301@fluentit.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090503000503030203020607"
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------090503000503030203020607
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Please find attached a patch for the dm-cache mq policy that adds 
another config option of writeback_delay which adds a fixed delay for 
any write hits before a writeback will be performed.  I have tested the 
patch on a development system, and confirmed that the writeback occurs 
after the configured time, and does not appear to cause any issues.  I 
also confirmed that overwriting the same block delays the writeback 
indefinitely, while also avoiding the copy operation from SSD to HDD 
(which is my reason for creating the patch).

I am interested to get confirmation that this patch does not have any 
glaring errors, and getting it merged if it is considered useful.  The 
DEFAULT_WRITEBACK_DELAY option can be set to 0 if you want to merge the 
code without affecting the behaviour of existing deployments.

The patch is available as a git commit here:
https://github.com/eskyuu/linux/commit/565a6e57fa5a55bdd6656ae89a28543a9d871f52


The dm-cache policy could be improved further to defer writebacks until 
the cache is getting full (high/low watermarks), or trying to keep 
sequential dirty blocks together so we write them back sequentially.  I 
am happy to develop and test along these lines if needed.


I can confirm that this patch does make removing the cache more 
difficult, since the cache removal code waits for all writeback to 
complete before removing the cache.  I had a look at the lvm2 code, and 
I'm not sure if the cleaner policy is meant to be applied before waiting 
for the writebacks to complete.  At the worst case, the user-space 
program could be modified to set the writeback delay to 0, which would 
mirror the existing behaviour.

regards

Steven

--------------090503000503030203020607
Content-Type: text/x-patch;
 name="dm-cache-writebackdelay.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dm-cache-writebackdelay.patch"

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 13f547a..18cfa44 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -234,6 +234,7 @@ struct entry {
 	unsigned hit_count;
 	unsigned generation;
 	unsigned tick;
+	unsigned long dirty_writeback_after;
 };
 
 /*
@@ -393,6 +394,9 @@ struct mq_policy {
 	unsigned read_promote_adjustment;
 	unsigned write_promote_adjustment;
 
+	/* How long to wait before issuing a writeback */
+	unsigned writeback_delay;
+
 	/*
 	 * The hash table allows us to quickly find an entry by origin
 	 * block.  Both pre_cache and cache entries are in here.
@@ -406,6 +410,7 @@ struct mq_policy {
 #define DEFAULT_READ_PROMOTE_ADJUSTMENT 4
 #define DEFAULT_WRITE_PROMOTE_ADJUSTMENT 8
 #define DISCOURAGE_DEMOTING_DIRTY_THRESHOLD 128
+#define DEFAULT_WRITEBACK_DELAY 10
 
 /*----------------------------------------------------------------*/
 
@@ -969,6 +974,9 @@ static void __mq_set_clear_dirty(struct mq_policy *mq, dm_oblock_t oblock, bool
 
 	del(mq, e);
 	e->dirty = set;
+	if(set)
+		e->dirty_writeback_after = jiffies + (mq->writeback_delay * HZ);
+
 	push(mq, e);
 }
 
@@ -1090,9 +1098,12 @@ static int mq_remove_cblock(struct dm_cache_policy *p, dm_cblock_t cblock)
 static int __mq_writeback_work(struct mq_policy *mq, dm_oblock_t *oblock,
 			      dm_cblock_t *cblock)
 {
-	struct entry *e = pop(mq, &mq->cache_dirty);
+	struct entry *e = peek(&mq->cache_dirty);
+	if (!e || time_before(jiffies, e->dirty_writeback_after))
+		return -ENODATA;
 
-	if (!e)
+	e = pop(mq, &mq->cache_dirty);
+	if (unlikely(!e))
 		return -ENODATA;
 
 	*oblock = e->oblock;
@@ -1125,6 +1136,7 @@ static void __force_mapping(struct mq_policy *mq,
 		del(mq, e);
 		e->oblock = new_oblock;
 		e->dirty = true;
+		e->dirty_writeback_after = jiffies + (mq->writeback_delay * HZ);
 		push(mq, e);
 	}
 }
@@ -1185,6 +1197,9 @@ static int mq_set_config_value(struct dm_cache_policy *p,
 	else if (!strcasecmp(key, "write_promote_adjustment"))
 		mq->write_promote_adjustment = tmp;
 
+	else if (!strcasecmp(key, "writeback_delay"))
+		mq->writeback_delay = tmp;
+
 	else
 		return -EINVAL;
 
@@ -1196,16 +1211,18 @@ static int mq_emit_config_values(struct dm_cache_policy *p, char *result, unsign
 	ssize_t sz = 0;
 	struct mq_policy *mq = to_mq_policy(p);
 
-	DMEMIT("10 random_threshold %u "
+	DMEMIT("12 random_threshold %u "
 	       "sequential_threshold %u "
 	       "discard_promote_adjustment %u "
 	       "read_promote_adjustment %u "
-	       "write_promote_adjustment %u",
+	       "write_promote_adjustment %u "
+	       "writeback_delay %u",
 	       mq->tracker.thresholds[PATTERN_RANDOM],
 	       mq->tracker.thresholds[PATTERN_SEQUENTIAL],
 	       mq->discard_promote_adjustment,
 	       mq->read_promote_adjustment,
-	       mq->write_promote_adjustment);
+	       mq->write_promote_adjustment,
+	       mq->writeback_delay);
 
 	return 0;
 }
@@ -1260,6 +1277,7 @@ static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 	mq->discard_promote_adjustment = DEFAULT_DISCARD_PROMOTE_ADJUSTMENT;
 	mq->read_promote_adjustment = DEFAULT_READ_PROMOTE_ADJUSTMENT;
 	mq->write_promote_adjustment = DEFAULT_WRITE_PROMOTE_ADJUSTMENT;
+	mq->writeback_delay = DEFAULT_WRITEBACK_DELAY;
 	mutex_init(&mq->lock);
 	spin_lock_init(&mq->tick_lock);
 

--------------090503000503030203020607
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------090503000503030203020607--
