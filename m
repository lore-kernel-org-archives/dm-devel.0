From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] dm log userspace group clear and mark
	requests
Date: Fri, 19 Mar 2010 17:13:17 -0500
Message-ID: <201003192213.o2JMDH7R005904@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: dm-log-userspace-group-clear-and-mark-requests.patch

This patch allows the device-mapper log 'mark' and 'clear'
requests to be grouped and processed in a batch.  This can
significantly reduce the amount of traffic going between
the kernel and userspace (where the processing daemon resides).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-log-userspace-base.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log-userspace-base.c
+++ linux-2.6/drivers/md/dm-log-userspace-base.c
@@ -17,6 +17,14 @@ struct flush_entry {
 	struct list_head list;
 };
 
+/*
+ * This limit on the number of mark and clear request is, to a degree,
+ * arbitrary.  However, there is some basis for the choice in the limits
+ * imposed on the size of data payload by dm-log-userspace-transfer.c:
+ * dm_consult_userspace().
+ */
+#define MAX_FLUSH_GROUP_COUNT 32
+
 struct log_c {
 	struct dm_target *ti;
 	uint32_t region_size;
@@ -45,6 +53,7 @@ struct log_c {
 	spinlock_t flush_lock;
 	struct list_head mark_list;
 	struct list_head clear_list;
+	uint64_t group[MAX_FLUSH_GROUP_COUNT];
 };
 
 static mempool_t *flush_entry_pool;
@@ -348,6 +357,66 @@ static int userspace_in_sync(struct dm_d
 	return (r) ? 0 : (int)in_sync;
 }
 
+static int flush_one_by_one(struct log_c *lc, struct list_head *flush_list)
+{
+	int r = 0;
+	struct flush_entry *fe;
+
+	list_for_each_entry(fe, flush_list, list) {
+		r = userspace_do_request(lc, lc->uuid, fe->type,
+					 (char *)&fe->region,
+					 sizeof(fe->region),
+					 NULL, NULL);
+		if (r)
+			break;
+	}
+
+	return r;
+}
+
+static int flush_by_group(struct log_c *lc, struct list_head *flush_list)
+{
+	int r = 0;
+	int count;
+	uint32_t type;
+	struct flush_entry *fe, *tmp_fe;
+	LIST_HEAD(tmp_list);
+
+	/*
+	 * Group process the requests
+	 */
+	while (!list_empty(flush_list)) {
+		count = 0;
+
+		list_for_each_entry_safe(fe, tmp_fe, flush_list, list) {
+			lc->group[count] = fe->region;
+			count++;
+
+			list_del(&fe->list);
+			list_add(&fe->list, &tmp_list);
+
+			type = fe->type;
+			if (count >= MAX_FLUSH_GROUP_COUNT)
+				break;
+		}
+
+		r = userspace_do_request(lc, lc->uuid, type,
+					 (char *)(lc->group),
+					 count * sizeof(uint64_t),
+					 NULL, NULL);
+		if (r) {
+			/* Group send failed.  Attempt one-by-one. */
+			list_splice_init(&tmp_list, flush_list);
+			r = flush_one_by_one(lc, flush_list);
+			break;
+		}
+	}
+
+	list_splice_init(&tmp_list, flush_list);
+
+	return r;
+}
+
 /*
  * userspace_flush
  *
@@ -382,30 +451,13 @@ static int userspace_flush(struct dm_dir
 	if (list_empty(&mark_list) && list_empty(&clear_list))
 		return 0;
 
-	/*
-	 * FIXME: Count up requests, group request types,
-	 * allocate memory to stick all requests in and
-	 * send to server in one go.  Failing the allocation,
-	 * do it one by one.
-	 */
-
-	list_for_each_entry(fe, &mark_list, list) {
-		r = userspace_do_request(lc, lc->uuid, fe->type,
-					 (char *)&fe->region,
-					 sizeof(fe->region),
-					 NULL, NULL);
-		if (r)
-			goto fail;
-	}
+	r = flush_by_group(lc, &mark_list);
+	if (r)
+		goto fail;
 
-	list_for_each_entry(fe, &clear_list, list) {
-		r = userspace_do_request(lc, lc->uuid, fe->type,
-					 (char *)&fe->region,
-					 sizeof(fe->region),
-					 NULL, NULL);
-		if (r)
-			goto fail;
-	}
+	r = flush_by_group(lc, &clear_list);
+	if (r)
+		goto fail;
 
 	r = userspace_do_request(lc, lc->uuid, DM_ULOG_FLUSH,
 				 NULL, 0, NULL, NULL);
