From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-stats: use dm_kvmalloc_node
Date: Fri, 3 Jul 2015 17:01:01 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507031700330.28837@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use dm_kvmalloc_node just to clean up the code and remove duplicated
logic.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-stats.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-4.1/drivers/md/dm-stats.c
===================================================================
--- linux-4.1.orig/drivers/md/dm-stats.c	2015-07-02 19:21:39.000000000 +0200
+++ linux-4.1/drivers/md/dm-stats.c	2015-07-02 19:23:00.000000000 +0200
@@ -146,12 +146,7 @@ static void *dm_stats_kvzalloc(size_t al
 	if (!claim_shared_memory(alloc_size))
 		return NULL;
 
-	if (alloc_size <= KMALLOC_MAX_SIZE) {
-		p = kzalloc_node(alloc_size, GFP_KERNEL | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN, node);
-		if (p)
-			return p;
-	}
-	p = vzalloc_node(alloc_size, node);
+	p = dm_kvmalloc_node(alloc_size, GFP_KERNEL | __GFP_ZERO, node);
 	if (p)
 		return p;
 
