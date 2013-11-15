From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] dm cache policy mq:: use list_del_init instead of list_del/INIT_LIST_HEAD
Date: Fri, 15 Nov 2013 17:47:12 +0800
Message-ID: <CAPgLHd_iO2aHnn-uBp=1OYafVonrSfXnEcW7Mz=vp3btkkygPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_del_init() instead of list_del() + INIT_LIST_HEAD().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-cache-policy-mq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-policy-mq.c b/drivers/md/dm-cache-policy-mq.c
index 7209fab..ac7d3b3 100644
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
 

