From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:46:14 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270745510.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Split the variable "touched" to two variables "touched_dirtied" and
"touched_cleaned" that are set when some region was dirtied or cleaned.

This will be used to optimize flushes.

After a transition from "dirty" to "clean" state we don't have flush hardware
cache on the log device. After a transition from "clean" to "dirty" the cache
must be flushed.

Before a transition from "clean" to "dirty" state we don't have to flush all
the raid legs. Before a transition from "dirty" to "clean" we must flush all
the legs to make sure that they are really in sync.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-log.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-log.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-log.c	2009-04-24 10:54:54.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-log.c	2009-04-24 11:06:19.000000000 +0200
@@ -208,7 +208,8 @@ struct log_header {
 
 struct log_c {
 	struct dm_target *ti;
-	int touched;
+	int touched_dirtied;
+	int touched_cleaned;
 	uint32_t region_size;
 	unsigned int region_count;
 	region_t sync_count;
@@ -253,14 +254,14 @@ static inline void log_set_bit(struct lo
 			       uint32_t *bs, unsigned bit)
 {
 	ext2_set_bit(bit, (unsigned long *) bs);
-	l->touched = 1;
+	l->touched_cleaned = 1;
 }
 
 static inline void log_clear_bit(struct log_c *l,
 				 uint32_t *bs, unsigned bit)
 {
 	ext2_clear_bit(bit, (unsigned long *) bs);
-	l->touched = 1;
+	l->touched_dirtied = 1;
 }
 
 /*----------------------------------------------------------------
@@ -378,7 +379,8 @@ static int create_log_context(struct dm_
 	}
 
 	lc->ti = ti;
-	lc->touched = 0;
+	lc->touched_dirtied = 0;
+	lc->touched_cleaned = 0;
 	lc->region_size = region_size;
 	lc->region_count = region_count;
 	lc->sync = sync;
@@ -658,14 +660,16 @@ static int disk_flush(struct dm_dirty_lo
 	struct log_c *lc = (struct log_c *) log->context;
 
 	/* only write if the log has changed */
-	if (!lc->touched)
+	if (!lc->touched_cleaned && !lc->touched_dirtied)
 		return 0;
 
 	r = rw_header(lc, WRITE);
 	if (r)
 		fail_log_device(lc);
-	else
-		lc->touched = 0;
+	else {
+		lc->touched_dirtied = 0;
+		lc->touched_cleaned = 0;
+	}
 
 	return r;
 }
