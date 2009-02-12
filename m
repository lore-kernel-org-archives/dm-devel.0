From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [Patch addition] dm-log-cluster addendum1
Date: Thu, 12 Feb 2009 10:36:56 -0600
Message-ID: <1234456616.13610.2.camel@hydrogen.msp.redhat.com>
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

This patch is contains some 'type' corrections for the main
cluster log patch which is currently under review.

It cleans up the messages seen when compiling with 'V=1 C=1'
flags.

I don't envision this as a separate patch upstream, but rather
it should be rolled into the current dm-log-cluster.patch.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/dm-log-cluster.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-cluster.c
+++ linux-2.6/drivers/md/dm-log-cluster.c
@@ -55,8 +55,8 @@ static void flush_entry_free(void *eleme
 }
 
 static int cluster_do_request(struct log_c *lc, const char *uuid,
-			      int request_type, char *data, int data_size,
-			      char *rdata, int *rdata_size)
+			      int request_type, char *data, size_t data_size,
+			      char *rdata, size_t *rdata_size)
 {
 	int r;
 
@@ -335,7 +335,7 @@ static int cluster_is_clean(struct dm_di
 {
 	int r;
 	int is_clean;
-	int rdata_size;
+	size_t rdata_size;
 	struct log_c *lc = (struct log_c *)log->context;
 
 	rdata_size = sizeof(is_clean);
@@ -363,7 +363,7 @@ static int cluster_in_sync(struct dm_dir
 {
 	int r;
 	int in_sync;
-	int rdata_size;
+	size_t rdata_size;
 	struct log_c *lc = (struct log_c *)log->context;
 
 	/*
@@ -537,7 +537,7 @@ static void cluster_clear_region(struct 
 static int cluster_get_resync_work(struct dm_dirty_log *log, region_t *region)
 {
 	int r;
-	int rdata_size;
+	size_t rdata_size;
 	struct log_c *lc = (struct log_c *)log->context;
 	struct {
 		int i;
@@ -601,7 +601,7 @@ static void cluster_set_region_sync(stru
 static region_t cluster_get_sync_count(struct dm_dirty_log *log)
 {
 	int r;
-	int rdata_size;
+	size_t rdata_size;
 	region_t sync_count;
 	struct log_c *lc = log->context;
 
@@ -632,7 +632,7 @@ static int cluster_status(struct dm_dirt
 			  char *result, unsigned maxlen)
 {
 	int r = 0;
-	unsigned sz = maxlen;
+	size_t sz = (size_t)maxlen;
 	struct log_c *lc = (struct log_c *)log->context;
 
 	switch (status_type) {
@@ -651,7 +651,7 @@ static int cluster_status(struct dm_dirt
 				       result, &sz);
 		break;
 	}
-	return (r) ? 0 : sz;
+	return (r) ? 0 : (int)sz;
 }
 
 /*
@@ -671,7 +671,7 @@ static int cluster_is_remote_recovering(
 		int is_recovering;
 		uint64_t in_sync_hint;
 	} pkg;
-	int rdata_size = sizeof(pkg);
+	size_t rdata_size = sizeof(pkg);
 
 	/*
 	 * Once the mirror has been reported to be in-sync,
Index: linux-2.6/drivers/md/dm-log-cluster-transfer.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-cluster-transfer.c
+++ linux-2.6/drivers/md/dm-log-cluster-transfer.c
@@ -37,7 +37,7 @@ struct receiving_pkg {
 	uint32_t seq;
 
 	int error;
-	int *data_size;
+	size_t *data_size;
 	char *data;
 };
 
@@ -117,7 +117,7 @@ static int fill_pkg(struct cn_msg *msg, 
 			DMERR("Insufficient space to receive package [%s]::",
 			      request_type_str(tfr->request_type));
 			DMERR("  tfr->data_size    = %u", tfr->data_size);
-			DMERR("  *(pkg->data_size) = %u", *(pkg->data_size));
+			DMERR("  *(pkg->data_size) = %lu", *(pkg->data_size));
 
 			*(pkg->data_size) = 0;
 			pkg->error = -ENOSPC;
@@ -170,11 +170,11 @@ static void cn_clog_callback(void *data)
  * Returns: 0 on success, -EXXX on failure
  */
 int dm_clog_consult_server(const char *uuid, int request_type,
-			   char *data, int data_size,
-			   char *rdata, int *rdata_size)
+			   char *data, size_t data_size,
+			   char *rdata, size_t *rdata_size)
 {
 	int r = 0;
-	int dummy = 0;
+	size_t dummy = 0;
 	int overhead_size = sizeof(struct clog_tfr *) + sizeof(struct cn_msg);
 	struct clog_tfr *tfr = prealloced_clog_tfr;
 	struct receiving_pkg pkg;
Index: linux-2.6/drivers/md/dm-log-cluster-transfer.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-cluster-transfer.h
+++ linux-2.6/drivers/md/dm-log-cluster-transfer.h
@@ -12,7 +12,7 @@
 int dm_clog_tfr_init(void);
 void dm_clog_tfr_exit(void);
 int dm_clog_consult_server(const char *uuid, int request_type,
-			   char *data, int data_size,
-			   char *rdata, int *rdata_size);
+			   char *data, size_t data_size,
+			   char *rdata, size_t *rdata_size);
 
 #endif /* __DM_LOG_CLUSTER_TRANSFER_H__ */
