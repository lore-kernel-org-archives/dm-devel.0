From: Colin King <colin.king@canonical.com>
Subject: [PATCH] dm: integrity: fix spelling mistake in workqueue name
Date: Wed, 28 Nov 2018 15:15:31 +0000
Message-ID: <20181128151531.13374-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Colin Ian King <colin.king@canonical.com>

The workqueue name contains a spelling mistake, rename the workqueue
from dm-intergrity-recalc to dm-integrity-recalc

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 62baa3214cc7..457200ca6287 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3460,7 +3460,7 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			ti->error = "Recalculate is only valid with internal hash";
 			goto bad;
 		}
-		ic->recalc_wq = alloc_workqueue("dm-intergrity-recalc", WQ_MEM_RECLAIM, 1);
+		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
 		if (!ic->recalc_wq ) {
 			ti->error = "Cannot allocate workqueue";
 			r = -ENOMEM;
-- 
2.19.1
