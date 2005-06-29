From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: mirroring: [patch 1 of 8] device failure tolerance
Date: Wed, 29 Jun 2005 13:07:49 -0500
Message-ID: <16a7b346170f3909d57592016a32abc0@redhat.com>
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

This patch defines a couple more states that logs can return, and 
checks for those states in the mirror code.  The states are useful for 
logs that have cluster support.

  brassow

diff -urN linux-2.6.12-orig/drivers/md/dm-log.c 
linux-2.6.12-001/drivers/md/dm-log.c
--- linux-2.6.12-orig/drivers/md/dm-log.c	2005-06-17 14:48:29.000000000 
-0500
+++ linux-2.6.12-001/drivers/md/dm-log.c	2005-06-28 14:38:40.349390239 
-0500
@@ -517,13 +517,13 @@
  static int core_is_clean(struct dirty_log *log, region_t region)
  {
  	struct log_c *lc = (struct log_c *) log->context;
-	return log_test_bit(lc->clean_bits, region);
+	return (log_test_bit(lc->clean_bits, region)) ? LOG_CLEAN : LOG_DIRTY;
  }

  static int core_in_sync(struct dirty_log *log, region_t region, int 
block)
  {
  	struct log_c *lc = (struct log_c *) log->context;
-	return log_test_bit(lc->sync_bits, region);
+	return (log_test_bit(lc->sync_bits, region)) ? LOG_CLEAN : LOG_NOSYNC;
  }

  static int core_flush(struct dirty_log *log)
diff -urN linux-2.6.12-orig/drivers/md/dm-log.h 
linux-2.6.12-001/drivers/md/dm-log.h
--- linux-2.6.12-orig/drivers/md/dm-log.h	2005-06-17 14:48:29.000000000 
-0500
+++ linux-2.6.12-001/drivers/md/dm-log.h	2005-06-28 14:23:54.655103852 
-0500
@@ -9,6 +9,12 @@

  #include "dm.h"

+#define LOG_DIRTY              0
+#define LOG_CLEAN              1
+#define LOG_NOSYNC             2
+#define LOG_RECOVERING         3
+#define LOG_REMOTE_RECOVERING  4
+
  typedef sector_t region_t;

  struct dirty_log_type;
diff -urN linux-2.6.12-orig/drivers/md/dm-raid1.c 
linux-2.6.12-001/drivers/md/dm-raid1.c
--- linux-2.6.12-orig/drivers/md/dm-raid1.c	2005-06-17 
14:48:29.000000000 -0500
+++ linux-2.6.12-001/drivers/md/dm-raid1.c	2005-06-28 
14:49:38.985786409 -0500
@@ -91,7 +91,8 @@
  	RH_CLEAN,
  	RH_DIRTY,
  	RH_NOSYNC,
-	RH_RECOVERING
+	RH_RECOVERING,
+	RH_REMOTE_RECOVERING
  };

  struct region {
@@ -234,7 +235,7 @@

  	read_unlock(&rh->hash_lock);
  	nreg = mempool_alloc(rh->region_pool, GFP_NOIO);
-	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
+	nreg->state = (rh->log->type->in_sync(rh->log, region, 1) == 
LOG_CLEAN) ?
  		RH_CLEAN : RH_NOSYNC;
  	nreg->rh = rh;
  	nreg->key = region;
@@ -292,13 +293,26 @@
  	 * The region wasn't in the hash, so we fall back to the
  	 * dirty log.
  	 */
-	r = rh->log->type->in_sync(rh->log, region, may_block);
-
+	switch (rh->log->type->in_sync(rh->log, region, may_block)) {
+	case LOG_CLEAN:
+		r = RH_CLEAN;
+		break;
+	case LOG_DIRTY:
+		r = RH_DIRTY;
+		break;
+	case LOG_REMOTE_RECOVERING:
+		r = RH_REMOTE_RECOVERING;
+		break;
+	default:
+		r = RH_NOSYNC;
+		break;
+	}
+	
  	/*
  	 * Any error from the dirty log (eg. -EWOULDBLOCK) gets
  	 * taken as a RH_NOSYNC
  	 */
-	return r == 1 ? RH_CLEAN : RH_NOSYNC;
+	return r;
  }

  static inline int rh_in_sync(struct region_hash *rh,
@@ -702,7 +716,7 @@
  		/*
  		 * We can only read balance if the region is in sync.
  		 */
-		if (rh_in_sync(&ms->rh, region, 0))
+		if (rh_in_sync(&ms->rh, region, 0) == RH_CLEAN)
  			m = choose_mirror(ms, bio->bi_sector);
  		else
  			m = ms->mirror + DEFAULT_MIRROR;
@@ -1117,7 +1131,7 @@
  	if (r < 0 && r != -EWOULDBLOCK)
  		return r;

-	if (r == -EWOULDBLOCK)	/* FIXME: ugly */
+	if (r != RH_CLEAN)
  		r = 0;

  	/*
