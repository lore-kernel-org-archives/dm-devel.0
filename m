From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch addition] dm-log-cluster addendum2
Date: Thu, 12 Feb 2009 10:37:30 -0600
Message-ID: <1234456650.13610.4.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

There is no need to case pointers that are 'void *' to begin
with.

This patch should be rolled into the dm-log-cluster.patch.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-cluster.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-cluster.c
+++ linux-2.6/drivers/md/dm-log-cluster.c
@@ -243,7 +243,7 @@ static int cluster_disk_ctr(struct dm_di
 static void cluster_dtr(struct dm_dirty_log *log)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	r = dm_clog_consult_server(lc->uuid, DM_CLOG_DTR,
 				   NULL, 0,
@@ -264,7 +264,7 @@ static void cluster_dtr(struct dm_dirty_
 static int cluster_presuspend(struct dm_dirty_log *log)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	r = dm_clog_consult_server(lc->uuid, DM_CLOG_PRESUSPEND,
 				   NULL, 0,
@@ -280,7 +280,7 @@ static int cluster_presuspend(struct dm_
 static int cluster_postsuspend(struct dm_dirty_log *log)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	r = dm_clog_consult_server(lc->uuid, DM_CLOG_POSTSUSPEND,
 				   NULL, 0,
@@ -296,7 +296,7 @@ static int cluster_postsuspend(struct dm
 static int cluster_resume(struct dm_dirty_log *log)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	lc->in_sync_hint = 0;
 	r = dm_clog_consult_server(lc->uuid, DM_CLOG_RESUME,
@@ -316,7 +316,7 @@ static int cluster_resume(struct dm_dirt
  */
 static uint32_t cluster_get_region_size(struct dm_dirty_log *log)
 {
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	return lc->region_size;
 }
@@ -336,7 +336,7 @@ static int cluster_is_clean(struct dm_di
 	int r;
 	int is_clean;
 	size_t rdata_size;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	rdata_size = sizeof(is_clean);
 	r = cluster_do_request(lc, lc->uuid, DM_CLOG_IS_CLEAN,
@@ -364,7 +364,7 @@ static int cluster_in_sync(struct dm_dir
 	int r;
 	int in_sync;
 	size_t rdata_size;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	/*
 	 * We can never respond directly - even if in_sync_hint is
@@ -411,7 +411,7 @@ static int cluster_flush(struct dm_dirty
 {
 	int r = 0;
 	unsigned long flags;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	LIST_HEAD(flush_list);
 	struct flush_entry *fe, *tmp_fe;
 
@@ -469,7 +469,7 @@ fail:
 static void cluster_mark_region(struct dm_dirty_log *log, region_t region)
 {
 	unsigned long flags;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	struct flush_entry *fe;
 
 	/* Wait for an allocation, but _never_ fail */
@@ -500,7 +500,7 @@ static void cluster_mark_region(struct d
 static void cluster_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	unsigned long flags;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	struct flush_entry *fe;
 
 	/*
@@ -538,7 +538,7 @@ static int cluster_get_resync_work(struc
 {
 	int r;
 	size_t rdata_size;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	struct {
 		int i;
 		region_t r;
@@ -569,7 +569,7 @@ static void cluster_set_region_sync(stru
 				    region_t region, int in_sync)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	struct {
 		region_t r;
 		int i;
@@ -633,7 +633,7 @@ static int cluster_status(struct dm_dirt
 {
 	int r = 0;
 	size_t sz = (size_t)maxlen;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 
 	switch (status_type) {
 	case STATUSTYPE_INFO:
@@ -665,7 +665,7 @@ static int cluster_is_remote_recovering(
 					region_t region)
 {
 	int r;
-	struct log_c *lc = (struct log_c *)log->context;
+	struct log_c *lc = log->context;
 	static unsigned long long limit;
 	struct {
 		int is_recovering;
