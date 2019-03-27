From: zhengbin <zhengbin13@huawei.com>
Subject: [PATCH] md: remove unnecessary unlikely()
Date: Wed, 27 Mar 2019 14:31:37 +0800
Message-ID: <1553668297-82871-1-git-send-email-zhengbin13@huawei.com>
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
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: zhengbin13@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com
List-Id: dm-devel.ids

BUG_ON() already contains an unlikely(), there is no need for another one.

Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index d57d997..7f03638 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1959,7 +1959,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,

 			if (journal_entry_is_unused(je))
 				continue;
-			BUG_ON(unlikely(journal_entry_is_inprogress(je)) && !from_replay);
+			BUG_ON(journal_entry_is_inprogress(je) && !from_replay);
 			sec = journal_entry_get_sector(je);
 			if (unlikely(from_replay)) {
 				if (unlikely(sec & (unsigned)(ic->sectors_per_block - 1))) {
@@ -1974,7 +1974,7 @@ static void do_journal_write(struct dm_integrity_c *ic, unsigned write_start,
 				sector_t sec2, area2, offset2;
 				if (journal_entry_is_unused(je2))
 					break;
-				BUG_ON(unlikely(journal_entry_is_inprogress(je2)) && !from_replay);
+				BUG_ON(journal_entry_is_inprogress(je2) && !from_replay);
 				sec2 = journal_entry_get_sector(je2);
 				get_area_and_offset(ic, sec2, &area2, &offset2);
 				if (area2 != area || offset2 != offset + ((k - j) << ic->sb->log2_sectors_per_block))
--
2.7.4
