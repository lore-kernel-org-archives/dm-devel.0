From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] Support discard for multiple devices
Date: Fri, 2 Jul 2010 11:19:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1007021118340.7296@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1007021107420.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021112340.7296@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1007021117580.7296@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Support discard for multiple devices

The previous code supported discards only if there was one underlying device.
(i.e. multiple linear targets pointing to the same device would support
discards, multiple linear targets pointing to different devices wouldn't).

This restriction is not necessary, so this patch removes it.

As we checked, barrier+discard requests are handled by the barrier thread,
so it's safe to use these requests on devices with multiple underlying devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |    6 ------
 1 file changed, 6 deletions(-)

Index: linux-2.6.35-rc3-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.35-rc3-fast.orig/drivers/md/dm-table.c	2010-07-02 16:05:22.000000000 +0200
+++ linux-2.6.35-rc3-fast/drivers/md/dm-table.c	2010-07-02 16:07:45.000000000 +0200
@@ -911,12 +911,6 @@ int dm_table_complete(struct dm_table *t
 	int r = 0;
 	unsigned int leaf_nodes;
 
-	/*
-	 * We only support discards if there is exactly one underlying device.
-	 */
-	if (!list_is_singular(&t->devices))
-		t->discards_supported = 0;
-
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
