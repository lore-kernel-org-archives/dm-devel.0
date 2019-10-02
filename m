From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-writecache: fix a warning about uninitialized
	variable
Date: Wed, 2 Oct 2019 07:07:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910020617550.973@file01.intranet.prod.int.rdu2.redhat.com>
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

This fixes coverity warning CID 1454301.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2019-10-01 13:14:44.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2019-10-01 16:19:40.000000000 +0200
@@ -1561,7 +1561,7 @@ static void writecache_writeback(struct
 {
 	struct dm_writecache *wc = container_of(work, struct dm_writecache, writeback_work);
 	struct blk_plug plug;
-	struct wc_entry *f, *g, *e = NULL;
+	struct wc_entry *f, *uninitialized_var(g), *e = NULL;
 	struct rb_node *node, *next_node;
 	struct list_head skipped;
 	struct writeback_list wbl;
