From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix inefficient allocation of
	stack space
Date: Wed, 19 Jul 2017 11:23:40 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707191122240.2305@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

When using block size greater than 512 bytes, the dm-integrity target
allocates journal space inefficiently, it allocates one entry for each
512-byte chunk of data, fills entries for each block of data and leaves
the remaining entries unused. This doesn't cause data corruption, but it
causes severe performance degradation.

This patch fixes the journal allocation. As a safety it also adds BUG that
fires if the variables representing journal usage get out of sync (it's
better to crash than continue and corrupt data, so BUG is justified).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7 ("dm: add integrity target")

---
 drivers/md/dm-integrity.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -1589,14 +1589,14 @@ retry:
 			unsigned next_entry, i, pos;
 			unsigned ws, we;
 
-			dio->range.n_sectors = min(dio->range.n_sectors, ic->free_sectors);
+			dio->range.n_sectors = min(dio->range.n_sectors, ic->free_sectors << ic->sb->log2_sectors_per_block);
 			if (unlikely(!dio->range.n_sectors))
 				goto sleep;
-			ic->free_sectors -= dio->range.n_sectors;
+			ic->free_sectors -= dio->range.n_sectors >> ic->sb->log2_sectors_per_block;
 			journal_section = ic->free_section;
 			journal_entry = ic->free_section_entry;
 
-			next_entry = ic->free_section_entry + dio->range.n_sectors;
+			next_entry = ic->free_section_entry + (dio->range.n_sectors >> ic->sb->log2_sectors_per_block);
 			ic->free_section_entry = next_entry % ic->journal_section_entries;
 			ic->free_section += next_entry / ic->journal_section_entries;
 			ic->n_uncommitted_sections += next_entry / ic->journal_section_entries;
@@ -1727,6 +1727,7 @@ static void pad_uncommitted(struct dm_in
 		wraparound_section(ic, &ic->free_section);
 		ic->n_uncommitted_sections++;
 	}
+	BUG_ON((ic->n_uncommitted_sections + ic->n_committed_sections) * ic->journal_section_entries + ic->free_sectors != ic->journal_sections * ic->journal_section_entries);
 }
 
 static void integrity_commit(struct work_struct *w)
