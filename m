From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/4] dm: default to disabling WRITE SAME support
	for all targets
Date: Thu, 20 Dec 2012 00:57:10 -0500
Message-ID: <1355983033-17863-1-git-send-email-snitzer@redhat.com>
References: <20121220054725.GA17619@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20121220054725.GA17619@redhat.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

Best to disable WRITE SAME support for all targets and then require each
target to opt-in by setting 'num_write_same_requests' in the dm_target
structure.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c         |   30 ++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |    6 ++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4c145fa..1ae337b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1423,6 +1423,33 @@ static bool dm_table_all_devices_attribute(struct dm_table *t,
 	return 1;
 }
 
+static int device_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
+				     sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && q->limits.max_write_same_sectors;
+}
+
+static bool dm_table_supports_write_same(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->num_write_same_requests)
+			continue;
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_write_same_capable, NULL))
+			return 1;
+	}
+
+	return 0;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1454,6 +1481,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
 
+	if (!dm_table_supports_write_same(t))
+		q->limits.max_write_same_sectors = 0;
+
 	dm_table_set_integrity(t);
 
 	/*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 2d65c70..072b72f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -211,6 +211,12 @@ struct dm_target {
 	unsigned num_discard_requests;
 
 	/*
+	 * The number of WRITE SAME requests that will be submitted to the target.
+	 * The request number can be accessed with dm_bio_get_target_request_nr.
+	 */
+	unsigned num_write_same_requests;
+
+	/*
 	 * The minimum number of extra bytes allocated in each bio for the
 	 * target to use.  dm_per_bio_data returns the data location.
 	 */
-- 
1.7.1
