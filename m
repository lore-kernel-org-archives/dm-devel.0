From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-table: fail on overflow in dm_round_up
Date: Fri, 22 Nov 2013 19:52:06 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1311221951400.31923@file01.intranet.prod.int.rdu2.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

The dm_round_up function may overflow to zero. In this case, we need to
fail, rather than allocate empty array.

This fixes a possible memory corruption that could be caused by passing
too big number in "param->target_count".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/md/dm-table.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-3.12-fast/drivers/md/dm-table.c
===================================================================
--- linux-3.12-fast.orig/drivers/md/dm-table.c	2013-11-22 21:24:52.000000000 +0100
+++ linux-3.12-fast/drivers/md/dm-table.c	2013-11-22 21:25:59.000000000 +0100
@@ -194,6 +194,11 @@ int dm_table_create(struct dm_table **re
 
 	num_targets = dm_round_up(num_targets, KEYS_PER_NODE);
 
+	if (!num_targets) {
+		kfree(t);
+		return -ENOMEM;
+	}
+
 	if (alloc_targets(t, num_targets)) {
 		kfree(t);
 		return -ENOMEM;
