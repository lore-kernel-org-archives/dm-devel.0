From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/24] dm cache policy mq: return NULL if
	mq->free list is empty in alloc_entry
Date: Thu, 24 Oct 2013 14:30:19 -0400
Message-ID: <1382639437-27007-7-git-send-email-snitzer@redhat.com>
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

From: Heinz Mauelshagen <heinzm@redhat.com>

Addresses callers' (insert_in*cache()) requirement that alloc_entry()
return NULL when an entry isn't able to be allocated.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 108380d..35e6798 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -399,18 +399,20 @@ static void hash_remove(struct entry *e)
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
 
-- 
1.8.1.4
