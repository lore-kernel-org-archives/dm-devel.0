From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: use kvfree
Date: Tue, 17 Apr 2018 18:32:26 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804171831330.2145@file01.intranet.prod.int.rdu2.redhat.com>
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

Use kvfree instead of kfree because the array is allocated with kvmalloc.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-04-18 00:31:11.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-04-18 00:31:11.000000000 +0200
@@ -2440,7 +2440,7 @@ static void dm_integrity_free_journal_sc
 	unsigned i;
 	for (i = 0; i < ic->journal_sections; i++)
 		kvfree(sl[i]);
-	kfree(sl);
+	kvfree(sl);
 }
 
 static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_integrity_c *ic, struct page_list *pl)
