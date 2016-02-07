From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 02/15] dm: remove unused
	dm_get_rq_mapinfo()
Date: Sun,  7 Feb 2016 10:53:24 -0500
Message-ID: <1454860417-3203-3-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 846e1bb..873512d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -106,14 +106,6 @@ struct dm_rq_clone_bio_info {
 	struct bio clone;
 };
 
-union map_info *dm_get_rq_mapinfo(struct request *rq)
-{
-	if (rq && rq->end_io_data)
-		return &((struct dm_rq_target_io *)rq->end_io_data)->info;
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
-
 #define MINOR_ALLOCED ((void *)-1)
 
 /*
-- 
2.5.4 (Apple Git-61)
