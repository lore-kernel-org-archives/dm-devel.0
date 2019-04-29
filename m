From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 06/10] dm-integrity: introduce a function
	add_new_range_and_wait
Date: Mon, 29 Apr 2019 14:57:22 +0200
Message-ID: <20190429125743.476270200@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-add_new_range_and_wait.patch
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

Introduce a function add_new_range_and_wait in order to avoid repetitive
code. It will be used in the following patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-16 21:22:31.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-16 21:22:31.000000000 +0200
@@ -1001,6 +1001,12 @@ static void wait_and_add_new_range(struc
 	} while (unlikely(new_range->waiting));
 }
 
+static void add_new_range_and_wait(struct dm_integrity_c *ic, struct dm_integrity_range *new_range)
+{
+	if (unlikely(!add_new_range(ic, new_range, true)))
+		wait_and_add_new_range(ic, new_range);
+}
+
 static void init_journal_node(struct journal_node *node)
 {
 	RB_CLEAR_NODE(&node->node);
@@ -1995,8 +2001,7 @@ static void do_journal_write(struct dm_i
 			io->range.n_sectors = (k - j) << ic->sb->log2_sectors_per_block;
 
 			spin_lock_irq(&ic->endio_wait.lock);
-			if (unlikely(!add_new_range(ic, &io->range, true)))
-				wait_and_add_new_range(ic, &io->range);
+			add_new_range_and_wait(ic, &io->range);
 
 			if (likely(!from_replay)) {
 				struct journal_node *section_node = &ic->journal_tree[i * ic->journal_section_entries];
@@ -2155,8 +2160,7 @@ next_chunk:
 	if (!ic->meta_dev)
 		range.n_sectors = min(range.n_sectors, ((sector_t)1U << ic->sb->log2_interleave_sectors) - (unsigned)offset);
 
-	if (unlikely(!add_new_range(ic, &range, true)))
-		wait_and_add_new_range(ic, &range);
+	add_new_range_and_wait(ic, &range);
 
 	spin_unlock_irq(&ic->endio_wait.lock);
 
