From: John Pittman <jpittman@redhat.com>
Subject: [PATCH 1/3] dm thin: use refcount_t for thin_c reference
	counting
Date: Thu, 23 Aug 2018 13:35:55 -0400
Message-ID: <20180823173557.19665-2-jpittman@redhat.com>
References: <20180823173557.19665-1-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180823173557.19665-1-jpittman@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com
Cc: dm-devel@redhat.com, John Pittman <jpittman@redhat.com>
List-Id: dm-devel.ids

The API surrounding refcount_t should be used in place of atomic_t
when variables are being used as reference counters.  It can
potentially prevent reference counter overflows and use-after-free
conditions.  In the dm thin layer, one such example is tc->refcount.
Change this from the atomic_t API to the refcount_t API to prevent
mentioned conditions.

Signed-off-by: John Pittman <jpittman@redhat.com>
---
 drivers/md/dm-thin.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 7bd60a150f8f..1e5417b9f708 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -319,7 +319,7 @@ struct thin_c {
 	 * Ensures the thin is not destroyed until the worker has finished
 	 * iterating the active_thins list.
 	 */
-	atomic_t refcount;
+	refcount_t refcount;
 	struct completion can_destroy;
 };
 
@@ -3987,12 +3987,12 @@ static struct target_type pool_target = {
  *--------------------------------------------------------------*/
 static void thin_get(struct thin_c *tc)
 {
-	atomic_inc(&tc->refcount);
+	refcount_inc(&tc->refcount);
 }
 
 static void thin_put(struct thin_c *tc)
 {
-	if (atomic_dec_and_test(&tc->refcount))
+	if (refcount_dec_and_test(&tc->refcount))
 		complete(&tc->can_destroy);
 }
 
@@ -4136,7 +4136,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		r = -EINVAL;
 		goto bad;
 	}
-	atomic_set(&tc->refcount, 1);
+	refcount_set(&tc->refcount, 1);
 	init_completion(&tc->can_destroy);
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
-- 
2.17.1
