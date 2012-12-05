From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm thin: wake the worker when a discard is
	prepared
Date: Wed,  5 Dec 2012 16:26:20 -0500
Message-ID: <1354742781-21423-2-git-send-email-snitzer@redhat.com>
References: <1354742781-21423-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1354742781-21423-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

When discards are prepared it is best to directly wake the worker that
will process them.  The worker will be woken anyway, via periodic
commit, but there is no reason to not wake_worker here.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1cb6d34..2772253 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2664,10 +2664,13 @@ static int thin_endio(struct dm_target *ti,
 	if (h->all_io_entry) {
 		INIT_LIST_HEAD(&work);
 		dm_deferred_entry_dec(h->all_io_entry, &work);
-		spin_lock_irqsave(&pool->lock, flags);
-		list_for_each_entry_safe(m, tmp, &work, list)
-			list_add(&m->list, &pool->prepared_discards);
-		spin_unlock_irqrestore(&pool->lock, flags);
+		if (!list_empty(&work)) {
+			spin_lock_irqsave(&pool->lock, flags);
+			list_for_each_entry_safe(m, tmp, &work, list)
+				list_add(&m->list, &pool->prepared_discards);
+			spin_unlock_irqrestore(&pool->lock, flags);
+			wake_worker(pool);
+		}
 	}
 
 	mempool_free(h, pool->endio_hook_pool);
-- 
1.7.1
