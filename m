From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 3/4] dm log userspace: group clear and mark
	requests
Date: Fri,  3 Dec 2010 18:12:49 -0500
Message-ID: <1291417970-5626-4-git-send-email-snitzer@redhat.com>
References: <1291417970-5626-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1291417970-5626-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

Allow the device-mapper log's 'mark' and 'clear' requests to be
grouped and processed in a batch.  This can significantly reduce the
amount of traffic going between the kernel and userspace (where the
processing daemon resides).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-log-userspace-base.c |  102 ++++++++++++++++++++++++++++--------
 1 files changed, 79 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index fb71c51..3be0687 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -18,6 +18,14 @@ struct flush_entry {
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
@@ -349,6 +357,71 @@ static int userspace_in_sync(struct dm_dirty_log *log, region_t region,
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
+	uint32_t type = 0;
+	struct flush_entry *fe, *tmp_fe;
+	LIST_HEAD(tmp_list);
+	uint64_t group[MAX_FLUSH_GROUP_COUNT];
+
+	/*
+	 * Group process the requests
+	 */
+	while (!list_empty(flush_list)) {
+		count = 0;
+
+		list_for_each_entry_safe(fe, tmp_fe, flush_list, list) {
+			group[count] = fe->region;
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
+					 (char *)(group),
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
+	/*
+	 * Must collect flush_entrys that were successfully processed
+	 * as a group so that they will be free'd by the caller.
+	 */
+	list_splice_init(&tmp_list, flush_list);
+
+	return r;
+}
+
 /*
  * userspace_flush
  *
@@ -383,30 +456,13 @@ static int userspace_flush(struct dm_dirty_log *log)
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
-- 
1.7.2.3
