From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: add cond_resched to a loop
Date: Fri, 19 Jun 2020 11:51:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006191151070.11854@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Add cond_resched to a loop that fills in the mapper memory area because
the loop can be executed many times.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernek.org

---
 drivers/md/dm-writecache.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2020-05-18 15:43:24.218771000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2020-05-18 17:13:43.239999000 +0200
@@ -282,6 +282,8 @@ static int persistent_memory_claim(struc
 			while (daa-- && i < p) {
 				pages[i++] = pfn_t_to_page(pfn);
 				pfn.val++;
+				if (!(i & 15))
+					cond_resched();
 			}
 		} while (i < p);
 		wc->memory_map = vmap(pages, p, VM_MAP, PAGE_KERNEL);
