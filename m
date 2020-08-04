From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH] dm: don't call report zones for more than the user requested
Date: Tue,  4 Aug 2020 18:25:01 +0900
Message-ID: <20200804092501.7938-1-johannes.thumshirn@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-block@vger.kernel.org, Damien Le Moal <Damien.LeMoal@wdc.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, Johannes Thumshirn <johannes.thumshirn@wdc.com>
List-Id: dm-devel.ids

Don't call report zones for more zones than the user actually requested,
otherwise this can lead to out-of-bounds accesses in the callback
functions.

Such a situation can happen if the target's ->report_zones() callback
function returns 0 because we've reached the end of the target and then
restart the report zones on the second target.

We're again calling into ->report_zones() and ultimately into the user
supplied callback function but when we're not subtracting the number of
zones already processed this may lead to out-of-bounds accesses in the
user callbacks.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5b9de2f71bb0..88b391ff9bea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -504,7 +504,8 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 		}
 
 		args.tgt = tgt;
-		ret = tgt->type->report_zones(tgt, &args, nr_zones);
+		ret = tgt->type->report_zones(tgt, &args,
+					      nr_zones - args.zone_idx);
 		if (ret < 0)
 			goto out;
 	} while (args.zone_idx < nr_zones &&
-- 
2.26.2
