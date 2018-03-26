From: Denis Semakin <d.semakin@omprussia.ru>
Subject: Re: dm table: add support for secure erase forwarding
 [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Mon, 26 Mar 2018 12:58:42 +0300 (MSK)
Message-ID: <1329700314.62915.1522058322861.JavaMail.zimbra@omprussia.ru>
References: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
	<20180322151045.GA27598@redhat.com>
	<695931032.318989.1521816469739.JavaMail.zimbra@omprussia.ru>
	<20180323153844.GA4914@redhat.com>
	<1996070847.39629.1522050333423.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1996070847.39629.1522050333423.JavaMail.zimbra@omprussia.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer <snitzer@redhat.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi. Here is a full patch for adding num_secure_erase_bios field in struct dm_targer for linear DMs
and QUEUE_FLAG_SECERASE forwarding.
Could you please review.

Thanks.

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d5f8eff..ff751b0 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -59,6 +59,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)

        ti->num_flush_bios = 1;
        ti->num_discard_bios = 1;
+       ti->num_secure_erase_bios = 1;
        ti->num_write_same_bios = 1;
        ti->num_write_zeroes_bios = 1;
        ti->private = lc;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7eb3e2a..13a2c23 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1846,6 +1846,36 @@ static bool dm_table_supports_discards(struct dm_table *t)
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
+               if (!ti->num_secure_erase_bios)
+                       return false;
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
@@ -1867,6 +1897,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
        } else
                queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);

+       if (dm_targets_support_secure_erase(t))
+               queue_flag_set_unlocked(QUEUE_FLAG_SECERASE, q);
+
        if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
                wc = true;
                if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1e2426c..233ac8f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -267,6 +267,8 @@ struct dm_target {
         */
        unsigned num_discard_bios;

+       unsigned num_secure_erase_bios;
+
        /*
         * The number of WRITE SAME bios that will be submitted to the target.
         * The bio number can be accessed with dm_bio_get_target_bio_nr.
