From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH] dm-bufio: use list_move instead of list_del/list_add
Date: Thu, 6 Sep 2012 12:35:53 +0800
Message-ID: <CAPgLHd-8yZNyqj1saoD8M4QRYqs_kruJijoj14XPHRBbp0hVsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, neilb@suse.de
Cc: yongjun_wei@trendmicro.com.cn, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move() instead of list_del() + list_add().

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/md/dm-bufio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cc06a1e..b9e006a 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -441,8 +441,7 @@ static void __relink_lru(struct dm_buffer *b, int dirty)
 	c->n_buffers[b->list_mode]--;
 	c->n_buffers[dirty]++;
 	b->list_mode = dirty;
-	list_del(&b->lru_list);
-	list_add(&b->lru_list, &c->lru[dirty]);
+	list_move(&b->lru_list, &c->lru[dirty]);
 }
 
 /*----------------------------------------------------------------


