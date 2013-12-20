From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-3.14 19/20] dm cache policy mq: use
	list_del_init instead of list_del + INIT_LIST_HEAD
Date: Fri, 20 Dec 2013 18:37:32 -0500
Message-ID: <1387582653-13647-20-git-send-email-snitzer@redhat.com>
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
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-policy-mq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 64780ad..7f1aaa3 100644
--- a/drivers/md/dm-cache-policy-mq.c
+++ b/drivers/md/dm-cache-policy-mq.c
@@ -287,9 +287,8 @@ static struct entry *alloc_entry(struct entry_pool *ep)
 static struct entry *alloc_particular_entry(struct entry_pool *ep, dm_cblock_t cblock)
 {
 	struct entry *e = ep->entries + from_cblock(cblock);
-	list_del(&e->list);
 
-	INIT_LIST_HEAD(&e->list);
+	list_del_init(&e->list);
 	INIT_HLIST_NODE(&e->hlist);
 	ep->nr_allocated++;
 
-- 
1.8.1.4
