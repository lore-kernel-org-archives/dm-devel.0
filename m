From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thinp: check allocation failure
Date: Thu, 4 Aug 2011 12:09:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1108041208160.2419@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-thinp: check allocation failure

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-3.0-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.0-fast.orig/drivers/md/dm-thin.c	2011-08-04 18:07:18.000000000 +0200
+++ linux-3.0-fast/drivers/md/dm-thin.c	2011-08-04 18:07:37.000000000 +0200
@@ -160,6 +160,10 @@ static struct bio_prison *prison_create(
 	spin_lock_init(&prison->lock);
 	prison->cell_pool = mempool_create_kmalloc_pool(nr_cells,
 							sizeof(struct cell));
+	if (!prison->cell_pool) {
+		kfree(prison);
+		return NULL;
+	}
 	prison->nr_buckets = nr_buckets;
 	prison->hash_mask = nr_buckets - 1;
 	prison->cells = (struct hlist_head *) (prison + 1);
