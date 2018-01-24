From: Dennis Semakin <insane79@yandex.ru>
Subject: Enable secdiscard for device in target that support it
Date: Wed, 24 Jan 2018 11:20:32 +0300
Message-ID: <79171516782032@web55j.yandex.ru>
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

Hello.
I'm investigating the opportunity to run secure erase (trim) and secure file deletion on eMMC flash cards for embedded systems.
For systems without device-mapper layer (lvm in my case) it works properly but I have one lvm volume at one of my SoC.
So it cannot work well because file-system's layer does not determine underlying request queue as queue that is available to
execute these commands due to special flags (because given queue does not belong to driver for real eMMC, it's dm).
Well I've written a patch which allows to determine that all devices in target support SECDISCARD.

Could you please share your opinion for this patch. Thanks in advance.

NOTE! This patch is developed for kernel version 3.10.49. :( 

I understand that it's quite old version but currently I cannot upgrade it due to ODM agreements. 

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3bb00e2..96074d6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1479,6 +1479,31 @@ static bool dm_table_supports_write_same(struct dm_table *t)
        return true;
 }
 
+static int device_supports_secdiscard(struct dm_target *ti, struct dm_dev *dev,
+                                      sector_t start, sector_t len, void *data)
+{
+       struct request_queue *q = bdev_get_queue(dev->bdev);
+
+       return blk_queue_secdiscard(q);
+}
+
+static bool dm_targets_support_secdiscard(struct dm_table *t)
+{
+       unsigned i = 0;
+       struct dm_target *ti;
+
+       while (i < dm_table_get_num_targets(t)) {
+               ti = dm_table_get_target(t, i++);
+               if (!ti->type->iterate_devices ||
+                   !ti->type->iterate_devices(ti, device_supports_secdiscard,
+                                              NULL))
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
@@ -1536,6 +1561,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queu
        smp_mb();
        if (dm_table_request_based(t))
                queue_flag_set_unlocked(QUEUE_FLAG_STACKABLE, q);
+
+       barrier();
+       if (dm_targets_support_secdiscard(t))
+               queue_flag_set_unlocked(QUEUE_FLAG_SECDISCARD, q);
+
 }
