From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm: removing unused "total = 0" from
	dm-table.c::set_indexes()
Date: Thu, 01 Nov 2007 13:59:11 -0400
Message-ID: <472A13EF.3040303@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080407050804030008090608"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080407050804030008090608
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

This patch removes "total = 0" from setup_indexes().

The variable 'total' is not used after that.
So it has no effects.
Perhaps a leftover of old editing.

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America

--------------080407050804030008090608
Content-Type: text/x-patch;
 name="dm-remove-unused-total.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-remove-unused-total.patch"

"total = 0" does nothing.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

Index: linux-2.6.23.work/drivers/md/dm-table.c
===================================================================
--- linux-2.6.23.work.orig/drivers/md/dm-table.c
+++ linux-2.6.23.work/drivers/md/dm-table.c
@@ -792,7 +792,7 @@ static int setup_indexes(struct dm_table
 		return -ENOMEM;
 
 	/* set up internal nodes, bottom-up */
-	for (i = t->depth - 2, total = 0; i >= 0; i--) {
+	for (i = t->depth - 2; i >= 0; i--) {
 		t->index[i] = indexes;
 		indexes += (KEYS_PER_NODE * t->counts[i]);
 		setup_btree_index(i, t);

--------------080407050804030008090608
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080407050804030008090608--
