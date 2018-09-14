From: Nicholas Mc Guire <hofrat@osadl.org>
Subject: [PATCH] dm integrity: drop excess unlikely() from BUG_ON()
Date: Fri, 14 Sep 2018 09:37:03 +0200
Message-ID: <1536910623-18013-1-git-send-email-hofrat@osadl.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Nicholas Mc Guire <hofrat@osadl.org>
List-Id: dm-devel.ids

 include/asm-generic/bug.h defines BUG_ON(condition) as
do { if (unlikely(condition)) BUG(); } while (0).
So BUG_ON already provides unlikely() on the condition thus 
there is no point in having BUG_ON(unlikely(condition)),
thus simply drop the excess unlikely().

Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
---

Found during code review

Patch was compile tested with: x86_64_defconfig + SCSI_LOWLEVEL=y,
DM_INTEGRITY=y
(with warnings from sparse and smatch - not related to the proposed
 change though)

Patch is against 4.19-rc3 (localversion-next is next-20180913)

 drivers/md/dm-integrity.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 89ccb64..8574e73 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1948,7 +1948,8 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 
 			if (journal_entry_is_unused(je))
 				continue;
-			BUG_ON(unlikely(journal_entry_is_inprogress(je)) && !from_replay);
+			BUG_ON(journal_entry_is_inprogress(je) &&
+			       !from_replay);
 			sec = journal_entry_get_sector(je);
 			if (unlikely(from_replay)) {
 				if (unlikely(sec & (unsigned)(ic->sectors_per_block - 1))) {
@@ -1963,7 +1964,8 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				sector_t sec2, area2, offset2;
 				if (journal_entry_is_unused(je2))
 					break;
-				BUG_ON(unlikely(journal_entry_is_inprogress(je2)) && !from_replay);
+				BUG_ON(journal_entry_is_inprogress(je2) &&
+				       !from_replay);
 				sec2 = journal_entry_get_sector(je2);
 				get_area_and_offset(ic, sec2, &area2, &offset2);
 				if (area2 != area || offset2 != offset + ((k - j) << ic->sb->log2_sectors_per_block))
-- 
2.1.4
