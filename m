From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: test for corrupted disk format
Date: Fri, 21 Jul 2017 11:58:38 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1707211158120.31337@file01.intranet.prod.int.rdu2.redhat.com>
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

If the dm-integrity superblock was corrupted in such a way that the
journal_sections field was zero, the integrity target would deadlock,
because it would wait forever for free space in the journal.

This patch detects this situation and refuses to activate the device in
this case.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 7eada909bfd7 ("dm: add integrity target")

---
 drivers/md/dm-integrity.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -3020,6 +3020,11 @@ static int dm_integrity_ctr(struct dm_ta
 		ti->error = "Block size doesn't match the information in superblock";
 		goto bad;
 	}
+	if (!le32_to_cpu(ic->sb->journal_sections)) {
+		r = -EINVAL;
+		ti->error = "Corrupted superblock, journal_sections is 0";
+		goto bad;
+	}
 	/* make sure that ti->max_io_len doesn't overflow */
 	if (ic->sb->log2_interleave_sectors < MIN_LOG2_INTERLEAVE_SECTORS ||
 	    ic->sb->log2_interleave_sectors > MAX_LOG2_INTERLEAVE_SECTORS) {
