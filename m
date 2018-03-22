From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: add support for secure erase
 forwarding [was: Re: Adaptation secure erase forwarding for 4.1x kernels]
Date: Thu, 22 Mar 2018 11:10:46 -0400
Message-ID: <20180322151045.GA27598@redhat.com>
References: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1496940834.549721.1520933025411.JavaMail.zimbra@omprussia.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Denis Semakin <d.semakin@omprussia.ru>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Mar 13 2018 at  5:23am -0400,
Denis Semakin <d.semakin@omprussia.ru> wrote:

> Hello.
> Here is fixed patch for modern 4.1x kernels.
> The idea is to forward secure erase request within device mapper layer to
> block device driver which can support secure erase.
> Could you please review?

There were various issues with your patch that I cleaned up, please see
the following.

But I'm left skeptical that this is enough.  Don't targets need to
explicitly handle these REQ_OP_SECURE_ERASE requests?  Similar to how
REQ_OP_DISCARD is handled?

I'd feel safer about having targets opt-in with setting (a new)
ti->num_secure_erase_bios.

Which DM target(s) have you been wanting to pass REQ_OP_SECURE_ERASE
bios?

Mike


From: Denis Semakin <d.semakin@omprussia.ru>
Date: Tue, 13 Mar 2018 13:23:45 +0400
Subject: [PATCH] dm table: add support for secure erase forwarding

Set QUEUE_FLAG_SECERASE in DM device's queue_flags if a DM table's
data devices support secure erase.

Signed-off-by: Denis Semakin <d.semakin@omprussia.ru>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7eb3e2a..d857369 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1846,6 +1846,31 @@ static bool dm_table_supports_discards(struct dm_table *t)
 	return true;
 }
 
+static int device_not_secure_erase_capable(struct dm_target *ti,
+					   struct dm_dev *dev, sector_t start,
+					   sector_t len, void *data)
+{
+       struct request_queue *q = bdev_get_queue(dev->bdev);
+
+       return q && !blk_queue_secure_erase(q);
+}
+
+static bool dm_table_supports_secure_erase(struct dm_table *t)
+{
+       struct dm_target *ti;
+       unsigned int i;
+
+       for (i = 0; i < dm_table_get_num_targets(t); i++) {
+               ti = dm_table_get_target(t, i);
+
+               if (!ti->type->iterate_devices ||
+                   ti->type->iterate_devices(ti, device_not_secure_erase_capable, NULL))
+		       return false;
+       }
+
+       return true;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1867,6 +1892,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	} else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 
+	if (dm_table_supports_secure_erase(t))
+		queue_flag_set_unlocked(QUEUE_FLAG_SECERASE, q);
+
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
 		if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_FUA)))
-- 
1.7.4.4
