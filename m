From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 2/2] dm zoned: Remove set but unused variables
Date: Wed,  8 Jul 2020 09:20:23 +0900
Message-ID: <20200708002023.738147-3-damien.lemoal@wdc.com>
References: <20200708002023.738147-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200708002023.738147-1-damien.lemoal@wdc.com>
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
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

In dmz_reclaim_work(), the variables nr_unmap_rnd and nr_rnd are set but
unused. Remove them.

Fixes: f97809aec589 ("dm zoned: per-device reclaim")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm-zoned-reclaim.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index 9c6e264465bc..9c0ecc9568a4 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -503,7 +503,7 @@ static void dmz_reclaim_work(struct work_struct *work)
 {
 	struct dmz_reclaim *zrc = container_of(work, struct dmz_reclaim, work.work);
 	struct dmz_metadata *zmd = zrc->metadata;
-	unsigned int p_unmap, nr_unmap_rnd = 0, nr_rnd = 0;
+	unsigned int p_unmap;
 	int ret;
 
 	if (dmz_dev_is_dying(zmd))
@@ -529,9 +529,6 @@ static void dmz_reclaim_work(struct work_struct *work)
 		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap / 2);
 	}
 
-	nr_unmap_rnd = dmz_nr_unmap_rnd_zones(zmd, zrc->dev_idx);
-	nr_rnd = dmz_nr_rnd_zones(zmd, zrc->dev_idx);
-
 	DMDEBUG("(%s/%u): Reclaim (%u): %s, %u%% free zones (%u/%u cache %u/%u random)",
 		dmz_metadata_label(zmd), zrc->dev_idx,
 		zrc->kc_throttle.throttle,
-- 
2.26.2
