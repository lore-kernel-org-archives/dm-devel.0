From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 01/10] dm-integrity: dont check null pointer
	before kvfree and vfree
Date: Mon, 29 Apr 2019 14:57:17 +0200
Message-ID: <20190429125737.167800360@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-cleanup.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

The functions kfree, vfree and kvfree do nothing if we pass a NULL pointer
to them. So we don't need to test the pointer for NULL.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-05 20:29:19.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-05 20:29:19.000000000 +0200
@@ -3548,10 +3548,8 @@ static void dm_integrity_dtr(struct dm_t
 		destroy_workqueue(ic->writer_wq);
 	if (ic->recalc_wq)
 		destroy_workqueue(ic->recalc_wq);
-	if (ic->recalc_buffer)
-		vfree(ic->recalc_buffer);
-	if (ic->recalc_tags)
-		kvfree(ic->recalc_tags);
+	vfree(ic->recalc_buffer);
+	kvfree(ic->recalc_tags);
 	if (ic->bufio)
 		dm_bufio_client_destroy(ic->bufio);
 	mempool_exit(&ic->journal_io_mempool);
