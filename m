From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/24 v2] dm cache policy mq: return NULL from
 alloc_entry if cache is full
Date: Tue, 29 Oct 2013 10:49:44 -0400
Message-ID: <20131029144943.GA15641@redhat.com>
References: <1382639437-27007-1-git-send-email-snitzer@redhat.com>
	<1382639437-27007-7-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1382639437-27007-7-git-send-email-snitzer@redhat.com>
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
Cc: Morgan Mears <morgan.mears@netapp.com>, Heinz Mauelshagen <heinzm@redhat.com>, Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

alloc_entry() must return NULL if the cache is full (mq->free list is
empty).  To be clear, it is not a bug if the alloc_entry() logic tries
to alloc from the free list before it falls back to pop from pre cache.
The free list is simply a resource priority list that alloc_entry()
tries to claim a block from but sometimes cannot (e.g. cache is full).

This fix addresses callers' (insert_in*cache()) requirement that
alloc_entry() return NULL when an entry isn't able to be allocated.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # v3.9+
---
 drivers/md/dm-cache-policy-mq.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

Index: linux/drivers/md/dm-cache-policy-mq.c
===================================================================
--- linux.orig/drivers/md/dm-cache-policy-mq.c
+++ linux/drivers/md/dm-cache-policy-mq.c
@@ -415,18 +415,20 @@ static void hash_remove(struct entry *e)
  */
 static struct entry *alloc_entry(struct mq_policy *mq)
 {
-	struct entry *e;
+	struct entry *e = NULL;
 
 	if (mq->nr_entries_allocated >= mq->nr_entries) {
 		BUG_ON(!list_empty(&mq->free));
 		return NULL;
 	}
 
-	e = list_entry(list_pop(&mq->free), struct entry, list);
-	INIT_LIST_HEAD(&e->list);
-	INIT_HLIST_NODE(&e->hlist);
+	if (!list_empty(&mq->free)) {
+		e = list_entry(list_pop(&mq->free), struct entry, list);
+		INIT_LIST_HEAD(&e->list);
+		INIT_HLIST_NODE(&e->hlist);
+		mq->nr_entries_allocated++;
+	}
 
-	mq->nr_entries_allocated++;
 	return e;
 }
 
