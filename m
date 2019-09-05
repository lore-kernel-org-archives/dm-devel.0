From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v5 4/7] block: Improve default elevator selection
Date: Thu,  5 Sep 2019 18:51:32 +0900
Message-ID: <20190905095135.26026-5-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
List-Id: dm-devel.ids

For block devices that do not specify required features, preserve the
current default elevator selection (mq-deadline for single queue
devices, none for multi-queue devices). However, for devices specifying
required features (e.g. zoned block devices ELEVATOR_F_ZBD_SEQ_WRITE
feature), select the first available elevator providing the required
features.

In all cases, default to "none" if no elevator is available or if the
initialization of the default elevator fails.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/elevator.c | 51 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index ac7c8ad580ba..520d6b224b74 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -651,9 +651,46 @@ static inline bool elv_support_iosched(struct request_queue *q)
 }
 
 /*
- * For blk-mq devices supporting IO scheduling, we default to using mq-deadline,
- * if available, for single queue devices. If deadline isn't available OR
- * deadline initialization fails OR we have multiple queues, default to "none".
+ * For single queue devices, default to using mq-deadline. If we have multiple
+ * queues or mq-deadline is not available, default to "none".
+ */
+static struct elevator_type *elevator_get_default(struct request_queue *q)
+{
+	if (q->nr_hw_queues != 1)
+		return NULL;
+
+	return elevator_get(q, "mq-deadline", false);
+}
+
+/*
+ * Get the first elevator providing the features required by the request queue.
+ * Default to "none" if no matching elevator is found.
+ */
+static struct elevator_type *elevator_get_by_features(struct request_queue *q)
+{
+	struct elevator_type *e;
+
+	spin_lock(&elv_list_lock);
+
+	list_for_each_entry(e, &elv_list, list) {
+		if (elv_support_features(e->elevator_features,
+					 q->required_elevator_features))
+			break;
+	}
+
+	if (e && !try_module_get(e->elevator_owner))
+		e = NULL;
+
+	spin_unlock(&elv_list_lock);
+
+	return e;
+}
+
+/*
+ * For a device queue that has no required features, use the default elevator
+ * settings. Otherwise, use the first elevator available matching the required
+ * features. If no suitable elevator is find or if the chosen elevator
+ * initialization fails, fall back to the "none" elevator (no elevator).
  */
 void elevator_init_mq(struct request_queue *q)
 {
@@ -663,15 +700,15 @@ void elevator_init_mq(struct request_queue *q)
 	if (!elv_support_iosched(q))
 		return;
 
-	if (q->nr_hw_queues != 1)
-		return;
-
 	WARN_ON_ONCE(test_bit(QUEUE_FLAG_REGISTERED, &q->queue_flags));
 
 	if (unlikely(q->elevator))
 		return;
 
-	e = elevator_get(q, "mq-deadline", false);
+	if (!q->required_elevator_features)
+		e = elevator_get_default(q);
+	else
+		e = elevator_get_by_features(q);
 	if (!e)
 		return;
 
-- 
2.21.0
