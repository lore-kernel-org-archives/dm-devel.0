From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm table: fix invalid memory accesses with too high
 sector number
Date: Fri, 23 Aug 2019 09:54:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1908230952160.22174@file01.intranet.prod.int.rdu2.redhat.com>
References: <1566351211-13280-1-git-send-email-kontais@zoho.com> <alpine.LRH.2.02.1908230705510.5296@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1908230705510.5296@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Zhang Tao <kontais@zoho.com>
Cc: agk@redhat.com, snitzer@redhat.com, Zhang Tao <zhangtao27@lenovo.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

If the sector number is too high, dm_table_find_target should return a
pointer to a zeroed dm_target structure (the caller should test it with
dm_target_is_valid).

However, for some table sizes, the code in dm_table_find_target that
performs btree lookup will access out of bound memory structures.

This patch fixes the bug by testing the sector number at the beginning of
dm_table_find_target. We add an "inline" keyword to the function
dm_table_get_size because this is hot path.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Zhang Tao <kontais@zoho.com>
Fixes: 512875bd9661 ("dm: table detect io beyond device")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-table.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2019-08-23 13:40:51.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2019-08-23 15:43:19.000000000 +0200
@@ -1342,7 +1342,7 @@ void dm_table_event(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_event);
 
-sector_t dm_table_get_size(struct dm_table *t)
+inline sector_t dm_table_get_size(struct dm_table *t)
 {
 	return t->num_targets ? (t->highs[t->num_targets - 1] + 1) : 0;
 }
@@ -1367,6 +1367,9 @@ struct dm_target *dm_table_find_target(s
 	unsigned int l, n = 0, k = 0;
 	sector_t *node;
 
+	if (unlikely(sector >= dm_table_get_size(t)))
+		return &t->targets[t->num_targets];
+
 	for (l = 0; l < t->depth; l++) {
 		n = get_child(n, k);
 		node = get_node(t, l, n);
