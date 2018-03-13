From: Denis Semakin <d.semakin@omprussia.ru>
Subject: [PATCH] Adaptation secure erase forwarding for 4.1x
 kernels
Date: Tue, 13 Mar 2018 13:23:45 +0400 (MSK)
Message-ID: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
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
Cc: snitzer@redhat.com
List-Id: dm-devel.ids

Hello.
Here is fixed patch for modern 4.1x kernels.
The idea is to forward secure erase request within device mapper layer to
block device driver which can support secure erase.
Could you please review?
Thanks.

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7eb3e2a..d955a57 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1846,6 +1846,33 @@ static bool dm_table_supports_discards(struct dm_table *t)
        return true;
 }

+static int device_not_secerase_capable(struct dm_target *ti,
+                                          struct dm_dev *dev, sector_t start,
+                                          sector_t len, void *data)
+{
+       struct request_queue *q = bdev_get_queue(dev->bdev);
+
+       return q && !blk_queue_secure_erase(q);
+}
+
+static bool dm_targets_support_secure_erase(struct dm_table *t)
+{
+       unsigned int i = 0;
+       struct dm_target *ti;
+
+       while (i < dm_table_get_num_targets(t)) {
+               ti = dm_table_get_target(t, i++);
+
+               if (!ti->type->iterate_devices ||
+                   ti->type->iterate_devices(ti, device_not_secerase_capable,
+                                             NULL))
+               return false;
+       }
+
+       return true;
+
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
                               struct queue_limits *limits)
 {
@@ -1867,6 +1894,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
        } else
                queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);

+       if (dm_targets_support_secure_erase(t))
+               queue_flag_set_unlocked(QUEUE_FLAG_SECERASE, q);
+
        if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
                wc = true;
                if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))

-- 
Best regards,

Denis Semakin
