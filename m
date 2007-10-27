From: Paul Jimenez <pj@place.org>
Subject: [PATCH] KJ: md-table use list_for_each
Date: Sat, 27 Oct 2007 01:42:26 -0500
Message-ID: <20071027064226.81C9E8AFC@place.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
Cc: kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids


A minor bit of cleanup, suitable for a first KJ submission.
Let me know if I forgot to dot an i or cross a t somewhere in
the submission process!

  --pj

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 8939e61..1a735bb 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -280,9 +280,8 @@ static void free_devices(struct list_head *devices)
 {
 	struct list_head *tmp, *next;
 
-	for (tmp = devices->next; tmp != devices; tmp = next) {
+	list_for_each_safe(tmp, next, devices) {	
 		struct dm_dev *dd = list_entry(tmp, struct dm_dev, list);
-		next = tmp->next;
 		kfree(dd);
 	}
 }
@@ -972,12 +971,11 @@ int dm_table_resume_targets(struct dm_table *t)
 
 int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 {
-	struct list_head *d, *devices;
+	struct dm_dev *dd;
+	struct list_head *devices = dm_table_get_devices(t);
 	int r = 0;
 
-	devices = dm_table_get_devices(t);
-	for (d = devices->next; d != devices; d = d->next) {
-		struct dm_dev *dd = list_entry(d, struct dm_dev, list);
+	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
 		r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 	}
@@ -987,10 +985,10 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 
 void dm_table_unplug_all(struct dm_table *t)
 {
+	struct dm_dev *dd;
 	struct list_head *d, *devices = dm_table_get_devices(t);
 
-	for (d = devices->next; d != devices; d = d->next) {
-		struct dm_dev *dd = list_entry(d, struct dm_dev, list);
+	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->bdev);
 
 		if (q->unplug_fn)
