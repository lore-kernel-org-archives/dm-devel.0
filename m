From: Bob Liu <bob.liu@oracle.com>
Subject: [PATCH] dm zoned: remove duplicated nr_rnd_zones increasement
Date: Sun, 22 Mar 2020 17:29:12 +0800
Message-ID: <20200322092912.23148-1-bob.liu@oracle.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Damien.LeMoal@wdc.com, linux-block@vger.kernel.org, Dmitry.Fomichev@wdc.com, Bob Liu <bob.liu@oracle.com>
List-Id: dm-devel.ids

zmd->nr_rnd_zones was increased twice by mistake.
The other place:
1131                 zmd->nr_useable_zones++;
1132                 if (dmz_is_rnd(zone)) {
1133                         zmd->nr_rnd_zones++;
					^^^

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 drivers/md/dm-zoned-metadata.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 516c7b6..369de15 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1109,7 +1109,6 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
 	switch (blkz->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
 		set_bit(DMZ_RND, &zone->flags);
-		zmd->nr_rnd_zones++;
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_REQ:
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
-- 
2.9.5
