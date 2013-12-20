From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 09/20] dm thin: add mappings to end of
	prepared_* lists
Date: Fri, 20 Dec 2013 18:37:22 -0500
Message-ID: <1387582653-13647-10-git-send-email-snitzer@redhat.com>
References: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1387582653-13647-1-git-send-email-snitzer@redhat.com>
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

Mappings could be processed in descending logical block order,
particularly if buffered IO is used.  This could adversely affect the
latency of IO processing.  Fix this by adding mappings to the end of the
'prepared_mappings' and 'prepared_discards' lists.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-thin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index b721d7a..850e7cd 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -535,7 +535,7 @@ static void __maybe_add_mapping(struct dm_thin_new_mapping *m)
 	struct pool *pool = m->tc->pool;
 
 	if (m->quiesced && m->prepared) {
-		list_add(&m->list, &pool->prepared_mappings);
+		list_add_tail(&m->list, &pool->prepared_mappings);
 		wake_worker(pool);
 	}
 }
@@ -1062,7 +1062,7 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 
 			if (!dm_deferred_set_add_work(pool->all_io_ds, &m->list)) {
 				spin_lock_irqsave(&pool->lock, flags);
-				list_add(&m->list, &pool->prepared_discards);
+				list_add_tail(&m->list, &pool->prepared_discards);
 				spin_unlock_irqrestore(&pool->lock, flags);
 				wake_worker(pool);
 			}
@@ -2923,7 +2923,7 @@ static int thin_endio(struct dm_target *ti, struct bio *bio, int err)
 		if (!list_empty(&work)) {
 			spin_lock_irqsave(&pool->lock, flags);
 			list_for_each_entry_safe(m, tmp, &work, list)
-				list_add(&m->list, &pool->prepared_discards);
+				list_add_tail(&m->list, &pool->prepared_discards);
 			spin_unlock_irqrestore(&pool->lock, flags);
 			wake_worker(pool);
 		}
-- 
1.8.1.4
