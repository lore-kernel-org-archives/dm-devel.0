From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 1/8] dm-integrity: use kvfree
Date: Tue, 01 May 2018 15:55:17 +0200
Message-ID: <20180501135559.149016294@debian.vm>
References: <20180501135516.961417937@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-kvfree.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use kvfree instead of kfree because the structure is allocated with
kvmalloc.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2018-04-29 23:10:11.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2018-04-29 23:10:11.000000000 +0200
@@ -2440,7 +2440,7 @@ static void dm_integrity_free_journal_sc
 	unsigned i;
 	for (i = 0; i < ic->journal_sections; i++)
 		kvfree(sl[i]);
-	kfree(sl);
+	kvfree(sl);
 }
 
 static struct scatterlist **dm_integrity_alloc_journal_scatterlist(struct dm_integrity_c *ic, struct page_list *pl)
