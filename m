From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: fix invalid table returned
Date: Mon, 17 Feb 2020 08:11:35 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2002170809280.18605@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Milan Broz <mbroz@redhat.com>, David Teigland <teigland@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

If the flag SB_FLAG_RECALCULATE is present in the superblock, but it was
not specified on the command line (i.e. ic->recalculate_flag is false),
dm-integrity would return invalid table line - the reported number of
arguments would not match the real number.

This patch fixes the argument mismatch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Ondrej Kozina <okozina@redhat.com>
Cc: stable@vger.kernel.org	# v5.2+
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")

---
 drivers/md/dm-integrity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2020-02-14 17:19:16.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2020-02-17 13:58:05.000000000 +0100
@@ -2982,7 +2982,7 @@ static void dm_integrity_status(struct d
 			DMEMIT(" meta_device:%s", ic->meta_dev->name);
 		if (ic->sectors_per_block != 1)
 			DMEMIT(" block_size:%u", ic->sectors_per_block << SECTOR_SHIFT);
-		if (ic->recalculate_flag)
+		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING))
 			DMEMIT(" recalculate");
 		DMEMIT(" journal_sectors:%u", ic->initial_sectors - SB_SECTORS);
 		DMEMIT(" interleave_sectors:%u", 1U << ic->sb->log2_interleave_sectors);
