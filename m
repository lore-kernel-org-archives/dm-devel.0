From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/24] dm cache policy mq: a few small fixes
Date: Thu, 24 Oct 2013 14:30:17 -0400
Message-ID: <1382639437-27007-5-git-send-email-snitzer@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Rename takeout_queue to concat_queue.

Fix a harmless bug in mq policies pop() function.  Currently pop()
always succeeds, with up coming changes this wont be the case.

Fix typo in comment above pre_cache_to_cache prototype.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 4296155..0410a08 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -311,7 +311,7 @@ struct mq_policy {
 
 /*----------------------------------------------------------------*/
 /* Free/alloc mq cache entry structures. */
-static void takeout_queue(struct list_head *lh, struct queue *q)
+static void concat_queue(struct list_head *lh, struct queue *q)
 {
 	unsigned level;
 
@@ -323,8 +323,8 @@ static void free_entries(struct mq_policy *mq)
 {
 	struct entry *e, *tmp;
 
-	takeout_queue(&mq->free, &mq->pre_cache);
-	takeout_queue(&mq->free, &mq->cache);
+	concat_queue(&mq->free, &mq->pre_cache);
+	concat_queue(&mq->free, &mq->cache);
 
 	list_for_each_entry_safe(e, tmp, &mq->free, list)
 		kmem_cache_free(mq_entry_cache, e);
@@ -531,14 +531,16 @@ static void del(struct mq_policy *mq, struct entry *e)
  */
 static struct entry *pop(struct mq_policy *mq, struct queue *q)
 {
-	struct entry *e = container_of(queue_pop(q), struct entry, list);
+	struct entry *e;
+	struct list_head *h = queue_pop(q);
 
-	if (e) {
-		hash_remove(e);
+	if (!h)
+		return NULL;
 
-		if (e->in_cache)
-			free_cblock(mq, e->cblock);
-	}
+	e = container_of(h, struct entry, list);
+	hash_remove(e);
+	if (e->in_cache)
+		free_cblock(mq, e->cblock);
 
 	return e;
 }
@@ -697,7 +699,7 @@ static int cache_entry_found(struct mq_policy *mq,
 }
 
 /*
- * Moves and entry from the pre_cache to the cache.  The main work is
+ * Moves an entry from the pre_cache to the cache.  The main work is
  * finding which cache block to use.
  */
 static int pre_cache_to_cache(struct mq_policy *mq, struct entry *e,
-- 
1.8.1.4
