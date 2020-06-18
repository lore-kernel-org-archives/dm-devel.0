From: "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Subject: [PATCH] dm zoned: Fix metadata zone size check
Date: Thu, 18 Jun 2020 11:48:10 +0900
Message-ID: <20200618024810.443981-1-shinichiro.kawasaki@wdc.com>
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
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Damien Le Moal <Damien.LeMoal@wdc.com>
List-Id: dm-devel.ids

When dm zoned has multiple devices, metadata is on the cache device, not
in random zones of the zoned devices. Then the number of metadata zones
shall be checked with the number of cache zones, not random zones.

Fixes: 34f5affd04c4 ("dm zoned: separate random and cache zones")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 130b5a6d9f12..fc1329ca3e70 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1078,7 +1078,8 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 	nr_meta_zones = (le32_to_cpu(sb->nr_meta_blocks) + zmd->zone_nr_blocks - 1)
 		>> zmd->zone_nr_blocks_shift;
 	if (!nr_meta_zones ||
-	    nr_meta_zones >= zmd->nr_rnd_zones) {
+	    (zmd->nr_devs <= 1 && nr_meta_zones >= zmd->nr_rnd_zones) ||
+	    (zmd->nr_devs > 1 && nr_meta_zones >= zmd->nr_cache_zones)) {
 		dmz_dev_err(dev, "Invalid number of metadata blocks");
 		return -ENXIO;
 	}
-- 
2.25.4
