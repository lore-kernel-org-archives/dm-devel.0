From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: [PATCH -next] dm zoned: fix unused but set variable warnings
Date: Thu, 2 Jul 2020 23:11:40 +0800
Message-ID: <20200702151140.5466-1-weiyongjun1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Hulk Robot <hulkci@huawei.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Wei Yongjun <weiyongjun1@huawei.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Fix unused but set variable warnings:

drivers/md/dm-zoned-reclaim.c:504:42: warning:
 variable nr_rnd set but not used [-Wunused-but-set-variable]
  504 |  unsigned int p_unmap, nr_unmap_rnd = 0, nr_rnd = 0;
      |                                          ^~~~~~
drivers/md/dm-zoned-reclaim.c:504:24: warning:
 variable nr_unmap_rnd set but not used [-Wunused-but-set-variable]
  504 |  unsigned int p_unmap, nr_unmap_rnd = 0, nr_rnd = 0;
      |                        ^~~~~~~~~~~~

Fixes: f97809aec589 ("dm zoned: per-device reclaim")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/md/dm-zoned-reclaim.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index dd1eebf6e50f..7e0cc2d732cf 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -501,7 +501,7 @@ static void dmz_reclaim_work(struct work_struct *work)
 {
 	struct dmz_reclaim *zrc = container_of(work, struct dmz_reclaim, work.work);
 	struct dmz_metadata *zmd = zrc->metadata;
-	unsigned int p_unmap, nr_unmap_rnd = 0, nr_rnd = 0;
+	unsigned int p_unmap;
 	int ret;
 
 	if (dmz_dev_is_dying(zmd))
@@ -527,9 +527,6 @@ static void dmz_reclaim_work(struct work_struct *work)
 		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap / 2);
 	}
 
-	nr_unmap_rnd = dmz_nr_unmap_rnd_zones(zmd, zrc->dev_idx);
-	nr_rnd = dmz_nr_rnd_zones(zmd, zrc->dev_idx);
-
 	DMDEBUG("(%s/%u): Reclaim (%u): %s, %u%% free zones (%u/%u cache %u/%u random)",
 		dmz_metadata_label(zmd), zrc->dev_idx,
 		zrc->kc_throttle.throttle,
