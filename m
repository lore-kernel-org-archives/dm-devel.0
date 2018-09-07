From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: [PATCH] lvm: device mapper: remove unnecessary unlikely()
Date: Fri,  7 Sep 2018 20:03:37 +0300
Message-ID: <20180907170337.26846-1-igor.stoppa@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>
Cc: igor.stoppa@gmail.com, Igor Stoppa <igor.stoppa@huawei.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

WARN_ON() already contains an unlikely(), so it's not necessary to
wrap it into another.

Signed-off-by: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
Cc: linux-kernel@vger.kernel.org
---
 drivers/md/dm-cache-policy-smq.c | 2 +-
 drivers/md/dm.c                  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-policy-smq.c b/drivers/md/dm-cache-policy-smq.c
index 1b5b9ad9e492..b61aac00ff40 100644
--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -1200,7 +1200,7 @@ static void queue_demotion(struct smq_policy *mq)
 	struct policy_work work;
 	struct entry *e;
 
-	if (unlikely(WARN_ON_ONCE(!mq->migrations_allowed)))
+	if (WARN_ON_ONCE(!mq->migrations_allowed))
 		return;
 
 	e = q_peek(&mq->clean, mq->clean.nr_levels / 2, true);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f7e4ef5342..0f0f8547106d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1653,7 +1653,7 @@ static blk_qc_t __process_bio(struct mapped_device *md,
 		 * Defend against IO still getting in during teardown
 		 * - as was seen for a time with nvme-fcloop
 		 */
-		if (unlikely(WARN_ON_ONCE(!ti || !dm_target_is_valid(ti)))) {
+		if (WARN_ON_ONCE(!ti || !dm_target_is_valid(ti))) {
 			error = -EIO;
 			goto out;
 		}
-- 
2.17.1
