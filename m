From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/13] drbd: remove dead code in device_to_statistics
Date: Mon, 21 Sep 2020 10:07:23 +0200
Message-ID: <20200921080734.452759-3-hch@lst.de>
References: <20200921080734.452759-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200921080734.452759-1-hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Song Liu <song@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Coly Li <colyli@suse.de>, Richard Weinberger <richard@nod.at>, Minchan Kim <minchan@kernel.org>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Justin Sanders <justin@coraid.com>, linux-mtd@lists.infradead.org, dm-devel@redhat.com, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, Jan Kara <jack@suse.cz>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
List-Id: dm-devel.ids

Ever since the switch to blk-mq, a lower device not used for VM
writeback will not be marked congested, so the check will never
trigger.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/block/drbd/drbd_nl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 43c8ae4d9fca81..aaff5bde391506 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -3370,7 +3370,6 @@ static void device_to_statistics(struct device_statistics *s,
 	if (get_ldev(device)) {
 		struct drbd_md *md = &device->ldev->md;
 		u64 *history_uuids = (u64 *)s->history_uuids;
-		struct request_queue *q;
 		int n;
 
 		spin_lock_irq(&md->uuid_lock);
@@ -3384,11 +3383,6 @@ static void device_to_statistics(struct device_statistics *s,
 		spin_unlock_irq(&md->uuid_lock);
 
 		s->dev_disk_flags = md->flags;
-		q = bdev_get_queue(device->ldev->backing_bdev);
-		s->dev_lower_blocked =
-			bdi_congested(q->backing_dev_info,
-				      (1 << WB_async_congested) |
-				      (1 << WB_sync_congested));
 		put_ldev(device);
 	}
 	s->dev_size = drbd_get_capacity(device->this_bdev);
-- 
2.28.0
