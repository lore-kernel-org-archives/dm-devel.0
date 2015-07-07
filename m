From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6/7] dm-stats: use kvmalloc_node
Date: Tue, 7 Jul 2015 11:12:24 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1507071111460.23387@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <alpine.LRH.2.02.1507071058350.23387@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mike Snitzer <msnitzer@redhat.com>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Edward Thornber <thornber@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Use kvmalloc_node just to clean up the code and remove duplicated logic.

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
+	p = kvmalloc_node(alloc_size, GFP_KERNEL | __GFP_ZERO, node);
 	if (p)
 		return p;
 

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
